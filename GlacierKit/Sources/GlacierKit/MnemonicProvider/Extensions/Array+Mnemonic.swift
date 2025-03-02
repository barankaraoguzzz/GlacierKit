//
//  Array+Mnemonical.swift
//
//  Created by Baran Karaoğuz on 9.02.2025.
//

import Foundation


extension Array where Element == UInt8 {
    func toBitArray() -> [String] {
        var toReturn = [String]()
        for num in self {
            toReturn.append(contentsOf: num.mnemonicBits())
        }
        return toReturn
    }
}
