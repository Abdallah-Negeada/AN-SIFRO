#!/usr/bin/env python3
"""
SIFRO – Professional Password Security Toolkit
Team: AHMED EMAD | MOHAMED NAGY | ABDALLAH NEGEADA | ABDALLAH SALMAN
"""

import secrets
import string
import hashlib
import math
import os
import json
import re
import sys
from datetime import datetime
from itertools import product as itertools_product
from typing import List, Tuple, Optional

# ============================================================
#  COLOUR CONSTANTS (refreshed palette)
# ============================================================
class C:
    RED     = "\033[91m"
    GREEN   = "\033[92m"
    YELLOW  = "\033[93m"
    BLUE    = "\033[94m"
    MAGENTA = "\033[95m"
    CYAN    = "\033[96m"
    WHITE   = "\033[97m"
    BOLD    = "\033[1m"
    DIM     = "\033[2m"
    RESET   = "\033[0m"

def clr(text: str, *codes: str) -> str:
    return "".join(codes) + str(text) + C.RESET

# ============================================================
#  APPLICATION IDENTITY
# ============================================================
APP_NAME    = "SIFRO"
TEAM = [
    "AHMED EMAD",
    "MOHAMED NAGY",
    "ABDALLAH NEGEADA",
    "ABDALLAH SALMAN",
]

def show_splash():
    """Display clean splash without outer frames."""
    os.system("cls" if os.name == "nt" else "clear")
    # SIFRO ASCII logo
    print(clr("""
   ███████╗ ██╗ ███████╗ ██████╗  ███████╗
   ██╔════╝ ██║ ██╔════╝ ██╔══██╗ ██╔══██╗
   ███████╗ ██║ █████╗   ██████╔╝ ██║  ██║
   ╚════██║ ██║ ██╔══╝   ██╔══██╗ ██║  ██║
   ███████║ ██║ ██║      ██║  ██║ ██████╔╝
   ╚══════╝ ╚═╝ ╚═╝      ╚═╝  ╚═╝ ╚═════╝
""", C.BLUE, C.BOLD))
    print(clr("  Developed by:", C.YELLOW, C.BOLD))
    for member in TEAM:
        print(clr(f"    • {member}", C.GREEN))
    print()

# ============================================================
#  HISTORY MANAGEMENT
# ============================================================
HISTORY_FILE = "sifro_history.json"

def load_history() -> List[dict]:
    if os.path.exists(HISTORY_FILE):
        try:
            with open(HISTORY_FILE, "r") as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            return []
    return []

def save_to_history(entry: dict) -> None:
    history = load_history()
    history.append(entry)
    with open(HISTORY_FILE, "w") as f:
        json.dump(history, f, indent=2)

# ============================================================
#  ENHANCED COMMON PASSWORD LIST (top 100)
# ============================================================
COMMON_PASSWORDS = {
    "123456", "password", "123456789", "12345678", "12345", "1234567",
    "qwerty", "abc123", "football", "monkey", "letmein", "dragon",
    "111111", "baseball", "iloveyou", "master", "sunshine", "ashley",
    "bailey", "passw0rd", "shadow", "123123", "654321", "superman",
    "qazwsx", "michael", "football", "password1", "000000", "trustno1",
    "admin", "login", "welcome", "solo", "princess", "qwertyuiop",
    "starwars", "dragon", "pass", "hello", "freedom", "whatever",
    "qazxsw", "ninja", "mustang", "password123", "1234567890",
    "zaq12wsx", "love", "sex", "secret", "666666", "777777", "888888",
    "999999", "123321", "qwerty123", "batman", "superman", "123qwe",
    "1q2w3e4r", "qwerty1", "letmein", "abc123", "trustno", "fuckyou",
    "iloveyou1", "1234", "123", "qwertyuiop", "asdfgh", "1111", "0000",
    "987654321", "123123123", "qwe123", "password2", "1qaz2wsx",
}

