INCLUDE Irvine32.inc

COLOR_DEFAULT   EQU 07h    ; White on Black
COLOR_TITLE     EQU 0Bh    ; Light Cyan on Black
COLOR_HEADER    EQU 0Eh    ; Yellow on Black
COLOR_GRAY      EQU 8Fh    ; Bright White on Gray Background
COLOR_YELLOW    EQU 6Fh    ; Bright White on Brown/Yellow Background
COLOR_GREEN     EQU 2Fh    ; Bright White on Green Background
COLOR_EMPTY     EQU 08h    ; Dark Gray on Black
COLOR_PROMPT    EQU 0Fh    ; Bright White on Black
COLOR_ERROR     EQU 0Ch    ; Light Red on Black
COLOR_SUCCESS   EQU 0Ah    ; Light Green on Black
COLOR_STAT      EQU 0Dh    ; Light Magenta on Black
COLOR_BORDER    EQU 03h    ; Cyan on Black

SCORE_EMPTY     EQU 0
SCORE_GRAY      EQU 1
SCORE_YELLOW    EQU 2
SCORE_GREEN     EQU 3

WORD_LEN        EQU 5
MAX_GUESSES     EQU 6
WORD_COUNT      EQU 150

.data
wordList BYTE "ABOUT", 0, "ALERT", 0, "APPLE", 0, "BEACH", 0, "BRAIN", 0
         BYTE "BREAD", 0, "BRICK", 0, "CHAIR", 0, "CHEST", 0, "CLOCK", 0
         BYTE "CLOUD", 0, "CRANE", 0, "DANCE", 0, "DREAM", 0, "EARTH", 0
         BYTE "FLAME", 0, "FRUIT", 0, "GHOST", 0, "GRAPE", 0, "GREEN", 0
         BYTE "HEART", 0, "HOUSE", 0, "JUICE", 0, "KNIFE", 0, "LEMON", 0
         BYTE "LIGHT", 0, "LUNCH", 0, "MAGIC", 0, "MONEY", 0, "MUSIC", 0
         BYTE "NIGHT", 0, "OCEAN", 0, "PAINT", 0, "PARTY", 0, "PEACH", 0
         BYTE "PIANO", 0, "PILOT", 0, "PLANT", 0, "PLATE", 0, "POWER", 0
         BYTE "QUEEN", 0, "RADIO", 0, "RIVER", 0, "ROBOT", 0, "ROUND", 0
         BYTE "SCALE", 0, "SMILE", 0, "SNAKE", 0, "SPACE", 0, "STAGE", 0
         BYTE "STORM", 0, "SUGAR", 0, "SWEET", 0, "TABLE", 0, "TIGER", 0
         BYTE "TRAIN", 0, "TRUCK", 0, "VOICE", 0, "WATER", 0, "WHITE", 0
         BYTE "WORLD", 0, "YOUTH", 0, "ZEBRA", 0, "ACTOR", 0, "ADULT", 0
         BYTE "ANGER", 0, "BADGE", 0, "BLIND", 0, "BLOOD", 0, "BOARD", 0
         BYTE "BROWN", 0, "CABLE", 0, "CANDY", 0, "CHAIN", 0, "CHAMP", 0
         BYTE "CHARM", 0, "CHASE", 0, "CLEAN", 0, "CLEAR", 0, "CLIMB", 0
         BYTE "COAST", 0, "CROWD", 0, "CROWN", 0, "DAILY", 0, "DRIVE", 0
         BYTE "EAGLE", 0, "ENTRY", 0, "FAITH", 0, "FIGHT", 0, "FINAL", 0
         BYTE "FLOOR", 0, "FOCUS", 0, "FORCE", 0, "GIANT", 0, "GLASS", 0
         BYTE "GLOBE", 0, "GRACE", 0, "GRAIN", 0, "GRASS", 0, "GUIDE", 0
         BYTE "HAPPY", 0, "HEAVY", 0, "HONEY", 0, "HORSE", 0, "HOTEL", 0
         BYTE "IMAGE", 0, "INDEX", 0, "JUDGE", 0, "LEVEL", 0, "LOCAL", 0
         BYTE "LUCKY", 0, "MARCH", 0, "MATCH", 0, "METAL", 0, "MODEL", 0
         BYTE "MOTOR", 0, "MOUNT", 0, "MOUSE", 0, "NOBLE", 0, "NORTH", 0
         BYTE "NOVEL", 0, "NURSE", 0, "ORDER", 0, "PEACE", 0, "PHONE", 0
         BYTE "PRICE", 0, "PRIDE", 0, "PRIME", 0, "PRIZE", 0, "PUPIL", 0
         BYTE "QUIET", 0, "RADAR", 0, "RIDER", 0, "RIVAL", 0, "SCOPE", 0
         BYTE "SHARP", 0, "SHEEP", 0, "SHELL", 0, "SHIFT", 0, "SHINE", 0
         BYTE "SHIRT", 0, "SHOCK", 0, "SIGHT", 0, "SKILL", 0, "SMART", 0
         BYTE "SOLAR", 0, "SOLID", 0, "SOUND", 0, "SOUTH", 0, "SPARK", 0
         BYTE "SPEED", 0, "SPICE", 0, "SPOON", 0, "SPORT", 0, "STAND", 0

