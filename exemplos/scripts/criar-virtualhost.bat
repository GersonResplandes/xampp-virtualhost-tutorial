@echo off
REM Script para criar Virtual Host automaticamente no XAMPP
REM Uso: criar-virtualhost.bat nome-do-projeto caminho-do-projeto

setlocal enabledelayedexpansion

REM Verificar se os parâmetros foram fornecidos
if "%~2"=="" (
    echo.
    echo ⚠️  ERRO: Parâmetros insuficientes!
    echo.
    echo Uso: criar-virtualhost.bat ^<nome-do-projeto^> ^<caminho-do-projeto^>
    echo.
    echo Exemplo: criar-virtualhost.bat meuprojeto "C:\Users\Usuario\Projetos\meuprojeto"
    echo.
    pause
    exit /b 1
)

set PROJETO_NOME=%~1
set PROJETO_CAMINHO=%~2

echo.
echo 🚀 Criando Virtual Host para: %PROJETO_NOME%
echo 📁 Caminho: %PROJETO_CAMINHO%
echo.

REM Verificar se o XAMPP está instalado
if not exist "C:\xampp\apache\conf\extra\httpd-vhosts.conf" (
    echo ❌ ERRO: XAMPP não encontrado em C:\xampp\
    echo    Verifique se o XAMPP está instalado corretamente.
    pause
    exit /b 1
)

REM Verificar se o caminho do projeto existe
if not exist "%PROJETO_CAMINHO%" (
    echo ❌ ERRO: Caminho do projeto não existe: %PROJETO_CAMINHO%
    echo    Verifique se o caminho está correto.
    pause
    exit /b 1
)

REM Fazer backup do arquivo httpd-vhosts.conf
echo 📋 Fazendo backup do arquivo httpd-vhosts.conf...
copy "C:\xampp\apache\conf\extra\httpd-vhosts.conf" "C:\xampp\apache\conf\extra\httpd-vhosts.conf.backup.%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%" >nul 2>&1

REM Adicionar configuração ao httpd-vhosts.conf
echo 📝 Adicionando configuração ao httpd-vhosts.conf...
(
echo.
echo # Virtual Host criado automaticamente em %date% %time%
echo ^<VirtualHost *:80^>
echo     ServerName %PROJETO_NOME%.local
echo     DocumentRoot "%PROJETO_CAMINHO%"
echo     ^<Directory "%PROJETO_CAMINHO%"^>
echo         Options Indexes FollowSymLinks Includes ExecCGI
echo         AllowOverride All
echo         Require all granted
echo     ^</Directory^>
echo ^</VirtualHost^>
) >> "C:\xampp\apache\conf\extra\httpd-vhosts.conf"

REM Fazer backup do arquivo hosts
echo 📋 Fazendo backup do arquivo hosts...
copy "C:\Windows\System32\drivers\etc\hosts" "C:\Windows\System32\drivers\etc\hosts.backup.%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%" >nul 2>&1

REM Adicionar entrada ao arquivo hosts
echo 📝 Adicionando entrada ao arquivo hosts...
echo 127.0.0.1   %PROJETO_NOME%.local >> "C:\Windows\System32\drivers\etc\hosts"

REM Testar configuração do Apache
echo 🔍 Testando configuração do Apache...
"C:\xampp\apache\bin\httpd.exe" -t >nul 2>&1
if errorlevel 1 (
    echo ❌ ERRO: Configuração do Apache inválida!
    echo    Verifique os logs de erro do Apache.
    pause
    exit /b 1
)

echo ✅ Configuração do Apache válida!

REM Limpar cache DNS
echo 🧹 Limpando cache DNS...
ipconfig /flushdns >nul 2>&1

echo.
echo 🎉 Virtual Host criado com sucesso!
echo.
echo 📋 Resumo da configuração:
echo    Nome: %PROJETO_NOME%.local
echo    Caminho: %PROJETO_CAMINHO%
echo    URL: http://%PROJETO_NOME%.local/
echo.
echo ⚠️  PRÓXIMOS PASSOS:
echo    1. Reinicie o Apache no XAMPP Control Panel
echo    2. Acesse http://%PROJETO_NOME%.local/ no navegador
echo    3. Certifique-se de que existe um arquivo index.php ou index.html
echo.
echo 🔒 LEMBRE-SE: Esta configuração é apenas para DESENVOLVIMENTO!
echo    Para produção, use as configurações seguras do arquivo httpd-vhosts-seguro.conf
echo.

pause
