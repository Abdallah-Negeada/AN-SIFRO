# 🔐 SIFRO – Professional Password Security Toolkit

<div align="center">

![SIFRO Logo](https://github.com/user-attachments/assets/f57722ca-7ab2-4d74-bf67-6895173666b0)

![Python Version](https://img.shields.io/badge/Python-3.6%2B-blue?logo=python&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)

**A Professional Command-Line Password Security Toolkit**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Examples](#-examples) • [Contributing](#-contributing)

</div>

---

## 📖 Overview

**SIFRO** is a powerful and secure command-line tool designed for security professionals and developers. It provides an easy-to-use menu-driven interface for managing passwords, checking their strength, and generating secure credentials with confidence.

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🔑 **Password Generator** | Generate strong passwords with customizable length and character sets |
| 💪 **Password Strength Checker** | Analyze entropy, detect common patterns, and estimate crack time |
| 📝 **Passphrase Generator** | Create secure passphrases using Diceware-style word sequences |
| 📊 **Wordlist Generator** | Build custom wordlists with any character set and length range |
| 🔗 **Hash Tool** | Compute MD5, SHA1, SHA256, and SHA512 hashes instantly |
| 📜 **History Management** | Automatically save and manage generated passwords |
| 🎨 **Visual Feedback** | Entropy bars, color-coded strength indicators, and clipboard support |

---

## 📋 Requirements

- **Python 3.6+** – SIFRO is compatible with any system running Python 3.6 or higher
- **pyperclip** (optional) – For clipboard functionality

```bash
pip install pyperclip
```

---

## 🚀 Quick Installation

### Method 1: Global Installation (Recommended)

```bash
git clone https://github.com/AhmedEmad-AEM/SIFRO.git
cd SIFRO
bash install.sh
```

After installation, run SIFRO from anywhere:
```bash
sifro
```

### Method 2: Direct Execution

```bash
git clone https://github.com/AhmedEmad-AEM/SIFRO.git
cd SIFRO
python3 main.py
```

---

## 💻 Usage

### Main Menu Interface

When you launch SIFRO, you'll see an interactive menu:

```
╔═════════════════════════════════════╗
║      SIFRO - Security Toolkit       ║
╚═════════════════════════════════════╝

1. 🔑 Password Generator
2. 💪 Password Strength Checker
3. 📝 Passphrase Generator
4. 📊 Wordlist Generator
5. 🔗 Hash Tool
6. 📜 View History
7. ❌ Exit
```

### Main Options

#### 🔑 Password Generator
- Choose password length (8-128 characters)
- Select character sets (uppercase, lowercase, digits, symbols)
- Option to exclude ambiguous characters

#### 💪 Strength Checker
- Comprehensive password analysis
- Entropy score calculation
- GPU crack time estimation

#### 🔗 Hash Tool
- Support for MD5, SHA1, SHA256, SHA512
- Instant results with easy copy functionality

---

## 📚 Usage Examples

### Example 1: Generate a Strong Password

```bash
$ sifro
# Select option 1 (Password Generator)
# Enter length: 16
# Choose your preferred options
→ Generated: Xp#9$mK@2Lq!vR4B
```

### Example 2: Check Password Strength

```bash
$ sifro
# Select option 2 (Password Strength Checker)
# Enter your password
→ Strength: 🟢 Very Strong (92 bits)
→ Crack Time: +100 years
```

### Example 3: Generate a Passphrase

```bash
$ sifro
# Select option 3 (Passphrase Generator)
# Number of words: 4
→ Generated: correct-horse-battery-staple-2024
```

---

## 🏗️ Project Structure

```
SIFRO/
├── main.py              # Main entry point
├── modules/
│   ├── generator.py     # Password generation logic
│   ├── checker.py       # Password strength analysis
│   ├── hasher.py        # Hashing functionality
│   └── history.py       # History management
├── install.sh           # Installation script
└── README.md            # This file
```

---

## 🔒 Security Features

- **No Network Connection** – All operations are local and private
- **No Data Storage** – Passwords are never stored permanently
- **Open Source** – Full transparency of the code
- **Best Practices** – Uses cryptographically secure random generation

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create** a new branch: `git checkout -b feature/your-feature`
3. **Make** your changes and test thoroughly
4. **Submit** a Pull Request with a clear description

---

## 📄 License

This project is licensed under the MIT License. See `LICENSE` for details.

---

## 💬 Support & Questions

Have questions or suggestions?

- 📧 Open an [Issue](https://github.com/AhmedEmad-AEM/SIFRO/issues)
- 💬 Start a [Discussion](https://github.com/AhmedEmad-AEM/SIFRO/discussions)

---

## 🌟 Show Your Support

If you find SIFRO helpful, please give it a ⭐ to help us reach more people!

---

![GitHub followers](https://img.shields.io/github/followers/AhmedEmad-AEM?style=social)

</div>