secretWord      BYTE WORD_LEN + 1 DUP(0)
guessBuffer     BYTE 64 DUP(0)
cleanGuess      BYTE WORD_LEN + 1 DUP(0)

boardChars      BYTE (MAX_GUESSES * WORD_LEN) DUP(' ')
boardColors     BYTE (MAX_GUESSES * WORD_LEN) DUP(SCORE_EMPTY)

currentScore    BYTE WORD_LEN DUP(0)
simScore        BYTE WORD_LEN DUP(0)
secretUsed      BYTE WORD_LEN DUP(0)
guessMatched    BYTE WORD_LEN DUP(0)

keyboardState   BYTE 26 DUP(0)

candidateMask   BYTE WORD_COUNT DUP(1)
candidateCount  DWORD WORD_COUNT
solverAssistOn  DWORD 1           

lfsrState       DWORD 12345678h
currentSeed     DWORD 0
isChallengeGame DWORD 0

statsGamesPlayed    DWORD 0
statsGamesWon       DWORD 0
statsCurrentStreak  DWORD 0
statsMaxStreak      DWORD 0
statsDist           DWORD MAX_GUESSES DUP(0) ; Index 0..5 = 1..6 guesses

currentAttempt  DWORD 0
gameWon         DWORD 0
errorMessage    BYTE 80 DUP(0)

strBanner1      BYTE "================================================================", 0
strBanner2      BYTE "                 ASSEMBLY WORDLE WITH SOLVER ASSIST             ", 0
strBanner3      BYTE "       COAL Lab Project | FAST-NUCES Karachi | Section BAI-3C   ", 0
strBanner4      BYTE "================================================================", 0

strMenuTitle    BYTE "                     --- MAIN MENU ---                         ", 0
strMenu1        BYTE "  [1] Play Standard Game (Random Word)", 0
strMenu2        BYTE "  [2] Play Challenge Code Game (Custom Seed)", 0
strMenu3        BYTE "  [3] Toggle Solver Assist Mode (Currently: ", 0
strMenu4        BYTE "  [4] View Game Statistics", 0
strMenu5        BYTE "  [5] How To Play & Rules", 0
strMenu6        BYTE "  [6] Exit", 0
strMenuPrompt   BYTE "  Enter your choice (1-6): ", 0

strStatusOn     BYTE "ON)", 0
strStatusOff    BYTE "OFF)", 0

strChallengePrompt BYTE "  Enter a numeric Challenge Code (1 - 999999): ", 0
strChallengeCodeIs BYTE "  Game Challenge Code: #", 0

strRulesTitle   BYTE "                       --- HOW TO PLAY ---                      ", 0
strRule1        BYTE "  * Guess the secret 5-letter English word in 6 attempts.", 0
strRule2        BYTE "  * Each guess must be a valid 5-letter word from the list.", 0
strRule3        BYTE "  * Tile Feedback:", 0
strRuleGreen    BYTE "      [GREEN]  : Correct letter in the correct position.", 0
strRuleYellow   BYTE "      [YELLOW] : Correct letter, but wrong position.", 0
strRuleGray     BYTE "      [GRAY]   : Letter is NOT in the secret word.", 0
strRule4        BYTE "  * Solver Assist:", 0
strRule5        BYTE "      Shows real-time candidate word count left after each guess.", 0
strRule6        BYTE "  * Challenge Code:", 0
strRule7        BYTE "      Share your seed code with friends to play the exact same word!", 0

strStatsTitle   BYTE "                    --- GAME STATISTICS ---                    ", 0
strStatPlayed   BYTE "  Total Games Played   : ", 0
strStatWon      BYTE "  Total Games Won      : ", 0
strStatWinPct   BYTE "  Win Percentage       : ", 0
strStatStreak   BYTE "  Current Win Streak   : ", 0
strStatMaxStk   BYTE "  Maximum Win Streak   : ", 0
strStatDistTitle BYTE "  Guess Distribution (Tries 1 to 6):", 0

