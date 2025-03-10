@echo off
chcp 65001

echo 1:すべて
echo 2:UIのみ
echo 3:EN
set /p choice="選択してください (1/2/3): "

if "%choice%"=="1" (
    set "folder_paths=jp/UI jp/Other"
    set "apply_jp_files=true"
) else if "%choice%"=="2" (
    set "folder_paths=jp/UI"
    set "apply_jp_files=true"
) else if "%choice%"=="3" (
    echo ダウンロードをスキップします。
    set "apply_jp_files=false"
    goto skip_download
) else (
    echo 無効な選択です。
    goto :eof
)

set "repo_url=https://github.com/nekokoa1217/EIJpPatch"
set "branch=main"
set "destination_folder=.\jp"

for %%f in (%folder_paths%) do (
    call :download_folder_from_github %repo_url% %branch% %%f %destination_folder%
)

:skip_download

REM 後続の処理を続行
set jpLang_folder=".\jp"
set usLang_folder=".\us"
set destination_folder="..\Game\Gamedata\localized\us"
if not exist %usLang_folder% mkdir %usLang_folder%

set current_folder=%cd%

cd "../"
start "" ".\LauncherIcarus.exe"
cd %current_folder%
echo 英語ファイルを初期化しています...
xcopy %usLang_folder%"\*" "%destination_folder%\" /E /H /C /I /Y /Q

:loop
tasklist /FI "IMAGENAME eq Launcher.exe" 2>NUL | find /I "Launcher.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo 英語ファイルのバックアップ中...
    xcopy "%destination_folder%\*" "%usLang_folder%\" /E /H /C /I /Y /Q
    if "%apply_jp_files%"=="true" (
        echo 日本語ファイルを適用中...
        for %%f in (%folder_paths%) do (
            xcopy "%%f\*" "%destination_folder%" /E /H /C /I /Y /Q
        )
    )
    goto end
) else (
    timeout /T 5 >NUL
    goto loop
)

:end
echo 5秒後にウィンドウが閉じます...
timeout /T 5
endlocal

goto :eof

:download_folder_from_github
setlocal
set "repo_url=%~1"
set "branch=%~2"
set "folder_path=%~3"
set "destination_folder=%~4"

set "zip_url=%repo_url%/archive/refs/heads/%branch%.zip"
echo "%zip_url%"

set "temp_dir=%temp%\git_temp"

if exist "%temp_dir%" rd /s /q "%temp_dir%"
mkdir "%temp_dir%"

echo ダウンロード中...
curl -L -o "%temp_dir%\repo.zip" "%zip_url%"
if %errorlevel% neq 0 (
    echo ZIPファイルのダウンロードに失敗しました。
    endlocal
    goto :eof
)

echo 解凍中...
powershell -Command "try { Expand-Archive -Path '%temp_dir%\repo.zip' -DestinationPath '%temp_dir%' } catch { Write-Error 'ZIPファイルの解凍に失敗しました。'; exit 1 }"
if %errorlevel% neq 0 (
    echo ZIPファイルの解凍に失敗しました。
    endlocal
    goto :eof
)

echo コピー中...
set "extracted_folder=%temp_dir%\EIJpPatch-%branch%"

xcopy "%extracted_folder%\%folder_path%\*" "%folder_path%\" /E /H /C /I /Y /Q
if %errorlevel% neq 0 (
    echo ファイルのコピーに失敗しました。
    endlocal
    goto :eof
)
rd /s /q "%temp_dir%"
endlocal

