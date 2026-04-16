@echo off

setlocal enabledelayedexpansion

title Compilando Aseprite v1.3.9...

color 0A



echo.

echo  =====================================================

echo    ASEPRITE v1.3.9 - BUILD AUTOMATICO PARA WINDOWS

echo  =====================================================

echo.

echo  Este script instala todo lo necesario y compila

echo  Aseprite automaticamente. Solo necesitas internet.

echo.

echo  Tiempo estimado: 30-60 minutos (primera vez)

echo  NO cierres esta ventana.

echo.

echo  =====================================================

echo.



:: ---- PASO 1/6: Git ----

echo  [PASO 1/6] Verificando Git...

git --version >nul 2>&1

if errorlevel 1 (

    echo  Git no encontrado. Instalando via winget...

    winget install --id Git.Git -e --source winget --silent --accept-package-agreements --accept-source-agreements

    if errorlevel 1 (

        echo  winget fallo. Descargando Git manualmente...

        powershell -NoProfile -Command "Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.2/Git-2.47.1.2-64-bit.exe' -OutFile '%TEMP%\git_installer.exe'"

        "%TEMP%\git_installer.exe" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"

    )

    :: Agregar git al PATH de esta sesion

    set "PATH=C:\Program Files\Git\bin;C:\Program Files\Git\cmd;%PATH%"

    git --version >nul 2>&1

    if errorlevel 1 (

        echo  ERROR: No se pudo instalar Git.

        echo  Instala Git manualmente desde https://git-scm.com y vuelve a ejecutar.

        pause & exit /b 1

    )

    echo  Git instalado correctamente.

) else (

    for /f "tokens=*" %%v in ('git --version') do echo  %%v encontrado. OK

)

:: Agregar git al PATH por si acaso

set "PATH=C:\Program Files\Git\bin;C:\Program Files\Git\cmd;%PATH%"



:: ---- PASO 2/6: Visual Studio Build Tools ----

echo.

echo  [PASO 2/6] Verificando Visual Studio 2022 Build Tools...



set "VCVARS=C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat"

if not exist "%VCVARS%" (

    echo  VS 2022 Build Tools NO encontrado.

    echo  Descargando e instalando... (~3 GB, puede tardar 15-25 min)

    echo  Si aparece un cuadro UAC, acepta el permiso de administrador.

    powershell -NoProfile -Command "Write-Host '  Descargando instalador...'; Invoke-WebRequest -UseBasicParsing -Uri 'https://aka.ms/vs/17/release/vs_buildtools.exe' -OutFile '%TEMP%\vs_buildtools.exe'"

    echo  Instalando VS 2022 Build Tools con C++ y CMake...

    "%TEMP%\vs_buildtools.exe" --quiet --wait --norestart --nocache ^

        --installPath "C:\Program Files\Microsoft Visual Studio\2022\BuildTools" ^

        --add Microsoft.VisualStudio.Workload.VCTools ^

        --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^

        --add Microsoft.VisualStudio.Component.Windows11SDK.26100 ^

        --add Microsoft.VisualStudio.Component.VC.CMake.Project ^

        --add Microsoft.VisualStudio.Component.VC.Ninja.Project

    echo  VS 2022 Build Tools instalado.

) else (

    echo  VS 2022 Build Tools encontrado. OK

)



:: ---- PASO 3/6: Inicializar entorno de compilacion ----

echo.

echo  [PASO 3/6] Inicializando entorno de compilacion x64...

call "%VCVARS%" x64

echo  Entorno VS x64 inicializado.



cmake --version >nul 2>&1

if errorlevel 1 (

    for /d /r "C:\Program Files\Microsoft Visual Studio\2022\BuildTools" %%d in (CMake\bin) do (

        if exist "%%d\cmake.exe" ( set "PATH=%%d;%PATH%" & goto :cmake_ok )

    )

    echo  ERROR: cmake no encontrado. & pause & exit /b 1

)

:cmake_ok



ninja --version >nul 2>&1

if errorlevel 1 (

    for /d /r "C:\Program Files\Microsoft Visual Studio\2022\BuildTools" %%d in (Ninja) do (

        if exist "%%d\ninja.exe" ( set "PATH=%%d;%PATH%" & goto :ninja_ok )

    )

    echo  ERROR: ninja no encontrado. & pause & exit /b 1

)

:ninja_ok

echo  cmake y ninja listos. OK



:: ---- PASO 4/6: Descargar Skia ----

echo.

echo  [PASO 4/6] Verificando Skia...

if exist "C:\deps\skia\out\Release-x64\skia.lib" (

    echo  Skia ya descargado. OK

    goto :skia_done

)

mkdir C:\deps\skia 2>nul

echo  Descargando Skia binaries desde GitHub (~50 MB)...

powershell -NoProfile -Command "Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/aseprite/skia/releases/download/m102-861e4743af/Skia-Windows-Release-x64.zip' -OutFile 'C:\deps\skia\skia.zip'"

if not exist "C:\deps\skia\skia.zip" ( echo  ERROR al descargar Skia. & pause & exit /b 1 )

echo  Extrayendo Skia...

powershell -NoProfile -Command "Expand-Archive -Force -Path 'C:\deps\skia\skia.zip' -DestinationPath 'C:\deps\skia'"

del C:\deps\skia\skia.zip 2>nul

if not exist "C:\deps\skia\out\Release-x64\skia.lib" ( echo  ERROR: skia.lib no encontrado. & pause & exit /b 1 )

:skia_done

echo  Skia OK.



:: ---- PASO 5/6: Clonar y preparar Aseprite ----

echo.

echo  [PASO 5/6] Descargando Aseprite v1.3.9...

if not exist "C:\aseprite\.git" (

    echo  Clonando repositorio de Aseprite con submodulos...

    git clone --recursive https://github.com/aseprite/aseprite.git C:\aseprite

    if errorlevel 1 ( echo  ERROR al clonar Aseprite. & pause & exit /b 1 )

)

cd /d C:\aseprite

git fetch --tags

git checkout v1.3.9

git submodule update --init --recursive

echo  Aseprite v1.3.9 listo. OK



:: ---- PASO 6/6: CMake + Ninja ----

echo.

echo  [PASO 6/6] Configurando y compilando Aseprite...

echo  (Este paso puede tomar 20-40 minutos, no cierres la ventana)

echo.

if exist "C:\aseprite\build" rmdir /S /Q C:\aseprite\build

mkdir C:\aseprite\build

cd /d C:\aseprite\build



cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ^

    -DLAF_BACKEND=skia ^

    -DSKIA_DIR=C:\deps\skia ^

    -DSKIA_LIBRARY_DIR=C:\deps\skia\out\Release-x64 ^

    -DSKIA_LIBRARY=C:\deps\skia\out\Release-x64\skia.lib ^

    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ^

    -G Ninja ..

if errorlevel 1 ( echo  ERROR en CMake configure. & pause & exit /b 1 )



ninja aseprite

if errorlevel 1 ( echo  ERROR al compilar. & pause & exit /b 1 )



:: ---- Copiar binarios al Desktop ----

echo.

echo  =====================================================

echo    BUILD COMPLETADO CON EXITO!

echo  =====================================================

echo.

set "DEST=%USERPROFILE%\Desktop\Aseprite_v1.3.9"

mkdir "%DEST%" 2>nul

xcopy /E /I /Y "C:\aseprite\build\bin\*" "%DEST%\" >nul

echo  Aseprite copiado a: %DEST%

echo.

echo  Ejecuta aseprite.exe desde esa carpeta. Disfruta!

echo.

pause
