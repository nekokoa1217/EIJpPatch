@echo off
chcp 65001
set gitRepository="xxxx"
set jpLang_folder=".\jp"
set usLang_folder=".\us"
set destination_folder="..\Game\Gamedata\localized\us"

cd "../"
start "" ".\LauncherIcarus.exe"
cd "./jpLocal"

echo 日本語ファイルをダウンロードしています...
xcopy %gitRepository%"\*" "%jpLang_folder%\" /E /H /C /I /Y /Q
echo ダウンロードが完了しました。

echo 英語ファイルを初期化しています...
xcopy %usLang_folder%"\*" "%destination_folder%\" /E /H /C /I /Y /Q
echo 英語ファイルの初期化が完了しました。

:loop
tasklist /FI "IMAGENAME eq Launcher.exe" 2>NUL | find /I "Launcher.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo ICARUSの起動を確認。
    echo 英語ファイルのバックアップをします。
    xcopy "%destination_folder%\*" "%usLang_folder%\" /E /H /C /I /Y /Q
    echo 日本語ファイルを適用します。
    xcopy "%jpLang_folder%\*" "%destination_folder%\" /E /H /C /I /Y /Q
    echo 日本語ファイルを適用が完了しました。
    goto end
) else (
    timeout /T 5 >NUL
    goto loop
)


:end
echo 5秒後にウィンドウが閉じます...
timeout /T 5
endlocal

