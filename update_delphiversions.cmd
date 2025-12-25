:<<"::CMDLITERAL"
@ECHO OFF
:: ------------------------------------------------------------------
:: This is a polygot script that works in PowerShell, CMD, and Bash.
:: More informaiton: https://github.com/jimmckeeth/DelphiVersions/
:: ------------------------------------------------------------------

GOTO :CMDSCRIPT
::CMDLITERAL

# -----------------------------------------------------------------------------
# BASH IMPLEMENTATION (Runs in Git Bash, WSL, Linux, macOS)
# -----------------------------------------------------------------------------

REPO_URL="https://github.com/jimmckeeth/DelphiVersions.git"
FOLDER="DelphiVersions"
FILE_TO_KEEP="DelphiVersions.inc"

echo "--- [Bash] Checking for $FOLDER submodule ---"

if [ -d "$FOLDER/.git" ]; then
    echo "[INFO] Submodule already exists."
else
    echo "[INFO] Initializing new submodule..."
    # Add submodule
    git submodule add "$REPO_URL" "$FOLDER" || { echo "[ERROR] Failed to add submodule"; exit 1; }
    
    # Configure Sparse Checkout
    echo "[INFO] Configuring sparse checkout..."
    cd "$FOLDER" || exit
    git sparse-checkout init --cone
    git sparse-checkout set "$FILE_TO_KEEP"
    cd ..
fi

echo "[INFO] Updating $FOLDER..."
git submodule update --remote --merge "$FOLDER"

echo ""
echo "[SUCCESS] $FOLDER contains the latest $FILE_TO_KEEP."
exit 0

:CMDSCRIPT
:: -----------------------------------------------------------------------------
:: BATCH IMPLEMENTATION (Runs in CMD and PowerShell)
:: -----------------------------------------------------------------------------

setlocal
set "REPO_URL=https://github.com/jimmckeeth/DelphiVersions.git"
set "FOLDER_NAME=DelphiVersions"
set "FILE_TO_KEEP=DelphiVersions.inc"

echo --- [CMD] Checking for %FOLDER_NAME% submodule ---

IF EXIST "%FOLDER_NAME%\.git" (
    echo [INFO] Submodule already exists.
) ELSE (
    echo [INFO] Initializing new submodule...
    git submodule add %REPO_URL% %FOLDER_NAME%
    IF ERRORLEVEL 1 (
        echo [ERROR] Failed to add submodule.
        pause
        exit /b 1
    )
    
    echo [INFO] Configuring sparse checkout...
    pushd %FOLDER_NAME%
    git sparse-checkout init --cone
    git sparse-checkout set %FILE_TO_KEEP%
    popd
)

echo [INFO] Updating %FOLDER_NAME%...
git submodule update --remote --merge %FOLDER_NAME%

echo.
echo [SUCCESS] %FOLDER_NAME% contains the latest %FILE_TO_KEEP%.
pause