# ============================================================
#  ENTROPY & STRENGTH CALCULATION
# ============================================================
def calc_entropy(password: str) -> float:
    charset = 0
    if re.search(r"[a-z]", password): charset += 26
    if re.search(r"[A-Z]", password): charset += 26
    if re.search(r"\d", password):    charset += 10
    if re.search(r"[!@#$%^&*()\-_=+\[\]{};:',.<>?/\\|`~]", password): charset += 32
    if charset == 0:
        return 0.0
    return len(password) * math.log2(charset)

def entropy_label(e: float) -> Tuple[str, str]:
    if e < 28:  return clr("Very Weak", C.RED, C.BOLD), "🔴"
    if e < 36:  return clr("Weak",      C.RED),       "🟠"
    if e < 60:  return clr("Fair",      C.YELLOW),    "🟡"
    if e < 80:  return clr("Strong",    C.GREEN),     "🟢"
    return               clr("Very Strong", C.GREEN, C.BOLD), "💪"

def strength_progress_bar(e: float) -> str:
    """Return a visual strength bar."""
    max_entropy = 128  # realistic upper bound for display
    ratio = min(e / max_entropy, 1.0)
    filled = int(ratio * 20)
    empty = 20 - filled
    if ratio < 0.3:
        color = C.RED
    elif ratio < 0.6:
        color = C.YELLOW
    else:
        color = C.GREEN
    bar = "█" * filled + "░" * empty
    return clr(f"[{bar}]", color, C.BOLD)

def crack_time_estimate(entropy: float, gpu_speed: float = 1e10) -> str:
    """Estimate time to crack with given GPU guesses/sec (default 10 billion)."""
    keyspace = 2 ** entropy
    seconds = keyspace / gpu_speed
    intervals = [
        (3.15e9, "century", "centuries"),
        (31536000, "year", "years"),
        (86400, "day", "days"),
        (3600, "hour", "hours"),
        (60, "minute", "minutes"),
    ]
    for sec_in_unit, singular, plural in intervals:
        if seconds >= sec_in_unit:
            val = seconds / sec_in_unit
            unit = singular if val < 2 else plural
            return f"{val:.1f} {unit}"
    return f"{seconds:.1f} seconds"

# ============================================================
#  1) GENERATE SECURE PASSWORD
# ============================================================
def generate_password() -> None:
    print(clr("\n── Generate Secure Password ──────────────────", C.CYAN))
    try:
        length = int(input(clr("  Password length: ", C.BOLD)))
        if length < 4:
            print(clr("  ⚠  Length must be at least 4.", C.YELLOW)); return
    except ValueError:
        print(clr("  ✖  Invalid length.", C.RED)); return

    print(clr("\n  Character sets (Y/n):", C.BOLD))
    use_lower  = input("    Lowercase letters? [Y/n]: ").strip().lower() != "n"
    use_upper  = input("    Uppercase letters? [Y/n]: ").strip().lower() != "n"
    use_digits = input("    Digits?            [Y/n]: ").strip().lower() != "n"
    use_syms   = input("    Symbols?           [Y/n]: ").strip().lower() != "n"
    excl_ambig = input("    Exclude ambiguous (0Ol1I)? [y/N]: ").strip().lower() == "y"

    pool = ""
    if use_lower:  pool += string.ascii_lowercase
    if use_upper:  pool += string.ascii_uppercase
    if use_digits: pool += string.digits
    if use_syms:   pool += "!@#$%^&*()-_=+[]{};"
    if excl_ambig: pool = "".join(c for c in pool if c not in "0O1lI")

    if not pool:
        print(clr("  ✖  No character set selected!", C.RED)); return

    # Guarantee at least one character from each chosen set
    forced = []
    if use_lower:  forced.append(secrets.choice([c for c in string.ascii_lowercase if c not in ("0O1lI" if excl_ambig else "")]))
    if use_upper:  forced.append(secrets.choice([c for c in string.ascii_uppercase if c not in ("0O1lI" if excl_ambig else "")]))
    if use_digits: forced.append(secrets.choice([c for c in string.digits         if c not in ("0O1lI" if excl_ambig else "")]))
    if use_syms:   forced.append(secrets.choice("!@#$%^&*()-_=+[];"))

    remaining = length - len(forced)
    if remaining < 0:
        print(clr("  ⚠  Length too short for the selected sets.", C.YELLOW)); return

    password_list = forced + [secrets.choice(pool) for _ in range(remaining)]
    secrets.SystemRandom().shuffle(password_list)
    password = "".join(password_list)

    entropy = calc_entropy(password)
    label, icon = entropy_label(entropy)

    print(clr(f"\n  🔑 Generated Password → ", C.BOLD) + clr(password, C.GREEN, C.BOLD))
    print(f"  Entropy    : {entropy:.1f} bits  {icon} {label}")
    print(f"  Strength   : {strength_progress_bar(entropy)}")
    print(f"  Crack time : {clr(crack_time_estimate(entropy), C.MAGENTA)}")

    # Hash previews
    md5    = hashlib.md5(password.encode()).hexdigest()
    sha256 = hashlib.sha256(password.encode()).hexdigest()
    print(clr(f"\n  MD5    : ", C.DIM) + md5)
    print(clr(f"  SHA256 : ", C.DIM) + sha256)

    # Clipboard attempt
    try:
        import pyperclip
        pyperclip.copy(password)
        print(clr("  📋 Copied to clipboard!", C.GREEN))
    except ImportError:
        pass  # pyperclip not installed; ignore silently

    save = input(clr("\n  💾 Save to history? [y/N]: ", C.DIM)).strip().lower()
    if save == "y":
        save_to_history({
            "type": "generated",
            "password": password,
            "length": length,
            "entropy": round(entropy, 2),
            "timestamp": datetime.now().isoformat()
        })
        print(clr("  ✔ Saved.", C.GREEN))
    print()