strGuessPrompt  BYTE "  Enter guess #", 0
strPromptColon  BYTE " (5 letters): ", 0

strWinMessage   BYTE "  *** BRILLIANT! YOU GUESSED THE WORD! ***", 0
strLoseMessage  BYTE "  *** GAME OVER! Better luck next time! ***", 0
strSecretWas    BYTE "  The secret word was: ", 0
strSolverHeader BYTE "  [Solver Assist] Remaining Candidates: ", 0
strSolverSample BYTE "  [Candidate Preview] ", 0
strCandidateDots BYTE " ...", 0

strErrLength    BYTE "Error: Word must be exactly 5 letters!", 0
strErrAlpha     BYTE "Error: Guess must only contain letters A-Z!", 0
strErrNotFound  BYTE "Error: Word not in dictionary!", 0

strPlayAgainPrompt BYTE "  Play another game? (Y/N): ", 0

.code
main PROC
    ; Initialize system randomizer
    call Randomize

MainMenuLoop:
    call DisplayMainMenu
    call ReadChar
    call WriteChar
    call Crlf

    cmp al, '1'
    je StartNormalGame
    cmp al, '2'
    je StartChallengeGame
    cmp al, '3'
    je ToggleSolver
    cmp al, '4'
    je ShowStats
    cmp al, '5'
    je ShowRules
    cmp al, '6'
    je ExitApplication
    jmp MainMenuLoop

StartNormalGame:
    mov isChallengeGame, 0
    call RunGameSession
    jmp MainMenuLoop

StartChallengeGame:
    mov isChallengeGame, 1
    call RunGameSession
    jmp MainMenuLoop

ToggleSolver:
    ; Bitwise XOR to toggle between 1 and 0
    xor solverAssistOn, 1
    jmp MainMenuLoop

ShowStats:
    call DisplayStatistics
    jmp MainMenuLoop

ShowRules:
    call DisplayRules
    jmp MainMenuLoop

ExitApplication:
    mov eax, COLOR_DEFAULT
    call SetTextColor
    call Clrscr
    exit
main ENDP

RunGameSession PROC
    ; 1. Pick Secret Word
    cmp isChallengeGame, 1
    jne SetupNormalWord

    ; Challenge code input
    call Clrscr
    mov eax, COLOR_TITLE
    call SetTextColor
    mov edx, OFFSET strBanner1
    call WriteString
    call Crlf
    mov edx, OFFSET strBanner2
    call WriteString
    call Crlf
    mov edx, OFFSET strBanner1
    call WriteString
    call Crlf
    call Crlf

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strChallengePrompt
    call WriteString
    mov eax, COLOR_PROMPT
    call SetTextColor
    call ReadDec
    test eax, eax
    jnz UseInputSeed
    mov eax, 12345        
UseInputSeed:
    mov currentSeed, eax
    call PickChallengeWord
    jmp GameSetupDone

SetupNormalWord:
    mov eax, 899999
    call RandomRange
    add eax, 100000       
    mov currentSeed, eax
    call PickChallengeWord 

GameSetupDone:
    call ResetGameState

GameLoop:
    call RenderGameScreen

    cmp gameWon, 1
    je HandleGameOver
    mov eax, currentAttempt
    cmp eax, MAX_GUESSES
    jae HandleGameOver

    call ReadAndValidateGuess
    test eax, eax
    jz GameLoop           

    call ScoreCurrentGuess

    call RecordGuessOnBoard

    call UpdateKeyboardTracker

    cmp solverAssistOn, 1
    jne SkipFilter
    call FilterCandidates
SkipFilter:

    inc currentAttempt

    call CheckAllGreen
    test eax, eax
    jz GameLoop
    mov gameWon, 1
    jmp GameLoop

HandleGameOver:
    call RenderGameScreen
    call Crlf

    inc statsGamesPlayed
    cmp gameWon, 1
    jne PlayerLost

    mov eax, COLOR_SUCCESS
    call SetTextColor
    mov edx, OFFSET strWinMessage
    call WriteString
    call Crlf
    inc statsGamesWon
    inc statsCurrentStreak
    mov eax, statsCurrentStreak
    cmp eax, statsMaxStreak
    jbe UpdateDistribution
    mov statsMaxStreak, eax

