# Assembly Wordle with Solver Assist

**Computer Organization & Assembly Language Lab (COAL) — Semester 3 Project**  
**National University of Computer & Emerging Sciences (FAST-NUCES), Karachi Campus**  
**Section:** BAI – 3C  

### Group Members
- **Adeel Sabar** (25K-0101)
- **Syed Yahya Raza** (25K-0019)
- **Muhammad Asmaar** (25K-0057)

---

## 1. Project Overview

**Assembly Wordle with Solver Assist** is an authentic Wordle game implemented from the ground up in **32-bit x86 Assembly Language (MASM)** utilizing the **Irvine32 library**.

In standard Wordle, the player has six attempts to deduce a secret five-letter word. After every guess, each letter is assigned a color code:
- 🟩 **Green**: Correct letter in the correct position.
- 🟨 **Yellow**: Correct letter in the wrong position.
- ⬜ **Gray**: Letter not present in the secret word.

### Innovative Highlights
1. **Accurate Two-Pass Scoring Engine (`ScoreGuessCore`)**: Faithfully implements the official Wordle duplicate-letter resolution algorithm. Pass 1 matches exact letters (Green) and locks their secret positions; Pass 2 matches remaining letters (Yellow) only against unclaimed secret occurrences.
2. **Solver Assist Mode**: An embedded constraint-satisfaction engine that dynamically filters the 150-word internal dictionary after each guess, reporting the exact number of consistent words remaining and previewing candidates.
3. **Challenge Code System (Custom PRNG)**: A 32-bit shift-and-XOR pseudo-random number generator written by the team. Entering the same Challenge Code on any machine deterministically reproduces the exact same hidden word, allowing head-to-head competition between players.
4. **Dynamic Visual Board & Keyboard**: Row-major two-dimensional arrays for tiles and colors, plus a 26-letter keyboard tracker maintaining the strongest feedback state (`Green > Yellow > Gray > Unused`).
5. **Persistent Session Statistics**: Tracks games played, win percentage, current/max win streaks, and a graphical bar chart for guess distribution.

---

## 2. Directory Structure

```text
├── main.asm                ; Complete Wordle game implementation in MASM
├── build.bat               ; One-click batch build script for command-line assembly
├── Wordle.sln              ; Visual Studio Solution file
├── Wordle.vcxproj          ; Visual Studio Project file with MASM build tools configured
├── Wordle.vcxproj.filters  ; Visual Studio Project filters
├── README.md               ; Project overview, setup, and usage guide
└── REPORT.md               ; Comprehensive formal project report with CISC/RISC analysis
```

---

## 3. Building and Running

### Option A: Command Line (One-Click)
Run `build.bat` in the project root:
```cmd
build.bat
```
This automatically invokes the Visual Studio Developer environment, compiles `main.asm` via `ml.exe`, links against `Irvine32.lib`, and produces `Wordle.exe`.

To launch the game:
```cmd
Wordle.exe
```

### Option B: Visual Studio
1. Open [Wordle.sln](file:///c:/Users/ADEEL/Desktop/University%20Study%20-%20Sem%2003/COAL%20-%20Lab/Project/Wordle.sln) in Visual Studio 2022 / 2026.
2. Ensure the configuration is set to **Debug** or **Release** and platform is **x86** (Win32).
3. Press **F5** (or **Ctrl+F5**) to build and run.

---

## 4. Course Syllabus Coverage

| COAL Course Topic | Implementation in Project |
| :--- | :--- |
| **Data Definitions & Addressing Modes** | Fixed-width string dictionary (`wordList`), base-index addressing `[esi + ecx]`, row-major displacement `[ebx * 5 + ecx]` |
| **Loops & Conditional Jumps** | Two-pass scoring loops, dictionary validation loop, `loop`, `cmp`, `je`, `jne`, `jl`, `jbe` |
| **Stack Operations & Procedures** | Modular `PROC` / `ENDP` definitions, register preservation with `push`/`pop`, call-ret conventions |
| **Boolean & Bitwise Logic** | Case conversion via `and al, 0DFh`, candidate toggling via `xor`, bit manipulation |
| **Shift & Rotate Operations** | 32-bit Linear Shift/XOR PRNG utilizing `shl` and `shr` with feedback taps |
| **String Primitives** | Direction flag control (`cld`), block clearing with `rep stosb`, string comparison via `repe cmpsb`, block move via `rep movsb` |
| **2D Arrays** | 6x5 board character array `boardChars` and matching 6x5 color attribute array `boardColors` |
| **CISC vs. RISC Analysis** | In-depth comparison of x86 complex instructions vs ARM/RISC-V load-store equivalents in `REPORT.md` |
