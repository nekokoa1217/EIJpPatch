@echo off
chcp 65001
set jpLang_folder=".\jp"
set usLang_folder=".\us"
set destination_folder="..\Game\Gamedata\localized\us"

if not exist %usLang_folder% mkdir %usLang_folder%

set current_folder=%cd%

cd "../"
start "" ".\LauncherIcarus.exe"
cd %current_folder%

echo 英語ファイルを初期化しています...
xcopy %usLang_folder%"\*" "%destination_folder%\" /E /H /C /I /Y

:loop
tasklist /FI "IMAGENAME eq Launcher.exe" 2>NUL | find /I "Launcher.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo 英語ファイルのバックアップ中...
    xcopy "%destination_folder%\*" "%usLang_folder%\" /E /H /C /I /Y
    echo 日本語ファイルを適用中...
    xcopy "%jpLang_folder%\*" "%destination_folder%\" /E /H /C /I /Y
    goto end
) else (
    timeout /T 5 >NUL
    goto loop
)

:end
echo 5秒後にウィンドウが閉じます...
timeout /T 5
endlocal