UpdateDistribution:
    mov ebx, currentAttempt
    dec ebx                ; 0..5 index
    cmp ebx, MAX_GUESSES
    jae FinishStatsUpdate
    inc statsDist[ebx * 4]
    jmp FinishStatsUpdate

PlayerLost:
    mov statsCurrentStreak, 0
    mov eax, COLOR_ERROR
    call SetTextColor
    mov edx, OFFSET strLoseMessage
    call WriteString
    call Crlf

FinishStatsUpdate:
    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strSecretWas
    call WriteString
    mov eax, COLOR_GREEN
    call SetTextColor
    mov edx, OFFSET secretWord
    call WriteString
    call Crlf
    call Crlf

    mov eax, COLOR_PROMPT
    call SetTextColor
    mov edx, OFFSET strPlayAgainPrompt
    call WriteString
    call ReadChar
    call WriteChar
    call Crlf

    and al, 0DFh
    cmp al, 'Y'
    je RunGameSession
    ret
RunGameSession ENDP

ResetGameState PROC
    push eax
    push ecx
    push edi

    mov currentAttempt, 0
    mov gameWon, 0
    mov errorMessage[0], 0

    mov edi, OFFSET boardChars
    mov ecx, MAX_GUESSES * WORD_LEN
    mov al, ' '
    cld
    rep stosb

    mov edi, OFFSET boardColors
    mov ecx, MAX_GUESSES * WORD_LEN
    mov al, SCORE_EMPTY
    cld
    rep stosb

    mov edi, OFFSET keyboardState
    mov ecx, 26
    mov al, 0
    cld
    rep stosb

    mov edi, OFFSET candidateMask
    mov ecx, WORD_COUNT
    mov al, 1
    cld
    rep stosb
    mov candidateCount, WORD_COUNT

    pop edi
    pop ecx
    pop eax
    ret
ResetGameState ENDP

PRNG_Step PROC
    push ebx
    mov eax, lfsrState
    test eax, eax
    jnz PRNG_Valid
    mov eax, 2463534242   
PRNG_Valid:
    mov ebx, eax
    shl ebx, 13
    xor eax, ebx

    mov ebx, eax
    shr ebx, 17
    xor eax, ebx

    mov ebx, eax
    shl ebx, 5
    xor eax, ebx

    mov lfsrState, eax
    pop ebx
    ret
PRNG_Step ENDP

PickChallengeWord PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov eax, currentSeed
    test eax, eax
    jnz SeedOk
    mov eax, 987654321
SeedOk:
    mov lfsrState, eax

    mov ecx, 8
WarmupLoop:
    call PRNG_Step
    loop WarmupLoop

    call PRNG_Step

    xor edx, edx
    mov ebx, WORD_COUNT
    div ebx               

    mov eax, edx
    mov ebx, 6
    mul ebx               
    mov esi, OFFSET wordList
    add esi, eax

    mov edi, OFFSET secretWord
    mov ecx, WORD_LEN
    cld
    rep movsb
    mov BYTE PTR [edi], 0 ; Null terminator

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
PickChallengeWord ENDP

ReadAndValidateGuess PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov eax, COLOR_PROMPT
    call SetTextColor
    mov edx, OFFSET strGuessPrompt
    call WriteString
    mov eax, currentAttempt
    inc eax
    call WriteDec
    mov edx, OFFSET strPromptColon
    call WriteString

    mov edx, OFFSET guessBuffer
    mov ecx, SIZEOF guessBuffer - 1
    call ReadString

    cmp eax, WORD_LEN
    je CheckLetters
    mov esi, OFFSET strErrLength
    call SetErrorMessage
    mov eax, 0
    jmp ValidationDone

CheckLetters:
    mov esi, OFFSET guessBuffer
    mov edi, OFFSET cleanGuess
    mov ecx, WORD_LEN

LetterLoop:
    mov al, [esi]
    cmp al, 'a'
    jb CheckUpper
    cmp al, 'z'
    ja InvalidChar
    and al, 0DFh         

CheckUpper:
    cmp al, 'A'
    jb InvalidChar
    cmp al, 'Z'
    ja InvalidChar

    mov [edi], al
    inc esi
    inc edi
    loop LetterLoop

    mov BYTE PTR [edi], 0 
    jmp CheckInDictionary

InvalidChar:
    mov esi, OFFSET strErrAlpha
    call SetErrorMessage
    mov eax, 0
    jmp ValidationDone

CheckInDictionary:
    mov ecx, WORD_COUNT
    mov esi, OFFSET wordList

