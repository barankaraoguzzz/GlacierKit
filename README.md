# GlacierKit 🧊

**Bitcoin Cold Wallet Components in Swift | BIP39, BIP32, BIP44, BIP84 Support**

[![Swift](https://img.shields.io/badge/Swift-5.7-orange.svg)](https://swift.org)  [![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)  [![Medium](https://img.shields.io/badge/Medium-Articles-brown.svg)](https://medium.com/@barankaraoguz)

GlacierKit is an open-source Swift library designed for building **Bitcoin cold wallet components**. It provides essential functionality such as mnemonic seed generation, master seed derivation, and extended key management based on BIP standards.

**GitHub Repo:** [barankaraoguzzz/GlacierKit](https://github.com/barankaraoguzzz/GlacierKit)  
**Medium Series:** [Develop a Bitcoin Wallet with Swift](https://medium.com/@barankaraoguz)

---

## 🌟 Features

- **BIP39-Compliant Mnemonic Seed**  
  Generate and validate 12/18/24-word mnemonic phrases.

- **BIP32 Master Seed Derivation**  
  Derive deterministic master seed from mnemonic using PBKDF2.

- **Extended Key Support** *(Coming Soon!)*  
  Hierarchical deterministic (HD) wallet structure based on BIP32.

- **Unit Tests**  
  Extensive test coverage using Trezor test vectors.

- **Modular Architecture**  
  Protocol-oriented design for easy extensibility.

---

## 📚 Medium Articles

1. [Generate a Mnemonic Seed](https://medium.com/@barankaraoguz/develop-a-bitcoin-wallet-with-swift-generate-a-mnemonic-seed-5aa70a8b49ef)  
2. [Create a Master Seed](https://medium.com/@barankaraoguz/develop-a-bitcoin-wallet-with-swift-creating-a-master-seed-8a77e03d60fa)  
3. [Extended Keys & HD Wallets](https://medium.com/@barankaraoguz) (*Coming Soon!*)

---

## ⚡ Quick Start

### Installation (Swift Package Manager)

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/barankaraoguzzz/GlacierKit.git", from: "1.0.0")
]
```

## 🧪 Example Usage

### Generate a Mnemonic Seed

```swift
let bip39 = Bip39()
let mnemonic = try bip39.getWords(wordsCount: .twelve)
print("Mnemonic: \(mnemonic.joined(separator: " "))")
// Example Output: "abandon abandon ... about"
```
### Derive a Master Seed
```swift
let provider = MasterSeedProvider()
let masterSeed = try provider.getMasterSeed(words: mnemonic, passphrase: "TREZOR")
print("Master Seed: \(masterSeed)")
// Example Output: "c55257c360c07c7..."
```

---

## 🛠 Technical Details

| BIP Standard | Description          | GlacierKit Support     |
|--------------|----------------------|-------------------------|
| **BIP39**     | Mnemonic Seed         | ✅ Fully Supported      |
| **BIP32**     | HD Wallets            | 🔧 In Development       |
| **BIP44**     | Multi-Account Support | 🚧 Planned              |
| **BIP84**     | SegWit Addresses      | 🚧 Planned              |


---

## 🤝 Contributing

We welcome contributions! Follow these steps to get started:

**Fork the repository:**  
git clone https://github.com/barankaraoguzzz/GlacierKit.git

**Create a feature branch:**  
git checkout -b feature/new-feature

**Run tests:**  
swift test

**Submit a Pull Request!**

## 📜 License

GlacierKit is distributed under the MIT license.  
For more details, please refer to the [LICENSE](LICENSE) file.

## ❓ Questions or Collaboration?

Feel free to reach out!

📧 Email: b.b.karaoguz@gmail.com  
💼 LinkedIn: [Baran Karaoğuz](https://www.linkedin.com/in/baran-karaoguz-07045698/)  
