//
//  MasterSeedProviderTests.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 2.03.2025.
//

import Testing
import GlacierKit
import Foundation

struct MasterSeedProviderTests {
        
    let masterSeedProvider: MasterSeedProviderProtocol
    let parser: MnemonicVectorParsable
    
    init(
        masterSeedProvider: MasterSeedProviderProtocol = MasterSeedProvider(),
        parser: MnemonicVectorParsable = try! MnemonicVectorParser()
    ) throws {
        self.masterSeedProvider = masterSeedProvider
        self.parser = parser
    }
    
    @Test func testGenerateMasterSeedFromVectors() throws {
        let testCases = parser.getTestCases()
        
        #expect(
            throws: Never.self,
            performing: {
                try testCases.enumerated().forEach { testCaseModel in
                    let mnemonicsString = try parser.getTestVector(at: testCaseModel.offset).mnemonic
                    let mnemonicsArray = mnemonicsString.components(separatedBy: " ")
                    let masterSeed = try masterSeedProvider.getMasterSeed(
                        words: mnemonicsArray,
                        passphrase: try parser.getTestVector(at: testCaseModel.offset).passphrase
                    )
                    let resultMasterSeed = try  parser.getTestVector(at: testCaseModel.offset).seed
                    #expect(masterSeed == resultMasterSeed)
                }
            })
    }
    
}