DictSearchLoop:
    push ecx
    push esi

    mov edi, OFFSET cleanGuess
    mov ecx, WORD_LEN
    cld
    repe cmpsb
    je WordFoundInDict

    pop esi
    pop ecx
    add esi, 6            
    loop DictSearchLoop

    mov esi, OFFSET strErrNotFound
    call SetErrorMessage
    mov eax, 0
    jmp ValidationDone

WordFoundInDict:
    pop esi
    pop ecx
    mov errorMessage[0], 0
    mov eax, 1

ValidationDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
ReadAndValidateGuess ENDP

SetErrorMessage PROC
    push eax
    push esi
    push edi
    mov edi, OFFSET errorMessage
CopyErr:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    test al, al
    jnz CopyErr
    pop edi
    pop esi
    pop eax
    ret
SetErrorMessage ENDP

ScoreGuessCore PROC
    push eax
    push ecx
    push edx
    push esi
    push edi
    push ebp

    push edi              
    mov edi, OFFSET secretUsed
    mov ecx, WORD_LEN
    mov al, 0
    cld
    rep stosb

    mov edi, OFFSET guessMatched
    mov ecx, WORD_LEN
    mov al, 0
    rep stosb
    pop edi               

    mov ecx, 0            
Pass1Loop:
    mov al, [edi + ecx]   
    mov dl, [esi + ecx]   
    cmp al, dl
    jne Pass1Next

    mov BYTE PTR [ebx + ecx], SCORE_GREEN
    mov secretUsed[ecx], 1
    mov guessMatched[ecx], 1
    jmp Pass1Cont

Pass1Next:
    mov BYTE PTR [ebx + ecx], SCORE_GRAY

Pass1Cont:
    inc ecx
    cmp ecx, WORD_LEN
    jl Pass1Loop

    mov ecx, 0            
Pass2Outer:
    cmp guessMatched[ecx], 1
    je Pass2NextGuess     

    mov al, [edi + ecx]   

    mov edx, 0            
Pass2Inner:
    cmp secretUsed[edx], 1
    je Pass2NextSecret    

    cmp al, [esi + edx]   
    jne Pass2NextSecret

    mov BYTE PTR [ebx + ecx], SCORE_YELLOW
    mov secretUsed[edx], 1 
    jmp Pass2NextGuess    

Pass2NextSecret:
    inc edx
    cmp edx, WORD_LEN
    jl Pass2Inner

Pass2NextGuess:
    inc ecx
    cmp ecx, WORD_LEN
    jl Pass2Outer

    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop eax
    ret
ScoreGuessCore ENDP


ScoreCurrentGuess PROC
    push ebx
    push esi
    push edi

    mov esi, OFFSET secretWord
    mov edi, OFFSET cleanGuess
    mov ebx, OFFSET currentScore
    call ScoreGuessCore

    pop edi
    pop esi
    pop ebx
    ret
ScoreCurrentGuess ENDP

RecordGuessOnBoard PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov eax, currentAttempt
    mov ebx, WORD_LEN
    mul ebx               

    mov edi, OFFSET boardChars
    add edi, eax
    mov esi, OFFSET cleanGuess
    mov ecx, WORD_LEN
    cld
    rep movsb

    mov edi, OFFSET boardColors
    add edi, eax
    mov esi, OFFSET currentScore
    mov ecx, WORD_LEN
    rep movsb

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
RecordGuessOnBoard ENDP

UpdateKeyboardTracker PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov ecx, 0            
KeyLoop:
    ; Get letter: cleanGuess[ecx]
    movzx eax, BYTE PTR cleanGuess[ecx]
    sub eax, 'A'          
    cmp eax, 25
    ja KeyNext

    mov dl, currentScore[ecx]  
    mov bl, keyboardState[eax] 

    cmp dl, bl
    jbe KeyNext
    mov keyboardState[eax], dl

KeyNext:
    inc ecx
    cmp ecx, WORD_LEN
    jl KeyLoop

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
UpdateKeyboardTracker ENDP

CheckAllGreen PROC
    push ecx
    mov ecx, 0
GreenCheckLoop:
    cmp currentScore[ecx], SCORE_GREEN
    jne NotAllGreen
    inc ecx
    cmp ecx, WORD_LEN
    jl GreenCheckLoop

    mov eax, 1
    pop ecx
    ret

NotAllGreen:
    mov eax, 0
    pop ecx
    ret
CheckAllGreen ENDP

FilterCandidates PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov candidateCount, 0
    mov ecx, 0            ; ecx = word index 0 .. WORD_COUNT-1

