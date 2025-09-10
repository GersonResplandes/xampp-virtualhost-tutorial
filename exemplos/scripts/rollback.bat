@echo off
REM Script para fazer rollback de configurações de Virtual Hosts
REM Uso: rollback.bat [timestamp] ou rollback.bat list

setlocal enabledelayedexpansion

echo.
echo 🔄 Sistema de Rollback de Virtual Hosts
echo ======================================
echo.

REM Verificar se o XAMPP está instalado
if not exist "C:\xampp\apache\conf\extra\httpd-vhosts.conf" (
    echo ❌ ERRO: XAMPP não encontrado em C:\xampp\
    echo    Verifique se o XAMPP está instalado corretamente.
    pause
    exit /b 1
)

REM Se o parâmetro for "list", listar backups disponíveis
if "%~1"=="list" (
    echo 📋 Backups disponíveis:
    echo.
    
    REM Listar backups do httpd-vhosts.conf
    echo 🔧 Backups do httpd-vhosts.conf:
    for %%f in ("C:\xampp\apache\conf\extra\httpd-vhosts.conf.backup.*") do (
        set "arquivo=%%f"
        set "nome=%%~nf"
        set "timestamp=!nome:httpd-vhosts.conf.backup.=!"
        echo    !timestamp!
    )
    
    echo.
    echo 🌐 Backups do arquivo hosts:
    for %%f in ("C:\Windows\System32\drivers\etc\hosts.backup.*") do (
        set "arquivo=%%f"
        set "nome=%%~nf"
        set "timestamp=!nome:hosts.backup.=!"
        echo    !timestamp!
    )
    
    echo.
    echo 💡 Para fazer rollback, use: rollback.bat timestamp
    echo    Exemplo: rollback.bat 20250109_143022
    pause
    exit /b 0
)

REM Verificar se o timestamp foi fornecido
if "%~1"=="" (
    echo ⚠️  ERRO: Timestamp não fornecido!
    echo.
    echo Uso: rollback.bat [timestamp]
    echo.
    echo Para listar backups disponíveis: rollback.bat list
    echo.
    pause
    exit /b 1
)

set "timestamp=%~1"

echo 🔄 Executando rollback para timestamp: %timestamp%
echo.

REM Verificar se os backups existem
set "backup_vhosts=C:\xampp\apache\conf\extra\httpd-vhosts.conf.backup.%timestamp%"
set "backup_hosts=C:\Windows\System32\drivers\etc\hosts.backup.%timestamp%"

if not exist "%backup_vhosts%" (
    echo ❌ ERRO: Backup do httpd-vhosts.conf não encontrado: %backup_vhosts%
    echo.
    echo 💡 Use 'rollback.bat list' para ver backups disponíveis.
    pause
    exit /b 1
)

if not exist "%backup_hosts%" (
    echo ❌ ERRO: Backup do arquivo hosts não encontrado: %backup_hosts%
    echo.
    echo 💡 Use 'rollback.bat list' para ver backups disponíveis.
    pause
    exit /b 1
)

REM Fazer backup dos arquivos atuais antes do rollback
echo 📋 Fazendo backup dos arquivos atuais...
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "current_timestamp=%YYYY%%MM%%DD%_%HH%%Min%%Sec%"

copy "C:\xampp\apache\conf\extra\httpd-vhosts.conf" "C:\xampp\apache\conf\extra\httpd-vhosts.conf.backup.%current_timestamp%" >nul 2>&1
copy "C:\Windows\System32\drivers\etc\hosts" "C:\Windows\System32\drivers\etc\hosts.backup.%current_timestamp%" >nul 2>&1

echo ✅ Backup atual criado: %current_timestamp%

REM Executar rollback
echo 🔄 Restaurando configurações...
copy "%backup_vhosts%" "C:\xampp\apache\conf\extra\httpd-vhosts.conf" >nul 2>&1
copy "%backup_hosts%" "C:\Windows\System32\drivers\etc\hosts" >nul 2>&1

REM Validar configuração após rollback
echo 🔍 Validando configuração após rollback...
"C:\xampp\apache\bin\httpd.exe" -t >nul 2>&1
if errorlevel 1 (
    echo ❌ ERRO: Configuração inválida após rollback!
    echo 🔄 Restaurando configuração atual...
    
    REM Restaurar configuração atual
    copy "C:\xampp\apache\conf\extra\httpd-vhosts.conf.backup.%current_timestamp%" "C:\xampp\apache\conf\extra\httpd-vhosts.conf" >nul 2>&1
    copy "C:\Windows\System32\drivers\etc\hosts.backup.%current_timestamp%" "C:\Windows\System32\drivers\etc\hosts" >nul 2>&1
    
    echo ✅ Configuração atual restaurada.
    echo 📋 Verifique os logs do Apache para mais detalhes.
    pause
    exit /b 1
)

echo ✅ Configuração válida após rollback!

REM Limpar cache DNS
echo 🧹 Limpando cache DNS...
ipconfig /flushdns >nul 2>&1

echo.
echo 🎉 Rollback concluído com sucesso!
echo.
echo 📋 Resumo do rollback:
echo    Timestamp restaurado: %timestamp%
echo    Backup atual criado: %current_timestamp%
echo    Configuração validada: ✅
echo.
echo ⚠️  PRÓXIMOS PASSOS:
echo    1. Reinicie o Apache no XAMPP Control Panel
echo    2. Teste os Virtual Hosts restaurados
echo    3. Verifique se tudo está funcionando corretamente
echo.
echo 💾 Backups disponíveis:
echo    - httpd-vhosts.conf.backup.%timestamp% (restaurado)
echo    - hosts.backup.%timestamp% (restaurado)
echo    - httpd-vhosts.conf.backup.%current_timestamp% (configuração anterior)
echo    - hosts.backup.%current_timestamp% (configuração anterior)
echo.

pause
