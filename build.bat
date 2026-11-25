@echo off
setlocal
echo ================================================================
echo Building Assembly Wordle Project (MASM + Irvine32)
echo ================================================================

rem Initialize MSVC 32-bit environment if not already set
if not defined DevEnvDir (
    call "D:\IDE\VC\Auxiliary\Build\vcvars32.bat"
)

rem Assemble main.asm
ml /c /coff /nologo /I"C:\Irvine" main.asm
if errorlevel 1 (
    echo [ERROR] Assembling failed!
    exit /b 1
)

rem Link main.obj with Irvine32 library
link /nologo /SUBSYSTEM:CONSOLE /LIBPATH:"C:\Irvine" main.obj Irvine32.lib kernel32.lib user32.lib /OUT:Wordle.exe
if errorlevel 1 (
    echo [ERROR] Linking failed!
    exit /b 1
)

echo.
echo ================================================================
echo [SUCCESS] Wordle.exe built successfully!
echo Run 'Wordle.exe' to play the game.
echo ================================================================