# ============================================================
#  2) CHECK PASSWORD STRENGTH
# ============================================================
def check_password() -> None:
    print(clr("\n── Check Password Strength ────────────", C.CYAN))
    password = input(clr("  Enter password: ", C.BOLD))

    # Common password warning
    if password.lower() in COMMON_PASSWORDS:
        print(clr("\n  ⚠  This is among the most common passwords – change it immediately!\n", C.RED, C.BOLD))
        return

    # Detailed checks
    checks = [
        (len(password) >= 8,  "At least 8 characters"),
        (len(password) >= 12, "At least 12 characters (recommended)"),
        (bool(re.search(r"[a-z]", password)), "Contains lowercase"),
        (bool(re.search(r"[A-Z]", password)), "Contains uppercase"),
        (bool(re.search(r"\d", password)),    "Contains digits"),
        (bool(re.search(r"[!@#$%^&*()\-_=+\[\]{};:',.<>?/\\|`~]", password)), "Contains symbols"),
        (not re.search(r"(.)\1{2,}", password), "No repeated characters (aaa)"),
        (not re.search(r"(012|123|234|345|456|567|678|789|890|abc|bcd|cde|def|qwerty|asdf)", password.lower()),
         "No sequential patterns"),
    ]

    score = 0
    details: List[str] = []
    for passed, desc in checks:
        sym = clr("✔", C.GREEN) if passed else clr("✖", C.RED)
        details.append(f"    {sym}  {desc}")
        if passed:
            score += 1

    entropy = calc_entropy(password)
    label, icon = entropy_label(entropy)

    print(f"\n  {icon} Overall Strength : {label}")
    print(f"     Entropy          : {clr(f'{entropy:.1f} bits', C.BOLD)}")
    print(f"     Strength Bar     : {strength_progress_bar(entropy)}")
    print(f"     Score            : {score}/{len(checks)}")
    print(clr("\n  Checklist:", C.BOLD))
    for line in details:
        print(line)

    # Crack time estimation (GPU)
    gpu_speed = 1e10   # 10 billion guesses/sec
    crack_time = crack_time_estimate(entropy, gpu_speed)
    print(clr(f"\n  ⏱  Estimated GPU crack time (10 G/s): {crack_time}", C.MAGENTA))

    # Additional smart analysis: check against top 10k if file exists
    if os.path.exists("top10k_passwords.txt"):
        with open("top10k_passwords.txt", "r", encoding="utf-8") as f:
            for line in f:
                if line.strip() == password:
                    print(clr("\n  ⚠  Found in extended common password list!", C.RED, C.BOLD))
                    break
    print()