CandidateLoop:
    ; Check if candidate is already eliminated
    cmp candidateMask[ecx], 1
    jne NextCandidate

    ; Candidate is currently alive: test it!
    push ecx

    ; Compute candidate word address: wordList + (ecx * 6)
    mov eax, ecx
    mov ebx, 6
    mul ebx
    mov esi, OFFSET wordList
    add esi, eax          ; ESI = Candidate word address

    mov edi, OFFSET cleanGuess
    mov ebx, OFFSET simScore
    call ScoreGuessCore   ; What would the score be if Candidate was secret?

    ; Compare simScore with currentScore (5 bytes)
    mov edx, 0
MatchScoreLoop:
    mov al, simScore[edx]
    cmp al, currentScore[edx]
    jne InconsistentCandidate
    inc edx
    cmp edx, WORD_LEN
    jl MatchScoreLoop

    ; Candidate matches feedback! Keep it alive
    pop ecx
    inc candidateCount
    jmp NextCandidate

InconsistentCandidate:
    pop ecx
    ; Eliminate candidate
    mov candidateMask[ecx], 0

NextCandidate:
    inc ecx
    cmp ecx, WORD_COUNT
    jl CandidateLoop

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
FilterCandidates ENDP

RenderGameScreen PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi

    call Clrscr

    ; Title Banner
    mov eax, COLOR_TITLE
    call SetTextColor
    mov edx, OFFSET strBanner1
    call WriteString
    call Crlf
    mov edx, OFFSET strBanner2
    call WriteString
    call Crlf
    mov edx, OFFSET strBanner1
    call WriteString
    call Crlf

    ; Challenge Code Info
    mov eax, COLOR_BORDER
    call SetTextColor
    mov edx, OFFSET strChallengeCodeIs
    call WriteString
    mov eax, currentSeed
    call WriteDec
    call Crlf
    call Crlf

    ; Draw 6x5 Wordle Board
    mov ebx, 0            ; ebx = row (0..5)
RowLoop:
    ; Indentation
    mov eax, COLOR_DEFAULT
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    call WriteChar

    mov ecx, 0            ; ecx = col (0..4)
ColLoop:
    ; Calculate index: row * 5 + col
    mov eax, ebx
    imul eax, WORD_LEN
    add eax, ecx

    ; Get character and score code
    movzx edx, BYTE PTR boardChars[eax]
    movzx esi, BYTE PTR boardColors[eax]

    ; Select color based on score
    cmp esi, SCORE_GREEN
    je UseGreen
    cmp esi, SCORE_YELLOW
    je UseYellow
    cmp esi, SCORE_GRAY
    je UseGray

    ; Default empty slot
    mov eax, COLOR_EMPTY
    call SetTextColor
    mov al, '['
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, dl
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ']'
    call WriteChar
    mov al, ' '
    call WriteChar
    jmp NextCol

UseGreen:
    mov eax, COLOR_GREEN
    jmp DrawTile
UseYellow:
    mov eax, COLOR_YELLOW
    jmp DrawTile
UseGray:
    mov eax, COLOR_GRAY

DrawTile:
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, dl            ; Character
    call WriteChar
    mov al, ' '
    call WriteChar

    ; Spacing between tiles
    mov eax, COLOR_DEFAULT
    call SetTextColor
    mov al, ' '
    call WriteChar

NextCol:
    inc ecx
    cmp ecx, WORD_LEN
    jl ColLoop

    call Crlf
    inc ebx
    cmp ebx, MAX_GUESSES
    jl RowLoop

    call Crlf

    ; Draw A-Z Keyboard Tracker
    call DrawKeyboard

    ; Display Solver Assist status (if enabled)
    cmp solverAssistOn, 1
    jne SkipAssistDisplay
    call DisplaySolverAssistInfo
SkipAssistDisplay:

    ; If there is a pending error message, display it
    cmp errorMessage[0], 0
    je RenderDone
    call Crlf
    mov eax, COLOR_ERROR
    call SetTextColor
    mov edx, OFFSET errorMessage
    call WriteString
    call Crlf

RenderDone:
    call Crlf
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
RenderGameScreen ENDP

DrawKeyboard PROC
    push eax
    push ebx
    push ecx
    push edx

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strBanner1
    ; Simple separator
    call Crlf

    ; First Row: A .. M
    mov eax, COLOR_DEFAULT
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar

    mov ecx, 0            ; 'A' .. 'M' (0 .. 12)
KeyRow1:
    call PrintKeyChar
    inc ecx
    cmp ecx, 13
    jl KeyRow1

    call Crlf

    ; Second Row: N .. Z
    mov eax, COLOR_DEFAULT
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar

    mov ecx, 13           ; 'N' .. 'Z' (13 .. 25)
