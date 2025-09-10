@echo off
REM Script Avançado para criar Virtual Host automaticamente no XAMPP
REM Versão melhorada com validação robusta e rollback automático
REM Uso: criar-virtualhost-avancado.bat nome-do-projeto caminho-do-projeto [porta]

setlocal enabledelayedexpansion

REM Verificar se os parâmetros foram fornecidos
if "%~2"=="" (
    echo.
    echo ⚠️  ERRO: Parâmetros insuficientes!
    echo.
    echo Uso: criar-virtualhost-avancado.bat ^<nome-do-projeto^> ^<caminho-do-projeto^> [porta]
    echo.
    echo Exemplo: criar-virtualhost-avancado.bat meuprojeto "C:\Users\Usuario\Projetos\meuprojeto" 8080
    echo.
    pause
    exit /b 1
)

set PROJETO_NOME=%~1
set PROJETO_CAMINHO=%~2
set PORTA=%~3
if "%PORTA%"=="" set PORTA=80

echo.
echo 🚀 Criando Virtual Host Avançado para: %PROJETO_NOME%
echo 📁 Caminho: %PROJETO_CAMINHO%
echo 🌐 Porta: %PORTA%
echo.

REM ===========================================
REM VALIDAÇÃO ROBUSTA DE ENTRADA
REM ===========================================

REM Validar nome do projeto (sem caracteres especiais)
echo %PROJETO_NOME% | findstr /R "^[a-zA-Z0-9_-]*$" >nul
if errorlevel 1 (
    echo ❌ ERRO: Nome do projeto contém caracteres inválidos!
    echo    Use apenas letras, números, hífens e underscores.
    pause
    exit /b 1
)

REM Validar porta (número entre 1 e 65535)
echo %PORTA% | findstr /R "^[0-9]*$" >nul
if errorlevel 1 (
    echo ❌ ERRO: Porta deve ser um número!
    pause
    exit /b 1
)

if %PORTA% LSS 1 (
    echo ❌ ERRO: Porta deve ser maior que 0!
    pause
    exit /b 1
)

if %PORTA% GTR 65535 (
    echo ❌ ERRO: Porta deve ser menor que 65536!
    pause
    exit /b 1
)

REM Validar formato do caminho
echo %PROJETO_CAMINHO% | findstr /R "^[A-Za-z]:\\.*" >nul
if errorlevel 1 (
    echo ❌ ERRO: Caminho deve ser absoluto (ex: C:\caminho\projeto)!
    pause
    exit /b 1
)

REM ===========================================
REM VERIFICAÇÕES DE PRÉ-REQUISITOS
REM ===========================================

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

REM Verificar se já existe Virtual Host com o mesmo nome
findstr /C:"ServerName %PROJETO_NOME%.local" "C:\xampp\apache\conf\extra\httpd-vhosts.conf" >nul 2>&1
if not errorlevel 1 (
    echo ❌ ERRO: Já existe um Virtual Host com o nome: %PROJETO_NOME%.local
    echo    Escolha um nome diferente.
    pause
    exit /b 1
)

REM Verificar se a porta está em uso (apenas para porta 80)
if %PORTA%==80 (
    netstat -an | findstr ":80 " >nul 2>&1
    if not errorlevel 1 (
        echo ⚠️  AVISO: Porta 80 está em uso. Verifique se o Apache está rodando.
    )
)

REM ===========================================
REM BACKUP COM TIMESTAMP COMPATÍVEL
REM ===========================================

REM Criar timestamp compatível com diferentes localizações
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "timestamp=%YYYY%%MM%%DD%_%HH%%Min%%Sec%"

echo 📋 Fazendo backup dos arquivos de configuração...
copy "C:\xampp\apache\conf\extra\httpd-vhosts.conf" "C:\xampp\apache\conf\extra\httpd-vhosts.conf.backup.%timestamp%" >nul 2>&1
copy "C:\Windows\System32\drivers\etc\hosts" "C:\Windows\System32\drivers\etc\hosts.backup.%timestamp%" >nul 2>&1

