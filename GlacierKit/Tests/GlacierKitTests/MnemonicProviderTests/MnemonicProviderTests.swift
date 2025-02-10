//
//  Test.swift
//  GlacierKit
//
//  Created by Baran Karaoğuz on 9.02.2025.
//

import Testing
import GlacierKit

struct Test {
    
    private var mnemonicProvider: (MnemonicProvidable & MnemonicValidateable)!
    
    init() {
        self.mnemonicProvider = Bip39()
    }

    @Test func test_create_mnemonic_words() async throws {
        #expect(throws: Never.self, performing: {
            let _ = try mnemonicProvider.getWords(wordsCount: .twelve)
            let _ = try mnemonicProvider.getWords(wordsCount: .eighteen)
            let _ = try mnemonicProvider.getWords(wordsCount: .twentyFour)
        })
    }
    
    @Test func test_generate_mnemonic_words_count() async throws {
        #expect(throws: Never.self, performing: {
            let twelveCount = try mnemonicProvider.getWords(wordsCount: .twelve).count
            let eighteenCount = try mnemonicProvider.getWords(wordsCount: .eighteen).count
            let twentyFourCount = try mnemonicProvider.getWords(wordsCount: .twentyFour).count
            
            #expect(twelveCount == 12)
            #expect(eighteenCount == 18)
            #expect(twentyFourCount == 24)
        })        
    }
    
    @Test func testValidateMnemonicWithWrongWordCount() async throws {
        let invalidWordCountMnemonic = [
            "pear", "peasant", "pelican", "pen"
        ]
        
        #expect(throws: MnemonicErrorTypes.wrongWordCount, performing: {
            try mnemonicProvider.validate(mnemonicWords: invalidWordCountMnemonic)
        })
    }
    
    @Test func testValidateMnemonicWithUnsupportedLanguage() async throws {
        let unsupportedLanguageMnemonic = [
            "Baran", "flash", "tobacco", "flash", "flash", "tobacco", "flash", "tobacco", "flash", "tobacco", "flash", "tobacco"
        ]
        
        #expect(throws: MnemonicErrorTypes.unsupportLanguage, performing: {
            try mnemonicProvider.validate(mnemonicWords: unsupportedLanguageMnemonic)
        })
    }
    
    @Test func testValidateEmptyMnemonic() async throws {
        let emptyMnemonic: [String] = []
        
        #expect(throws: MnemonicErrorTypes.emptyWordCount, performing: {
            try mnemonicProvider.validate(mnemonicWords: emptyMnemonic)
        })
    }
    
    @Test func testValidateInvalidMnemonicWords() async throws {
        #expect(mnemonicProvider.validateMnemonicWord("Baran") == false)
        #expect(mnemonicProvider.validateMnemonicWord("Pen") == false)
        #expect(mnemonicProvider.validateMnemonicWord("*pen") == false)
        #expect(mnemonicProvider.validateMnemonicWord("peasant1") == false)
    }
    
    @Test func testValidateValidMnemonicWords() async throws {
        #expect(mnemonicProvider.validateMnemonicWord("pen") == true)
        #expect(mnemonicProvider.validateMnemonicWord("ahead") == true)
    }
    
    @Test func testValidateValidMnemonicPhrase() async throws {
        let validEighteenCountMnemonicPhrase = [
            "scissors", "invite", "lock", "maple", "supreme", "raw", "rapid", "void", "congress",
            "muscle", "digital", "elegant", "little", "brisk", "hair", "mango", "congress", "clump"
        ]
        
        let validTwelveCountMnemonicPhrase = [
            "legal", "winner", "thank", "year", "wave", "sausage", "worth", "useful", "legal", "winner", "thank", "yellow"
        ]
        
        #expect(throws: Never.self, performing: {
            try mnemonicProvider.validate(mnemonicWords: validEighteenCountMnemonicPhrase)
            try mnemonicProvider.validate(mnemonicWords: validTwelveCountMnemonicPhrase)
        })
    }

}
