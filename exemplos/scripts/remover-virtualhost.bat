@echo off
REM Script para remover Virtual Host automaticamente
REM Uso: remover-virtualhost.bat nome-do-projeto

setlocal enabledelayedexpansion

REM Verificar se o parâmetro foi fornecido
if "%~1"=="" (
    echo.
    echo ⚠️  ERRO: Parâmetro insuficiente!
    echo.
    echo Uso: remover-virtualhost.bat ^<nome-do-projeto^>
    echo.
    echo Exemplo: remover-virtualhost.bat meuprojeto
    echo.
    pause
    exit /b 1
)

set PROJETO_NOME=%~1

echo.
echo 🗑️  Removendo Virtual Host: %PROJETO_NOME%
echo.

REM Verificar se o XAMPP está instalado
if not exist "C:\xampp\apache\conf\extra\httpd-vhosts.conf" (
    echo ❌ ERRO: XAMPP não encontrado em C:\xampp\
    echo    Verifique se o XAMPP está instalado corretamente.
    pause
    exit /b 1
)

REM Fazer backup do arquivo httpd-vhosts.conf
echo 📋 Fazendo backup do arquivo httpd-vhosts.conf...
copy "C:\xampp\apache\conf\extra\httpd-vhosts.conf" "C:\xampp\apache\conf\extra\httpd-vhosts.conf.backup.%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%" >nul 2>&1

REM Remover configuração do httpd-vhosts.conf
echo 📝 Removendo configuração do httpd-vhosts.conf...
powershell -Command "Get-Content 'C:\xampp\apache\conf\extra\httpd-vhosts.conf' | Where-Object { $_ -notmatch '%PROJETO_NOME%.local' -and $_ -notmatch 'Virtual Host criado automaticamente' } | Set-Content 'C:\xampp\apache\conf\extra\httpd-vhosts.conf'"

REM Fazer backup do arquivo hosts
echo 📋 Fazendo backup do arquivo hosts...
copy "C:\Windows\System32\drivers\etc\hosts" "C:\Windows\System32\drivers\etc\hosts.backup.%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%" >nul 2>&1

REM Remover entrada do arquivo hosts
echo 📝 Removendo entrada do arquivo hosts...
powershell -Command "Get-Content 'C:\Windows\System32\drivers\etc\hosts' | Where-Object { $_ -notmatch '%PROJETO_NOME%.local' } | Set-Content 'C:\Windows\System32\drivers\etc\hosts'"

REM Testar configuração do Apache
echo 🔍 Testando configuração do Apache...
"C:\xampp\apache\bin\httpd.exe" -t >nul 2>&1
if errorlevel 1 (
    echo ❌ ERRO: Configuração do Apache inválida após remoção!
    echo    Restaurando backup...
    copy "C:\xampp\apache\conf\extra\httpd-vhosts.conf.backup.%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%" "C:\xampp\apache\conf\extra\httpd-vhosts.conf" >nul 2>&1
    pause
    exit /b 1
)

echo ✅ Configuração do Apache válida!

REM Limpar cache DNS
echo 🧹 Limpando cache DNS...
ipconfig /flushdns >nul 2>&1

echo.
echo 🎉 Virtual Host removido com sucesso!
echo.
echo 📋 Resumo da remoção:
echo    Nome: %PROJETO_NOME%.local
echo    Configuração removida do httpd-vhosts.conf
echo    Entrada removida do arquivo hosts
echo.
echo ⚠️  PRÓXIMOS PASSOS:
echo    1. Reinicie o Apache no XAMPP Control Panel
echo    2. O site http://%PROJETO_NOME%.local/ não funcionará mais
echo.
echo 💾 Backups criados:
echo    - httpd-vhosts.conf.backup.[timestamp]
echo    - hosts.backup.[timestamp]
echo.

pause