KeyRow2:
    call PrintKeyChar
    inc ecx
    cmp ecx, 26
    jl KeyRow2

    call Crlf
    mov eax, COLOR_DEFAULT
    call SetTextColor

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawKeyboard ENDP

PrintKeyChar PROC
    push eax
    push edx

    movzx eax, BYTE PTR keyboardState[ecx]
    cmp eax, SCORE_GREEN
    je KeyGreen
    cmp eax, SCORE_YELLOW
    je KeyYellow
    cmp eax, SCORE_GRAY
    je KeyGray

    ; Unused letter
    mov eax, COLOR_PROMPT
    call SetTextColor
    mov al, '['
    call WriteChar
    mov eax, ecx
    add eax, 'A'
    call WriteChar
    mov al, ']'
    call WriteChar
    mov al, ' '
    call WriteChar
    jmp KeyPrintEnd

KeyGreen:
    mov eax, COLOR_GREEN
    jmp KeyDrawColored
KeyYellow:
    mov eax, COLOR_YELLOW
    jmp KeyDrawColored
KeyGray:
    mov eax, COLOR_GRAY

KeyDrawColored:
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov eax, ecx
    add eax, 'A'
    call WriteChar
    mov al, ' '
    call WriteChar

    mov eax, COLOR_DEFAULT
    call SetTextColor
    mov al, ' '
    call WriteChar

KeyPrintEnd:
    pop edx
    pop eax
    ret
PrintKeyChar ENDP

DisplaySolverAssistInfo PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov eax, COLOR_STAT
    call SetTextColor
    mov edx, OFFSET strSolverHeader
    call WriteString

    mov eax, candidateCount
    call WriteDec
    call Crlf

    ; Preview up to 6 candidate words
    mov edx, OFFSET strSolverSample
    call WriteString

    mov ecx, 0            ; ecx = word index (0..WORD_COUNT-1)
    mov ebx, 0            ; ebx = previewed count

PreviewLoop:
    cmp candidateMask[ecx], 1
    jne PreviewNext

    ; Print candidate word
    push ecx
    mov eax, ecx
    mov edx, 6
    mul edx
    mov esi, OFFSET wordList
    add esi, eax

    mov eax, COLOR_PROMPT
    call SetTextColor
    mov edx, esi
    call WriteString
    mov al, ' '
    call WriteChar

    pop ecx
    inc ebx
    cmp ebx, 6
    jge PreviewCutoff

PreviewNext:
    inc ecx
    cmp ecx, WORD_COUNT
    jl PreviewLoop
    jmp PreviewDone

PreviewCutoff:
    cmp candidateCount, 6
    jbe PreviewDone
    mov edx, OFFSET strCandidateDots
    call WriteString

PreviewDone:
    call Crlf
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DisplaySolverAssistInfo ENDP

DisplayMainMenu PROC
    call Clrscr

    mov eax, COLOR_TITLE
    call SetTextColor
    mov edx, OFFSET strBanner1
    call WriteString
    call Crlf
    mov edx, OFFSET strBanner2
    call WriteString
    call Crlf
    mov edx, OFFSET strBanner3
    call WriteString
    call Crlf
    mov edx, OFFSET strBanner4
    call WriteString
    call Crlf
    call Crlf

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strMenuTitle
    call WriteString
    call Crlf
    call Crlf

    mov eax, COLOR_PROMPT
    call SetTextColor
    mov edx, OFFSET strMenu1
    call WriteString
    call Crlf
    mov edx, OFFSET strMenu2
    call WriteString
    call Crlf

    mov edx, OFFSET strMenu3
    call WriteString
    cmp solverAssistOn, 1
    je AssistIsOn
    mov eax, COLOR_ERROR
    call SetTextColor
    mov edx, OFFSET strStatusOff
    call WriteString
    jmp PrintRestMenu
AssistIsOn:
    mov eax, COLOR_SUCCESS
    call SetTextColor
    mov edx, OFFSET strStatusOn
    call WriteString

PrintRestMenu:
    call Crlf
    mov eax, COLOR_PROMPT
    call SetTextColor
    mov edx, OFFSET strMenu4
    call WriteString
    call Crlf
    mov edx, OFFSET strMenu5
    call WriteString
    call Crlf
    mov edx, OFFSET strMenu6
    call WriteString
    call Crlf
    call Crlf

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strMenuPrompt
    call WriteString
    ret
DisplayMainMenu ENDP

