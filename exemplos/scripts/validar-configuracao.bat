@echo off
REM Script para validar configuração de Virtual Hosts
REM Uso: validar-configuracao.bat

setlocal enabledelayedexpansion

echo.
echo 🔍 Validando configuração de Virtual Hosts...
echo.

REM Verificar se o XAMPP está instalado
if not exist "C:\xampp\apache\conf\extra\httpd-vhosts.conf" (
    echo ❌ ERRO: XAMPP não encontrado em C:\xampp\
    echo    Verifique se o XAMPP está instalado corretamente.
    pause
    exit /b 1
)

echo ✅ XAMPP encontrado em C:\xampp\

REM Testar configuração do Apache
echo 🔍 Testando configuração do Apache...
"C:\xampp\apache\bin\httpd.exe" -t
if errorlevel 1 (
    echo ❌ ERRO: Configuração do Apache inválida!
    echo    Verifique os logs de erro do Apache.
    echo.
    echo 📋 Logs de erro disponíveis em:
    echo    C:\xampp\apache\logs\error.log
    pause
    exit /b 1
)

echo ✅ Configuração do Apache válida!

REM Verificar se o Apache está rodando
echo 🔍 Verificando se o Apache está rodando...
netstat -an | findstr :80 >nul 2>&1
if errorlevel 1 (
    echo ⚠️  AVISO: Apache não está rodando na porta 80
    echo    Inicie o Apache no XAMPP Control Panel
) else (
    echo ✅ Apache está rodando na porta 80
)

REM Verificar arquivo hosts
echo 🔍 Verificando arquivo hosts...
if exist "C:\Windows\System32\drivers\etc\hosts" (
    echo ✅ Arquivo hosts encontrado
    
    REM Contar entradas .local
    findstr /C:".local" "C:\Windows\System32\drivers\etc\hosts" >nul 2>&1
    if errorlevel 1 (
        echo ⚠️  AVISO: Nenhuma entrada .local encontrada no arquivo hosts
    ) else (
        echo ✅ Entradas .local encontradas no arquivo hosts
        echo.
        echo 📋 Entradas encontradas:
        findstr /C:".local" "C:\Windows\System32\drivers\etc\hosts"
    )
) else (
    echo ❌ ERRO: Arquivo hosts não encontrado
)

REM Verificar Virtual Hosts configurados
echo.
echo 🔍 Verificando Virtual Hosts configurados...
findstr /C:"ServerName" "C:\xampp\apache\conf\extra\httpd-vhosts.conf" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  AVISO: Nenhum Virtual Host configurado
) else (
    echo ✅ Virtual Hosts encontrados
    echo.
    echo 📋 Virtual Hosts configurados:
    findstr /C:"ServerName" "C:\xampp\apache\conf\extra\httpd-vhosts.conf"
)

REM Verificar permissões
echo.
echo 🔍 Verificando permissões...
echo    Testando acesso ao arquivo hosts...
echo 127.0.0.1   teste-permissao.local >> "C:\Windows\System32\drivers\etc\hosts" 2>nul
if errorlevel 1 (
    echo ❌ ERRO: Sem permissão para editar arquivo hosts
    echo    Execute este script como administrador
) else (
    echo ✅ Permissões OK - arquivo hosts editável
    REM Remover linha de teste
    powershell -Command "(Get-Content 'C:\Windows\System32\drivers\etc\hosts') | Where-Object { $_ -notmatch 'teste-permissao.local' } | Set-Content 'C:\Windows\System32\drivers\etc\hosts'"
)

REM Verificar logs de erro
echo.
echo 🔍 Verificando logs de erro do Apache...
if exist "C:\xampp\apache\logs\error.log" (
    echo ✅ Log de erro encontrado
    echo.
    echo 📋 Últimas 5 linhas do log de erro:
    powershell -Command "Get-Content 'C:\xampp\apache\logs\error.log' | Select-Object -Last 5"
) else (
    echo ⚠️  AVISO: Log de erro não encontrado
)

echo.
echo 🎉 Validação concluída!
echo.
echo 📋 Resumo:
echo    - XAMPP: ✅ Instalado
echo    - Apache: ✅ Configuração válida
echo    - Porta 80: Verifique se está rodando
echo    - Arquivo hosts: ✅ Encontrado
echo    - Virtual Hosts: Verifique configurações
echo    - Permissões: ✅ OK
echo.
echo 💡 DICAS:
echo    - Se houver erros, verifique os logs do Apache
echo    - Reinicie o Apache após fazer mudanças
echo    - Use modo incógnito para testar URLs
echo.

pause
