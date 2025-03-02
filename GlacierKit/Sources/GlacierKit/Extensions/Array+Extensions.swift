//
//  File.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 2.03.2025.
//

import Foundation

extension Array where Element == UInt8 {
    
    var hexString: String {
        self.map { String(format: "%02x", $0) }.joined()
    }
    
}
