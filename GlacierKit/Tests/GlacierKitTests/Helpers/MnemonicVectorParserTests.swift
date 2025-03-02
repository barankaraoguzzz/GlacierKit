//
//  MnemonicVectorParserTests.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 2.03.2025.
//

import Foundation
import Testing

struct MnemonicVectorParserTests {
    
    let parser: MnemonicVectorParsable
    
    init(parser: MnemonicVectorParsable = MnemonicVectorParser.createDefault()) throws {
        self.parser = parser
    }
    
    @Test
    func testCasesCount() {
        #expect(parser.getTestCases().count == 24)
    }
    
    @Test
    func testEntropyTypeParsing() throws {
        let expectedFirstEntropy = try parser.getTestVector(at: 0).entropy == "00000000000000000000000000000000"
        let unexpectedSecondEntropy = try parser.getTestVector(at: 1).entropy == "80808080808080808080808080808080"
        
        
        #expect(expectedFirstEntropy)
        #expect(!unexpectedSecondEntropy)
    }
    
    @Test
    func testMnemonicTypeParsing() throws {
        let expectedFirstMnemonic = try parser.getTestVector(at: 0).mnemonic == "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
        let unexpectedLastMnemonic = try parser.getTestVector(at: 23).mnemonic == "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
        
        
        #expect(expectedFirstMnemonic)
        #expect(!unexpectedLastMnemonic)
    }
    
    @Test
    func testMasterSeedTypeParsing() throws {
        let expectedFirstMasterSeed = try parser.getTestVector(at: 0).seed == "c55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04"
        let unexpectedLastMasterSeed = try parser.getTestVector(at: 23).seed == "c55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04"
        
        
        #expect(expectedFirstMasterSeed)
        #expect(!unexpectedLastMasterSeed)
    }
    
    @Test
    func testExtendedKeyTypeParsing() throws {
        let expectedFirstExtendedKey = try parser.getTestVector(at: 0).bip32Xprv == "xprv9s21ZrQH143K3h3fDYiay8mocZ3afhfULfb5GX8kCBdno77K4HiA15Tg23wpbeF1pLfs1c5SPmYHrEpTuuRhxMwvKDwqdKiGJS9XFKzUsAF"
        let unexpectedLastExtendedKey = try parser.getTestVector(at: 23).bip32Xprv == "xprv9s21ZrQH143K3h3fDYiay8mocZ3afhfULfb5GX8kCBdno77K4HiA15Tg23wpbeF1pLfs1c5SPmYHrEpTuuRhxMwvKDwqdKiGJS9XFKzUsAF"
        
        
        #expect(expectedFirstExtendedKey)
        #expect(!unexpectedLastExtendedKey)
    }
    
}

extension MnemonicVectorParser {
    static func createDefault() -> MnemonicVectorParsable {
        return (try! MnemonicVectorParser(from: "mnemonic_vectors"))
    }
}
