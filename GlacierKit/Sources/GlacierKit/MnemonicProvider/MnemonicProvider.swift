//
//  MnemonicProvider.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 9.02.2025.
//

import Foundation
import CryptoKit

/// A type can be provide Mnemonic words and seed. validate mnemonics
public protocol MnemonicProvidable {
    func getWords(wordsCount: MnemonicWordCount) throws -> [String]
}

/// Validate mnemonic word validate method for testing and user experience
public protocol MnemonicValidateable {
    func validateMnemonicWord(_ word: String) -> Bool
    func validate(mnemonicWords: [String]) throws
}

/// A type can be genereta Mnemonic codes describes in BIP39
public final class Bip39: MnemonicProvidable, MnemonicValidateable {
    
    private let language: MnemonicLanguageType
    
    public init(language: MnemonicLanguageType = .english) {
        self.language = language
    }
        
    // MARK: - Private Methods
    
    /// Generates a mnemonic phrase from the given entropy.
    /// - Parameters:
    ///   - entropy: A random byte array generated from a secure enclave. All word is 11 bit for 2048 word iteration
    /// - Throws:
    ///   - `MnemonicErrorTypes.errorMnemonicDataCreationFromHexString` if the mnemonic data cannot be created from the hex string.
    ///   - `MnemonicErrorTypes.errorStringToBitIndex` if the bit string cannot be converted to an index.
    /// - Returns:
    ///   - An array of mnemonic words derived from the entropy.
    private func generateWords(from entropy : [UInt8]) throws -> [String] {
        let hexString = entropy.hexString
        guard let mnemonicData = createMemonicData(from: hexString) else { throw MnemonicErrorTypes.mnemonicDataCreationFromHexString }
        let hashData = SHA256.hash(data: mnemonicData)
        let checkSumBits = hashData.bytes.toBitArray()
        var mnemonicBits = mnemonicData.toBitArray()
        
        for i in 0 ..< mnemonicBits.count / 32 {
            mnemonicBits.append(checkSumBits[i])
        }
        
        let words = language.words()
        
        let mnemonicCount = mnemonicBits.count / 11
        var mnemonicWords = [String]()
        for i in 0 ..< mnemonicCount {
            let length = 11
            let startIndex = i * length
            let subArray = mnemonicBits[startIndex ..< startIndex + length]
            let subString = subArray.joined(separator: "")
            
            guard let index = Int(subString, radix: 2) else {
                throw MnemonicErrorTypes.stringToBitIndex
            }
            mnemonicWords.append(words[index])
        }
        
        return mnemonicWords
    }
    
    /// Converts a hexadecimal string into `Data`.
    /// - Parameters:
    ///   - hexString: The hexadecimal string to be converted.
    /// - Returns:
    ///   - `Data` object if the conversion is successful, otherwise `nil`.
    /// - Note:
    ///   - The input string must have an even number of characters to be valid.
    ///   - Each pair of characters in the string represents a byte in the resulting `Data`.
    private func createMemonicData(from hexString: String) -> Data? {
        guard hexString.count % 2 == 0 else { return nil }
        let length = hexString.count
        let dataLength = length / 2
        var dataToReturn = Data(capacity: dataLength)

        var outIndex = 0
        var outChars = ""
        for (_, char) in hexString.enumerated() {
            outChars += String(char)
            if outIndex % 2 == 1 {
                guard let i = UInt8(outChars, radix: 16) else { return nil }
                dataToReturn.append(i)
                outChars = ""
            }
            outIndex += 1
        }

        return dataToReturn
    }
    
    /// Validate that the given string is a valid mnemonic phrase according to BIP-39
    /// - Parameters:
    ///  - mnemonicWords: a mnemonical words
    /// - Throws:
    ///  - `MnemonicError.wrongWordCount` if the word count is invalid
    ///  - `MnemonicError.invalidWord(word: word)` this phase as a word that's not represented in this library's vocabulary for the detected language.
    ///  - `MnemonicError.unsupportedLanguage` if the given phrase language isn't supported or couldn't be infered
    ///  - `throw MnemonicError.checksumError` if the given phrase has an invalid checksum
    private func validate(_ mnemonicWords: [String]) throws {
        guard !mnemonicWords.isEmpty else {
            throw MnemonicErrorTypes.emptyWordCount
        }
        
        guard let wordCount = MnemonicWordCount(rawValue: mnemonicWords.count) else {
            throw MnemonicErrorTypes.wrongWordCount
        }
        
        // determine the language of the seed or fail
        let language = try determineLanguage(from: mnemonicWords)
        let vocabulary = language.words()
        
        var seedBits = ""
        for word in mnemonicWords {
            guard let indexInVocabulary = vocabulary.firstIndex(of: word) else {
                throw MnemonicErrorTypes.invalidWord
            }
            
            let binaryString = String(indexInVocabulary, radix: 2).pad(toSize: 11)
            seedBits.append(contentsOf: binaryString)
        }
        
        let checksumLength = mnemonicWords.count / 3
        guard checksumLength == wordCount.checksumLength else {
            throw MnemonicErrorTypes.invalidChecksumLength
        }
        
        let dataBitsLength = seedBits.count - checksumLength
        let dataBits = String(seedBits.prefix(dataBitsLength))
        let checksumBits = String(seedBits.suffix(checksumLength))
        
        guard let dataBytes = dataBits.bitStringToBytes() else {
            throw MnemonicErrorTypes.checksumMismatch
        }
        
        let hash = SHA256.hash(data: dataBytes)
        let hashBits = hash.bytes.toBitArray().joined(separator: "").prefix(checksumLength)
        
        guard hashBits == checksumBits else {
            throw MnemonicErrorTypes.checksumMismatch
        }
        
    }
    
    /// Detect mnemocWords language type
    /// - Parameters:
    ///  - mnemonicWords: a mnemonical words
    /// - Throws:
    ///  - `MnemonicError.unsupportedLanguage` if the given phrase language isn't supported or couldn't be infered
    /// - Returns:
    ///  - `MnemonicLanguage`language Type
    private func determineLanguage(from mnemonicWords: [String]) throws -> MnemonicLanguageType {
        guard mnemonicWords.count > 0 else {
            throw MnemonicErrorTypes.wrongWordCount
        }
        
        if String.englishMnemonics.contains(mnemonicWords[0]) {
            return .english
        } else {
            throw MnemonicErrorTypes.unsupportLanguage
        }
    }
    
    // MARK: - Public Methods
    
    /// Generate a random mnemonical words array..
    ///
    /// - Parameters:
    ///   - wordsCount: MnemonicWordCount enum type has three type for words count. 12, 18, 24
    public func getWords(wordsCount: MnemonicWordCount) throws -> [String] {
        var entropyBytes = [UInt8](repeating: 0, count: wordsCount.entropyByteCount)
        guard SecRandomCopyBytes(kSecRandomDefault, wordsCount.entropyByteCount, &entropyBytes) == errSecSuccess else {
            throw MnemonicErrorTypes.entropyBytesCreation
        }
        
        return try generateWords(from: entropyBytes)
    }
    
    /// This method checks whether the word you give as a parameter is in the mnomic word list.
    /// - Parameter word: your suggestion mnemonic word
    /// - Returns: Bool
    public func validateMnemonicWord(_ word: String) -> Bool {
        let vocabulary = language.words()
        return vocabulary.firstIndex(of: word) != nil ? true : false
    }
    
    public func validate(mnemonicWords: [String]) throws {
        try self.validate(mnemonicWords)
    }
    
}
