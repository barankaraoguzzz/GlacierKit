//
//  MasterSeedProvider.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 2.03.2025.
//

import Foundation

public protocol MasterSeedProviderProtocol {
    func getMasterSeed(words: [String], passphrase: String) throws -> String
}

public final class MasterSeedProvider: MasterSeedProviderProtocol {
    
    private let keyDeriver: PKCSKeyDeriverProtocol
    private let mnemonicValidator: MnemonicValidateable
    
    public init(keyDeriver: PKCSKeyDeriverProtocol = PKCS5(), mnemonicValidator: MnemonicValidateable = Bip39()) {
        self.keyDeriver = keyDeriver
        self.mnemonicValidator = mnemonicValidator
    }
    
    /// Generate a deterministic master seed string from the given inputs.
    ///
    /// - Parameters:
    ///   - words: The mnemonic provider words.
    ///   - passphrase: An optional passphrase. Default is the empty string.
    /// - Returns:
    ///  - `String`generated  master seed key
    public func getMasterSeed(words: [String], passphrase: String = "") throws -> String {
        try mnemonicValidator.validate(mnemonicWords: words)
        
        let normalizedMnemonic = words.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedData = try self.normalizedData(from: normalizedMnemonic)
        let saltData = try self.normalizedData(from: "mnemonic" + passphrase)
        
        let bytes = try keyDeriver.deriveKey(password: normalizedData, salt: saltData, iterations: 2_048, keyLength: 64)
        return bytes.hexString
    
    }
    
    /// Change a string into data.
    /// - Parameters:
    ///  - string: the string to convert
    /// - Throws: `
    ///  - `MnemonicError.invalidInput` if the given String cannot be converted to Data
    /// - Returns:
    ///  - `Data`the utf8 encoded data
    private func normalizedData(from string: String) throws -> Data {
        guard let data = string.data(using: .utf8, allowLossyConversion: false) else {
            throw MasterSeedErrorTypes.invalidInput
        }
        return data
    }
    
    
}
