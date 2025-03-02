//
//  PKCSKeyDeriver.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 2.03.2025.
//

import CommonCrypto
import Foundation

/// A type that provides derivetion functions for PKCS "Public-Key Cryptography Standards"
public protocol PKCSKeyDeriverProtocol {
    func deriveKey(password: Data, salt: Data, iterations: Int, keyLength: Int) throws -> [UInt8]
}

/// In cryptography, PKCS stands for "Public Key Cryptography Standards".
/// PKCS5 is "Password-based Encryption Standard"
/// See: https://en.wikipedia.org/wiki/PKCS
public final class PKCS5: PKCSKeyDeriverProtocol {
    
    public init() {}
    
    public enum Error: Swift.Error {
        case invalidInput
        case memoryFailure
        case parameterError
        case unknown(status: Int32)
    }
    
    /// Generate a deterministic seed string from the given inputs.
    /// PBKDF2 applies a pseudorandom function, such as hash-based message authentication code (HMAC), to the input password or passphrase along with a salt value and repeats the process many times to produce a derived key, which can then be used as a cryptographic key in subsequent operations. The added computational work makes password cracking much more difficult, and is known as key stretching.
    /// - Parameters:
    ///   - password: The password or passphrase used as input.
    ///   - salt: A cryptographic salt to introduce randomness.
    ///   - iterations: The number of iterations to apply (higher = more secure but slower).
    ///   - keyLength: The length of the derived key in bytes.
    /// - Returns: A derived key of the specified length.
    /// - Throws: An error if key derivation fails.
    /// See: https://en.wikipedia.org/wiki/PBKDF2
    public func deriveKey(password: Data, salt: Data, iterations: Int = 2_048, keyLength: Int = 64) throws -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: keyLength)
        let passwordBytes = password.map { Int8(bitPattern: $0) }
        let saltDataBytes = [UInt8](salt)

        try bytes.withUnsafeMutableBytes { (outputBytes: UnsafeMutableRawBufferPointer) in
            let status = CCKeyDerivationPBKDF(
                CCPBKDFAlgorithm(kCCPBKDF2),
                passwordBytes,
                passwordBytes.count,
                saltDataBytes,
                salt.count,
                CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512),
                UInt32(iterations),
                outputBytes.baseAddress?.assumingMemoryBound(to: UInt8.self),
                keyLength
            )
            guard status == (kCCSuccess) else {
                switch Int(status) {
                case kCCParamError: throw Error.parameterError
                case kCCMemoryFailure: throw Error.memoryFailure
                default: throw Error.unknown(status: status)
                }
            }
        }
        return bytes
    }
}
