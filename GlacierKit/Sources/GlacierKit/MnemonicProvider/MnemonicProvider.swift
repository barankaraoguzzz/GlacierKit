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

/// A type can be genereta Mnemonic codes describes in BIP39
public final class Bip39: MnemonicProvidable {
    
    private let language: MnemonicLanguageType
    
    public init(language: MnemonicLanguageType = .english) {
        self.language = language
    }
        
    // MARK: - Private Methods
    /// Generate a mnemonic words from entropy. Entropy is random byte array from secure enclave All word is 11 bit for 2048 word iteration.
    private func generateWords(from entropy : [UInt8]) throws -> [String] {
        let hexString = entropy.hexString
        guard let mnemonicData = createMemonicData(from: hexString) else { throw MnemonicErrorTypes.errorMnemonicDataCreationFromHexString }
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
                throw MnemonicErrorTypes.errorStringToBitIndex
            }
            mnemonicWords.append(words[index])
        }
        
        return mnemonicWords
    }
    
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
    
    // MARK: - Public Methods
    
    /// Generate a random mnemonical words array..
    ///
    /// - Parameters:
    ///   - wordsCount: MnemonicWordCount enum type has three type for words count. 12, 18, 24
    public func getWords(wordsCount: MnemonicWordCount) throws -> [String] {
        var entropyBytes = [UInt8](repeating: 0, count: wordsCount.entropyByteCount)
        guard SecRandomCopyBytes(kSecRandomDefault, wordsCount.entropyByteCount, &entropyBytes) == errSecSuccess else {
            throw MnemonicErrorTypes.errorEntropyBytesCreation
        }
        
        return try generateWords(from: entropyBytes)
    }
    
}
