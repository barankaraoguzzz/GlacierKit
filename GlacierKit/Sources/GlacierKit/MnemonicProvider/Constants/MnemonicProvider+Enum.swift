//
//  MnemonicProvider+Enum.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 9.02.2025.
//

import Foundation

public protocol MnemonicWordCountable {
    /// The length of the entropy in bits.
    var entropyBitLength: Int { get }
    
    /// The length of the entropy in bytes.
    var entropyByteCount: Int { get }
    
    /// The length of the checksum in bits.
    var checksumLength: Int { get }
}

public enum MnemonicWordCount: Int {
    case twelve = 12
    case eighteen = 18
    case twentyFour = 24
}

extension MnemonicWordCount: MnemonicWordCountable {
    /// Calculates the entropy bit length based on the number of words.
    /// For every 3 words, there are 32 bits of entropy.
    public var entropyBitLength: Int {
        rawValue / 3 * 32
    }
    
    /// Converts the entropy bit length to bytes.
    /// Since 1 byte = 8 bits, we divide the bit length by 8.
    public var entropyByteCount: Int {
        entropyBitLength / 8
    }

    /// Calculates the checksum length in bits.
    /// The checksum length is equal to the number of words divided by 3.
    public var checksumLength: Int {
        rawValue / 3
    }
}


public enum MnemonicLanguageType: CaseIterable {
    case english
    
    /// Returns the list of mnemonic words for the selected language.
    /// - Returns: An array of strings containing the mnemonic words.
    func words() -> [String] {
        switch self {
        case .english:
            // Returns the English mnemonic words.
            return String.englishMnemonics
        }
    }
}


/// An enum contains erros cases for Mnemoic word generation
public enum MnemonicErrorTypes: Error, Equatable {
    case errorEntropyBytesCreation
    case errorMnemonicDataCreationFromHexString
    case errorStringToBitIndex
    
    public var name: String {
        switch self {
        case .errorEntropyBytesCreation:
            "errorEntropyBytesCreation"
        case .errorMnemonicDataCreationFromHexString:
            "errorMnemonicDataCreationFromHexString"
        case .errorStringToBitIndex:
            "errorStringToBitIndex"
        }
    }
}
