//
//  MnemonicVectorParser.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 2.03.2025.
//

import Foundation

// Represents a single mnemonic test vector.
struct MnemonicTestVector: Decodable {
    let entropy: String     // The entropy value in hexadecimal format.
    let mnemonic: String    // The mnemonic phrase derived from entropy.
    let passphrase: String  // The passphrase used for additional security.
    let seed: String        // The seed generated from the mnemonic and passphrase.
    let bip32Xprv: String   // The BIP32 extended private key.

    // Maps JSON keys to Swift property names.
    enum CodingKeys: String, CodingKey {
        case entropy, mnemonic, passphrase, seed
        case bip32Xprv = "bip32_xprv"  // JSON uses "bip32_xprv", but we map it to "bip32Xprv".
    }
}

// Defines a protocol for parsing mnemonic test vectors.
protocol MnemonicVectorParsable {
    func getTestVector(at index: Int) throws -> MnemonicTestVector // Retrieves a specific test vector by index.
    func getTestCases() -> [MnemonicTestVector] // Returns all parsed test cases.
}

// Implements the MnemonicVectorParsable protocol to parse and store test vectors.
final class MnemonicVectorParser: MnemonicVectorParsable {
    
    // Defines possible errors that can occur during parsing or retrieval.
    enum ErrorTypes: Error {
        case fileNotFound  // Raised when the JSON file cannot be found.
        case caseNotFount  // Raised when the requested test case index is out of bounds.
    }

    let testVectors: [MnemonicTestVector] // Stores the parsed test vectors.

    // Initializes the parser and loads data from the specified JSON file.
    init(from fileName: String = "mnemonic_vectors") throws {
        // Locate the JSON file within the module bundle.
        guard let url = Bundle.module.url(forResource: fileName, withExtension: "json") else {
            throw ErrorTypes.fileNotFound
        }
        
        // Read and decode the JSON file into an array of MnemonicTestVector.
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let parsedVectors = try decoder.decode([MnemonicTestVector].self, from: data)
        self.testVectors = parsedVectors
    }

    // Retrieves a specific test vector by its index, throwing an error if the index is invalid.
    func getTestVector(at index: Int) throws -> MnemonicTestVector {
        guard testVectors.indices.contains(index) else {
            throw ErrorTypes.caseNotFount
        }
        return testVectors[index]
    }

    // Returns all parsed test cases.
    func getTestCases() -> [MnemonicTestVector] {
        return testVectors
    }
}