# ============================================================
#  3) PASSPHRASE GENERATOR (Diceware-like)
# ============================================================
WORD_LIST = [
    "apple","bridge","cloud","dance","eagle","flame","grape","hotel",
    "island","jungle","knife","lemon","magic","noble","ocean","piano",
    "queen","river","storm","tiger","ultra","vivid","water","xenon",
    "yacht","zebra","alpha","bravo","cobra","delta","echo","foxtrot",
    "giant","hunter","iron","joker","kite","lunar","marble","ninja",
    "orbit","phantom","quartz","rocket","silver","turbo","union","vapor",
    "wolf","xtreme","yellow","zephyr","brave","crystal","diamond","elite",
    "fierce","golden","hydro","infinity","jade","knight","legend","master",
    "nexus","onyx","prime","quantum","raven","shield","thunder","ultra",
]

def generate_passphrase() -> None:
    print(clr("\n── Passphrase Generator ───────────────", C.CYAN))
    try:
        n = int(input(clr("  Number of words [4-8]: ", C.BOLD)))
        n = max(4, min(8, n))
    except ValueError:
        n = 4

    separator = input(clr("  Separator (default '-'): ", C.BOLD)).strip() or "-"
    capitalize = input(clr("  Capitalize words? [Y/n]: ", C.BOLD)).strip().lower() != "n"
    add_number = input(clr("  Append a random number? [Y/n]: ", C.BOLD)).strip().lower() != "n"

    words = [secrets.choice(WORD_LIST) for _ in range(n)]
    if capitalize:
        words = [w.capitalize() for w in words]

    passphrase = separator.join(words)
    if add_number:
        passphrase += separator + str(secrets.randbelow(9000) + 1000)

    entropy = calc_entropy(passphrase)
    label, icon = entropy_label(entropy)

    print(clr(f"\n  📖 Passphrase → ", C.BOLD) + clr(passphrase, C.GREEN, C.BOLD))
    print(f"  Entropy    : {entropy:.1f} bits  {icon} {label}")
    print(f"  Strength   : {strength_progress_bar(entropy)}")
    print(f"  Length     : {len(passphrase)} characters")

    try:
        import pyperclip
        pyperclip.copy(passphrase)
        print(clr("  📋 Copied to clipboard!", C.GREEN))
    except ImportError:
        pass
    print()

# ============================================================
#  4) WORDLIST GENERATOR
# ============================================================
def wordlist() -> None:
    print(clr("\n── Wordlist Generator ─────────────────", C.CYAN))
    chars = input(clr("  Characters (e.g. abc123): ", C.BOLD)).strip()
    try:
        min_len = int(input(clr("  Min length: ", C.BOLD)))
        max_len = int(input(clr("  Max length: ", C.BOLD)))
    except ValueError:
        print(clr("  ✖  Invalid length.", C.RED)); return
    if not chars:
        print(clr("  ✖  No characters provided.", C.RED)); return

    if max_len > 6:
        est = sum(len(chars) ** l for l in range(min_len, max_len + 1))
        print(clr(f"  ⚠  Estimated combinations: {est:,}. This may be huge!", C.YELLOW))
        confirm = input("     Continue? [y/N]: ").strip().lower()
        if confirm != "y":
            return

    filename = input(clr("  Output filename: ", C.BOLD)).strip() or "wordlist.txt"
    count = 0
    with open(filename, "w") as f:
        for length in range(min_len, max_len + 1):
            for combo in itertools_product(chars, repeat=length):
                f.write("".join(combo) + "\n")
                count += 1
                if count % 100_000 == 0:
                    print(clr(f"\r  ⏳ {count:,} words written...", C.DIM), end="", flush=True)

    size_kb = os.path.getsize(filename) / 1024
    print(clr(f"\r  ✔ Done! {count:,} words → ", C.GREEN) +
          clr(filename, C.BOLD) +
          clr(f" ({size_kb:.1f} KB)\n", C.DIM))

