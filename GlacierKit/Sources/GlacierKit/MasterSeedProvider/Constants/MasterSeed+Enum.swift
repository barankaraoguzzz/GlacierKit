//
//  File.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 2.03.2025.
//

import Foundation

/// An enum contains erros cases for "Master Seed" generation
public enum MasterSeedErrorTypes: Error, Equatable, CustomStringConvertible {
    case invalidInput
    
    public var description: String {
        switch self {
        case .invalidInput:
            "invalidInput"
        }
    }
}
