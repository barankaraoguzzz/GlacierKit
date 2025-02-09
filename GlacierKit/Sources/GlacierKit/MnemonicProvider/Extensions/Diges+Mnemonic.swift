//
//  Diges+Mnemonical.swift
//
//  Created by Baran Karaoğuz on 9.02.2025.
//

import Foundation
import CryptoKit

extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }
    var hexString: String {
        bytes.hexString
    }
}
