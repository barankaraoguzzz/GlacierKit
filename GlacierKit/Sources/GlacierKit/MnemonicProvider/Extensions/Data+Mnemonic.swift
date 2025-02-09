//
//  Data+Mnemonical.swift
//
//  Created by Baran Karaoğuz on 9.02.2025.
//

import Foundation

public extension Data {
    func toBitArray() -> [String] {
        var toReturn = [String]()
        for num in [UInt8](self) {
            toReturn.append(contentsOf: num.mnemonicBits())
        }
        return toReturn
    }
}
