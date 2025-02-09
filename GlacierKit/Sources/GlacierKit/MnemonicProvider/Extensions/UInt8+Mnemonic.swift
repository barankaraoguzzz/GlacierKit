//
//  UInt8+Mnemonical.swift
//
//  Created by Baran Karaoğuz on 9.02.2025.
//

import Foundation

public extension UInt8 {
    /// Converts the UInt8 value to an array of bits represented as strings ("0" or "1").
    /// - Returns: An array of 8 strings, each representing a bit of the UInt8 value.
    func mnemonicBits() -> [String] {
        let totalBitsCount = MemoryLayout<UInt8>.size * 8

        var bitsArray = [String](repeating: "0", count: totalBitsCount)

        for bitPosition in 0 ..< totalBitsCount {
            let bitVal: UInt8 = 1 << UInt8(totalBitsCount - 1 - bitPosition)
            let isBitSet = (self & bitVal) != 0

            if isBitSet {
                bitsArray[bitPosition] = "1"
            }
        }
        return bitsArray
    }
}
