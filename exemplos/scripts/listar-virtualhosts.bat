@echo off
REM Script para listar todos os Virtual Hosts configurados
REM Uso: listar-virtualhosts.bat

setlocal enabledelayedexpansion

echo.
echo 📋 Listando Virtual Hosts Configurados
echo ======================================
echo.

REM Verificar se o XAMPP está instalado
if not exist "C:\xampp\apache\conf\extra\httpd-vhosts.conf" (
    echo ❌ ERRO: XAMPP não encontrado em C:\xampp\
    echo    Verifique se o XAMPP está instalado corretamente.
    pause
    exit /b 1
)

REM Verificar se existem Virtual Hosts
findstr /C:"ServerName" "C:\xampp\apache\conf\extra\httpd-vhosts.conf" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Nenhum Virtual Host configurado encontrado.
    echo.
    echo 💡 Para criar um Virtual Host, use:
    echo    criar-virtualhost.bat nome-do-projeto "caminho-do-projeto"
    pause
    exit /b 0
)

echo ✅ Virtual Hosts encontrados:
echo.

REM Extrair informações dos Virtual Hosts
set "contador=0"
for /f "tokens=*" %%a in ('findstr /C:"ServerName" "C:\xampp\apache\conf\extra\httpd-vhosts.conf"') do (
    set /a contador+=1
    set "linha=%%a"
    
    REM Extrair nome do servidor
    for /f "tokens=2" %%b in ("!linha!") do set "servidor=%%b"
    
    REM Encontrar DocumentRoot correspondente
    set "documentroot="
    for /f "tokens=*" %%c in ('findstr /A:5 /B:5 /C:"!servidor!" "C:\xampp\apache\conf\extra\httpd-vhosts.conf"') do (
        echo %%c | findstr /C:"DocumentRoot" >nul 2>&1
        if not errorlevel 1 (
            for /f "tokens=2" %%d in ("%%c") do set "documentroot=%%d"
        )
    )
    
    REM Encontrar porta
    set "porta=80"
    for /f "tokens=*" %%e in ('findstr /A:10 /B:10 /C:"!servidor!" "C:\xampp\apache\conf\extra\httpd-vhosts.conf"') do (
        echo %%e | findstr /C:"VirtualHost" >nul 2>&1
        if not errorlevel 1 (
            echo %%e | findstr /C:":8080" >nul 2>&1
            if not errorlevel 1 set "porta=8080"
            echo %%e | findstr /C:":3000" >nul 2>&1
            if not errorlevel 1 set "porta=3000"
        )
    )
    
    REM Verificar se o caminho existe
    set "status=❌"
    if exist "!documentroot!" set "status=✅"
    
    REM Exibir informações
    echo [!contador!] !servidor!
    echo    📁 Caminho: !documentroot!
    echo    🌐 Porta: !porta!
    echo    🔗 URL: http://!servidor!:!porta!/
    echo    📊 Status: !status!
    echo.
)

REM Verificar entradas no arquivo hosts
echo 📋 Entradas no arquivo hosts:
echo.
findstr /C:".local" "C:\Windows\System32\drivers\etc\hosts" 2>nul
if errorlevel 1 (
    echo ⚠️  Nenhuma entrada .local encontrada no arquivo hosts
) else (
    echo ✅ Entradas .local encontradas
)

echo.
echo 📊 Resumo:
echo    Total de Virtual Hosts: %contador%
echo    Arquivo de configuração: C:\xampp\apache\conf\extra\httpd-vhosts.conf
echo    Arquivo hosts: C:\Windows\System32\drivers\etc\hosts
echo.

REM Verificar status do Apache
echo 🔍 Status do Apache:
netstat -an | findstr ":80 " >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Apache não está rodando na porta 80
) else (
    echo ✅ Apache está rodando na porta 80
)

netstat -an | findstr ":8080 " >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Apache não está rodando na porta 8080
) else (
    echo ✅ Apache está rodando na porta 8080
)

echo.
echo 💡 Comandos úteis:
echo    - Para remover um Virtual Host: remover-virtualhost.bat nome-do-projeto
echo    - Para validar configuração: validar-configuracao.bat
echo    - Para criar novo Virtual Host: criar-virtualhost.bat nome-do-projeto "caminho"
echo.

pause
