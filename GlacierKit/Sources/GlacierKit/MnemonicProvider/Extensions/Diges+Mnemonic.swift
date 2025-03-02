//
//  Diges+Mnemonical.swift
//
//  Created by Baran Karaoğuz on 9.02.2025.
//

import Foundation
import CryptoKit

extension Digest {
    /// Converts the digest into an array of bytes.
    /// - Returns: An array of `UInt8` representing the digest's raw bytes.
    var bytes: [UInt8] {
        Array(makeIterator())
    }
    
    /// Converts the digest into a `Data` object.
    /// - Returns: A `Data` object containing the digest's raw bytes.
    var data: Data {
        Data(bytes)
    }
    
    /// Converts the digest into a hexadecimal string representation.
    /// - Returns: A hexadecimal string representation of the digest's bytes.
    var hexString: String {
        bytes.hexString
    }
}