# ============================================================
#  5) HASH A PASSWORD (multiple algorithms)
# ============================================================
def hash_password() -> None:
    print(clr("\n── Hash Password ──────────────────────", C.CYAN))
    password = input(clr("  Enter password: ", C.BOLD))

    algorithms = {
        "MD5":     hashlib.md5,
        "SHA1":    hashlib.sha1,
        "SHA256":  hashlib.sha256,
        "SHA512":  hashlib.sha512,
    }
    print(clr("\n  Hash outputs:", C.BOLD))
    for name, func in algorithms.items():
        digest = func(password.encode()).hexdigest()
        print(f"    {clr(name.ljust(8), C.CYAN)} → {digest}")

    print(clr("\n  ℹ  For real-world storage use bcrypt or argon2.\n", C.DIM))

# ============================================================
#  6) VIEW & MANAGE HISTORY
# ============================================================
def view_history() -> None:
    print(clr("\n── Password History ───────────────────", C.CYAN))
    history = load_history()
    if not history:
        print(clr("  No history found.\n", C.DIM)); return

    for i, entry in enumerate(history, 1):
        ts   = entry.get("timestamp", "?")
        typ  = entry.get("type", "?")
        pw   = entry.get("password", "?")
        entr = entry.get("entropy", "?")
        print(f"  {clr(str(i).rjust(3), C.DIM, C.BOLD)}. [{clr(ts[:19], C.DIM)}] "
              f"{clr(typ.ljust(12), C.CYAN)}  "
              f"{clr(pw, C.GREEN)}  "
              f"({entr} bits)")

    print()
    print(clr("  Options:", C.BOLD))
    print("    [C] Clear history")
    print("    [E] Export to file")
    print("    [Q] Back to menu")
    choice = input(clr("  » ", C.BOLD)).strip().lower()

    if choice == "c":
        if os.path.exists(HISTORY_FILE):
            os.remove(HISTORY_FILE)
            print(clr("  ✔ History cleared.\n", C.GREEN))
        else:
            print(clr("  Nothing to clear.\n", C.DIM))
    elif choice == "e":
        export_file = input(clr("  Export filename: ", C.BOLD)).strip() or "sifro_export.json"
        with open(export_file, "w") as f:
            json.dump(history, f, indent=2)
        print(clr(f"  ✔ Exported to {export_file}\n", C.GREEN))
    else:
        print()

# ============================================================
#  INTERACTIVE MENU (frame‑less)
# ============================================================
MENU_ITEMS = [
    ("1", "Generate Secure Password",   "🔑"),
    ("2", "Check Password Strength",    "🔍"),
    ("3", "Generate Passphrase",        "📖"),
    ("4", "Generate Wordlist",          "📋"),
    ("5", "Hash a Password",            "🔒"),
    ("6", "View History",               "📂"),
    ("0", "Exit",                       "👋"),
]

def run_menu() -> None:
    while True:
        print(clr("  ──  MAIN MENU  ──", C.CYAN, C.BOLD))
        for key, label, icon in MENU_ITEMS:
            print(f"    [{key}] {icon}  {label}")
        print()
        choice = input(clr("  » Choose an option: ", C.BOLD)).strip()

        actions = {
            "1": generate_password,
            "2": check_password,
            "3": generate_passphrase,
            "4": wordlist,
            "5": hash_password,
            "6": view_history,
        }

        if choice in actions:
            actions[choice]()
        elif choice == "0":
            print(clr("\n  Stay secure! Goodbye 👋\n", C.MAGENTA, C.BOLD))
            sys.exit(0)
        else:
            print(clr("\n  ✖  Invalid option. Try again.\n", C.RED))

# ============================================================
#  APPLICATION ENTRY POINT
# ============================================================
def main() -> None:
    show_splash()
    run_menu()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(clr("\n\n  ⏹  Interrupted. Exiting...\n", C.YELLOW))
        sys.exit(1)