DisplayRules PROC
    call Clrscr
    mov eax, COLOR_TITLE
    call SetTextColor
    mov edx, OFFSET strBanner1
    call WriteString
    call Crlf
    mov edx, OFFSET strRulesTitle
    call WriteString
    call Crlf
    mov edx, OFFSET strBanner1
    call WriteString
    call Crlf
    call Crlf

    mov eax, COLOR_PROMPT
    call SetTextColor
    mov edx, OFFSET strRule1
    call WriteString
    call Crlf
    mov edx, OFFSET strRule2
    call WriteString
    call Crlf
    call Crlf

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strRule3
    call WriteString
    call Crlf

    mov eax, COLOR_GREEN
    call SetTextColor
    mov edx, OFFSET strRuleGreen
    call WriteString
    call Crlf

    mov eax, COLOR_YELLOW
    call SetTextColor
    mov edx, OFFSET strRuleYellow
    call WriteString
    call Crlf

    mov eax, COLOR_GRAY
    call SetTextColor
    mov edx, OFFSET strRuleGray
    call WriteString
    call Crlf
    call Crlf

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strRule4
    call WriteString
    call Crlf
    mov eax, COLOR_PROMPT
    call SetTextColor
    mov edx, OFFSET strRule5
    call WriteString
    call Crlf
    call Crlf

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strRule6
    call WriteString
    call Crlf
    mov eax, COLOR_PROMPT
    call SetTextColor
    mov edx, OFFSET strRule7
    call WriteString
    call Crlf
    call Crlf

    call WaitMsg
    ret
DisplayRules ENDP

DisplayStatistics PROC
    call Clrscr
    mov eax, COLOR_TITLE
    call SetTextColor
    mov edx, OFFSET strBanner1
    call WriteString
    call Crlf
    mov edx, OFFSET strStatsTitle
    call WriteString
    call Crlf
    mov edx, OFFSET strBanner1
    call WriteString
    call Crlf
    call Crlf

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strStatPlayed
    call WriteString
    mov eax, COLOR_PROMPT
    call SetTextColor
    mov eax, statsGamesPlayed
    call WriteDec
    call Crlf

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strStatWon
    call WriteString
    mov eax, COLOR_PROMPT
    call SetTextColor
    mov eax, statsGamesWon
    call WriteDec
    call Crlf

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strStatWinPct
    call WriteString
    mov eax, COLOR_PROMPT
    call SetTextColor

    ; Calculate win %: (Won * 100) / Played
    mov eax, statsGamesPlayed
    test eax, eax
    jz ZeroPct
    mov eax, statsGamesWon
    mov ebx, 100
    mul ebx
    mov ebx, statsGamesPlayed
    div ebx
    call WriteDec
    mov al, '%'
    call WriteChar
    jmp StreakStats
ZeroPct:
    mov al, '0'
    call WriteChar
    mov al, '%'
    call WriteChar

StreakStats:
    call Crlf
    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strStatStreak
    call WriteString
    mov eax, COLOR_PROMPT
    call SetTextColor
    mov eax, statsCurrentStreak
    call WriteDec
    call Crlf

    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strStatMaxStk
    call WriteString
    mov eax, COLOR_PROMPT
    call SetTextColor
    mov eax, statsMaxStreak
    call WriteDec
    call Crlf
    call Crlf

    ; Guess Distribution Chart
    mov eax, COLOR_HEADER
    call SetTextColor
    mov edx, OFFSET strStatDistTitle
    call WriteString
    call Crlf

    mov ecx, 0            ; 0..5
DistLoop:
    mov eax, COLOR_PROMPT
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov eax, ecx
    inc eax
    call WriteDec
    mov al, ':'
    call WriteChar
    mov al, ' '
    call WriteChar

    ; Bar graph
    mov edx, statsDist[ecx * 4]
    test edx, edx
    jz EmptyBar

    mov eax, COLOR_GREEN
    call SetTextColor
    push ecx
    mov ecx, edx
BarLoop:
    mov al, 219           ; Solid block character
    call WriteChar
    loop BarLoop
    pop ecx

EmptyBar:
    mov eax, COLOR_PROMPT
    call SetTextColor
    mov al, ' '
    call WriteChar
    mov al, '('
    call WriteChar
    mov eax, statsDist[ecx * 4]
    call WriteDec
    mov al, ')'
    call WriteChar
    call Crlf

    inc ecx
    cmp ecx, MAX_GUESSES
    jl DistLoop

    call Crlf
    call WaitMsg
    ret
DisplayStatistics ENDP

END main
