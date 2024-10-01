::========== LuaSTG Sub ==========

@cd %~dp0
@cd ..
@echo %cd%

@setlocal
    :: Env

    @set LUASTG_BUILD_DIR=%cd%\engine\build
    @set LUASTG_DOC_DIR=%cd%\engine\luastg\doc
    @set DOC_DIR=%cd%\doc
    @set GAME_DIR=%cd%\game
    @set BUILD_DIR=%cd%\build
    @set TOOLS_DIR=%cd%\tools

    :: Doc

    @rmdir    %DOC_DIR%           /s /q
    @robocopy %LUASTG_DOC_DIR%    %DOC_DIR%    /e
    @del      "%DOC_DIR%/.git"

    :: LuaJIT

    @set LUASTG_BUILD_LUAJIT_DIR=%LUASTG_BUILD_DIR%\develop\x86\external\luajit\Release

    ::@del  %TOOLS_DIR%\luajit.exe
    ::@del  %TOOLS_DIR%\lua51.dll

    ::@copy %LUASTG_BUILD_LUAJIT_DIR%\luajit.exe    %TOOLS_DIR%\luajit.exe
    ::@copy %LUASTG_BUILD_LUAJIT_DIR%\lua51.dll     %TOOLS_DIR%\lua51.dll

    :: Develop

    @set LUASTG_BUILD_DEVELOP_DIR=%LUASTG_BUILD_DIR%\develop\x86\LuaSTG\Release

    @del  %GAME_DIR%\RGL.exe
    ::@del  %GAME_DIR%\xaudio2_9redist.dll
    ::@del  %GAME_DIR%\d3dcompiler_47.dll

    @copy %LUASTG_BUILD_DEVELOP_DIR%\LuaSTG.exe             %GAME_DIR%\RGL.exe
    ::@copy %LUASTG_BUILD_DEVELOP_DIR%\xaudio2_9redist.dll    %GAME_DIR%\xaudio2_9redist.dll
    ::@copy %LUASTG_BUILD_DEVELOP_DIR%\d3dcompiler_47.dll     %GAME_DIR%\d3dcompiler_47.dll
@endlocal