REM ===========================================
REM CRIAÇÃO DO VIRTUAL HOST
REM ===========================================

echo 📝 Criando configuração do Virtual Host...

REM Criar arquivo temporário com a configuração
set "temp_config=%temp%\vhost_config_%timestamp%.tmp"
(
echo.
echo # Virtual Host criado automaticamente em %date% %time%
echo # Projeto: %PROJETO_NOME%
echo # Porta: %PORTA%
echo ^<VirtualHost *:%PORTA%^>
echo     ServerName %PROJETO_NOME%.local
echo     DocumentRoot "%PROJETO_CAMINHO%"
echo     ^<Directory "%PROJETO_CAMINHO%"^>
echo         Options Indexes FollowSymLinks Includes ExecCGI
echo         AllowOverride All
echo         Require all granted
echo     ^</Directory^>
echo ^</VirtualHost^>
) > "%temp_config%"

REM Adicionar ao arquivo httpd-vhosts.conf
type "%temp_config%" >> "C:\xampp\apache\conf\extra\httpd-vhosts.conf"
del "%temp_config%"

REM Adicionar entrada ao arquivo hosts
echo 127.0.0.1   %PROJETO_NOME%.local >> "C:\Windows\System32\drivers\etc\hosts"

REM ===========================================
REM VALIDAÇÃO E ROLLBACK
REM ===========================================

echo 🔍 Validando configuração do Apache...
"C:\xampp\apache\bin\httpd.exe" -t >nul 2>&1
if errorlevel 1 (
    echo ❌ ERRO: Configuração do Apache inválida!
    echo 🔄 Executando rollback automático...
    
    REM Rollback do httpd-vhosts.conf
    copy "C:\xampp\apache\conf\extra\httpd-vhosts.conf.backup.%timestamp%" "C:\xampp\apache\conf\extra\httpd-vhosts.conf" >nul 2>&1
    
    REM Rollback do hosts
    copy "C:\Windows\System32\drivers\etc\hosts.backup.%timestamp%" "C:\Windows\System32\drivers\etc\hosts" >nul 2>&1
    
    echo ✅ Rollback concluído. Configuração restaurada.
    echo 📋 Verifique os logs do Apache para mais detalhes.
    pause
    exit /b 1
)

echo ✅ Configuração do Apache válida!

REM ===========================================
REM FINALIZAÇÃO
REM ===========================================

REM Limpar cache DNS
echo 🧹 Limpando cache DNS...
ipconfig /flushdns >nul 2>&1

REM Criar arquivo de log
set "log_file=%PROJETO_CAMINHO%\vhost_creation.log"
echo Virtual Host criado em %date% %time% > "%log_file%"
echo Nome: %PROJETO_NOME%.local >> "%log_file%"
echo Caminho: %PROJETO_CAMINHO% >> "%log_file%"
echo Porta: %PORTA% >> "%log_file%"
echo Backup: %timestamp% >> "%log_file%"

echo.
echo 🎉 Virtual Host criado com sucesso!
echo.
echo 📋 Resumo da configuração:
echo    Nome: %PROJETO_NOME%.local
echo    Caminho: %PROJETO_CAMINHO%
echo    Porta: %PORTA%
echo    URL: http://%PROJETO_NOME%.local:%PORTA%/
echo    Log: %log_file%
echo.
echo ⚠️  PRÓXIMOS PASSOS:
echo    1. Reinicie o Apache no XAMPP Control Panel
echo    2. Acesse http://%PROJETO_NOME%.local:%PORTA%/ no navegador
echo    3. Certifique-se de que existe um arquivo index.php ou index.html
echo.
echo 🔒 LEMBRE-SE: Esta configuração é apenas para DESENVOLVIMENTO!
echo    Para produção, use as configurações seguras do arquivo httpd-vhosts-seguro.conf
echo.
echo 💾 Backups criados:
echo    - httpd-vhosts.conf.backup.%timestamp%
echo    - hosts.backup.%timestamp%
echo.

pause
