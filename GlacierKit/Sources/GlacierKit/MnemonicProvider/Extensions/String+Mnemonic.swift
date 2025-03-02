//
//  File.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 10.02.2025.
//

import Foundation

extension String {
    
    /// Pads the string with leading zeros until it reaches the specified size.
    /// - Parameters:
    ///   - toSize: The desired length of the string after padding.
    /// - Returns:
    ///   - A new string padded with leading zeros if its original length is less than `toSize`.
    ///   - If the string's length is already greater than or equal to `toSize`, the original string is returned unchanged.
    ///
    /// - Example:
    ///   ```
    ///   let binaryString = "101"
    ///   let paddedString = binaryString.pad(toSize: 8)
    ///   print(paddedString) // Output: "00000101"
    ///   ```
    func pad(toSize: Int) -> String {
        guard self.count < toSize else { return self }
        var padded = self
        for _ in 0..<(toSize - self.count) {
            padded = "0" + padded
        }
        return padded
    }
    
    /// Converts a bit string (a string of binary digits) into a `Data` object.
    /// - Returns:
    ///   - A `Data` object containing the bytes derived from the bit string.
    ///   - Returns `nil` if the bit string's length is not a multiple of 8 or if any substring cannot be converted to a byte.
    ///
    /// - Example:
    ///   ```
    ///   let bitString = "0100000101000010" // Represents 'A' and 'B' in ASCII
    ///   let data = bitString.bitStringToBytes()
    ///   print(data) // Output: Optional(<4142>)
    ///   ```
    func bitStringToBytes() -> Data? {
        let length = 8
        guard self.count % length == 0 else {
            return nil
        }
        var data = Data(capacity: self.count)

        for i in 0 ..< self.count / length {
            let startIdx = self.index(self.startIndex, offsetBy: i * length)
            let subArray = self[startIdx ..< self.index(startIdx, offsetBy: length)]
            let subString = String(subArray)
            guard let byte = UInt8(subString, radix: 2) else {
                return nil
            }
            data.append(byte)
        }
        return data
    }
    
}
