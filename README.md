# 🚀 XAMPP Virtual Host Setup (Windows)

[![GitHub stars](https://img.shields.io/github/stars/seu-usuario/xampp-virtualhost-tutorial?style=social)](https://github.com/seu-usuario/xampp-virtualhost-tutorial)
[![GitHub forks](https://img.shields.io/github/forks/seu-usuario/xampp-virtualhost-tutorial?style=social)](https://github.com/seu-usuario/xampp-virtualhost-tutorial)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Aprenda a configurar Virtual Hosts no XAMPP para rodar seus projetos PHP em qualquer pasta do seu computador, sem depender do `htdocs`.**

## 📋 Índice

- [🎯 Sobre](#-sobre)
- [✨ Funcionalidades](#-funcionalidades)
- [📋 Pré-requisitos](#-pré-requisitos)
- [🚀 Configuração Passo a Passo](#-configuração-passo-a-passo)
- [📂 Exemplos](#-exemplos)
- [❓ Problemas Comuns](#-problemas-comuns)
- [🤝 Contribuindo](#-contribuindo)
- [📄 Licença](#-licença)

## 🎯 Sobre

Este repositório ensina como configurar **Virtual Hosts no XAMPP** para Windows, permitindo que você execute seus projetos PHP em pastas personalizadas ao invés de usar apenas o diretório `htdocs`. Isso oferece maior flexibilidade e organização para seus projetos de desenvolvimento.

> ⚠️ **AVISO IMPORTANTE**: Este tutorial é destinado **APENAS para desenvolvimento local**. As configurações padrão são **INSEGURAS para produção** e podem expor seu sistema a vulnerabilidades.

### 🎯 Por que usar Virtual Hosts?

- ✅ **Organização**: Mantenha seus projetos em pastas específicas
- ✅ **URLs amigáveis**: Acesse via `http://projeto.local` ao invés de `http://localhost/projeto`
- ✅ **Flexibilidade**: Não dependa mais do diretório `htdocs`
- ✅ **Produtividade**: Configure uma vez e use em todos os projetos

## ✨ Funcionalidades

- 📂 **Configuração completa** de Virtual Hosts passo a passo
- 🖥️ **Acesso rápido** aos projetos via URLs personalizadas
- ⚙️ **Arquivos de exemplo** prontos para uso (desenvolvimento e produção)
- 🔒 **Configurações seguras** para ambiente de produção
- 📝 **Tutorial detalhado** com screenshots e explicações
- 🔧 **Solução de problemas** comuns e troubleshooting avançado
- 🎨 **Interface moderna** e fácil de seguir
- 🚀 **Alternativas modernas** (Docker, Laravel Valet, etc.)

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter:

- ✅ **XAMPP** instalado no Windows
- ✅ **Apache** rodando no XAMPP
- ✅ **Permissões de administrador** para editar arquivos do sistema
- ✅ **Editor de texto** (Bloco de Notas, VS Code, Notepad++, etc.)

## 🚀 Configuração Passo a Passo

### 📌 Passo 1: Configurar o Apache Virtual Host

1. **Abra o arquivo de configuração:**

   ```
   C:\xampp\apache\conf\extra\httpd-vhosts.conf
   ```

2. **Adicione a configuração no final do arquivo:**

   ```apache
   <VirtualHost *:80>
       ServerName projetoPHP.local
       DocumentRoot "C:/caminho/para/seu/projeto"
       <Directory "C:/caminho/para/seu/projeto">
           Options Indexes FollowSymLinks Includes ExecCGI
           AllowOverride All
           Require all granted
       </Directory>
   </VirtualHost>
   ```

   > ⚠️ **Importante**: Altere o caminho `DocumentRoot` e `Directory` para a pasta do seu projeto.

### 📌 Passo 2: Configurar o arquivo hosts do Windows

1. **Localize o arquivo hosts:**

   ```
   C:\Windows\System32\drivers\etc\hosts
   ```

2. **Abra como administrador:**

   - Clique com o botão direito no **Bloco de Notas**
   - Selecione **"Executar como administrador"**
   - Abra o arquivo `hosts` (mude o filtro para "Todos os arquivos")

3. **Adicione a linha no final:**

   ```
   127.0.0.1   projetoPHP.local
   ```

   > ⚠️ **Dica**: Se você usar VS Code, abra ele como administrador para editar o arquivo mais facilmente.

### 📌 Passo 3: Reiniciar o Apache

1. Abra o **XAMPP Control Panel**
2. Pare o **Apache** (se estiver rodando)
3. Inicie o **Apache** novamente

### ✅ Passo 4: Testar a configuração

Acesse no seu navegador:

```
http://projetoPHP.local/
```

Se tudo estiver correto, seu projeto será exibido! 🎉

## 📂 Exemplos

Este repositório inclui arquivos de exemplo na pasta `exemplos/`:

- 📄 `httpd-vhosts.conf` - Exemplo de configuração do Apache (DESENVOLVIMENTO)
- 📄 `httpd-vhosts-seguro.conf` - Configurações seguras para PRODUÇÃO
- 📄 `hosts` - Exemplo de configuração do arquivo hosts
- 🔧 `scripts/` - Scripts de automação e validação

### 🔧 Personalizando para seu projeto

Para usar com seu próprio projeto, substitua:

- `projetoPHP.local` → `seuprojeto.local`
- `C:/caminho/para/seu/projeto` → `C:/caminho/real/do/seu/projeto`

## 🔒 Segurança e Configurações

### ⚠️ Configurações Inseguras (Desenvolvimento)

As configurações padrão incluem:

- `Options Indexes` - Permite listagem de diretórios
- `Options ExecCGI` - Permite execução de scripts CGI
- `AllowOverride All` - Permite sobrescrita de configurações

**🚨 NUNCA use estas configurações em produção!**

### 🔒 Configurações Seguras (Produção)

Use o arquivo `httpd-vhosts-seguro.conf` para ambiente de produção:

```apache
<VirtualHost *:80>
    ServerName projetoPHP.local
    DocumentRoot "C:/caminho/para/seu/projeto"
    <Directory "C:/caminho/para/seu/projeto">
        # 🔒 CONFIGURAÇÕES SEGURAS
        Options -Indexes -ExecCGI FollowSymLinks
        AllowOverride None
        Require all granted

        # 🛡️ Bloqueia arquivos sensíveis
        <FilesMatch "\.(htaccess|htpasswd|ini|log|sh|inc|bak)$">
            Require all denied
        </FilesMatch>
    </Directory>
</VirtualHost>
```

## ❓ Problemas Comuns e Troubleshooting

### 🚫 Erro: "This site can't be reached"

**Possíveis causas e soluções:**

1. **Apache não está rodando**

   - Verifique no XAMPP Control Panel
   - Reinicie o Apache

2. **Arquivo hosts não foi salvo corretamente**

   - Abra como administrador
   - Verifique se não tem extensão .txt
   - Teste com `ping projetoPHP.local`

3. **Cache DNS do navegador**

   - Limpe o cache do navegador
   - Use modo incógnito
   - Execute `ipconfig /flushdns` no CMD

4. **Porta 80 ocupada**
   - Verifique se outro serviço está usando a porta 80
   - Use `netstat -an | findstr :80` para verificar

### 🚫 Erro ao salvar o arquivo hosts

**Soluções:**

1. **Abra como administrador**

   - Clique com botão direito no editor
   - Selecione "Executar como administrador"

2. **Use editores alternativos**

   - VS Code como administrador
   - Notepad++ como administrador
   - PowerShell: `notepad C:\Windows\System32\drivers\etc\hosts`

3. **Verifique permissões**
   - Certifique-se de ter permissões de administrador
   - Desative temporariamente o antivírus

### 🚫 Página em branco ou erro 403

**Possíveis causas:**

1. **Caminho incorreto no DocumentRoot**

   - Verifique se o caminho existe
   - Use barras `/` ou `\` consistentemente
   - Evite espaços nos caminhos

2. **Arquivo index não encontrado**

   - Crie um arquivo `index.php` ou `index.html`
   - Verifique se o arquivo está na pasta correta

3. **Permissões de pasta**
   - Verifique se o Apache tem acesso à pasta
   - Teste com uma pasta dentro do `htdocs` primeiro

### 🚫 Erro 500 - Internal Server Error

**Possíveis causas:**

1. **Sintaxe incorreta no httpd-vhosts.conf**

   - Verifique se não há erros de sintaxe
   - Teste com configuração mínima primeiro

2. **Módulos do Apache não habilitados**

   - Verifique se o módulo `vhost_alias` está habilitado
   - Reinicie o Apache após mudanças

3. **Arquivo .htaccess com erro**
   - Renomeie temporariamente o .htaccess
   - Teste sem o arquivo

### 🔧 Troubleshooting Avançado

**Verificar configuração do Apache:**

```bash
# Teste a configuração
C:\xampp\apache\bin\httpd.exe -t

# Ver logs de erro
C:\xampp\apache\logs\error.log
```

**Verificar se o Virtual Host está ativo:**

```bash
# No CMD como administrador
netstat -an | findstr :80
```

**Limpar cache DNS:**

```bash
ipconfig /flushdns
ipconfig /registerdns
```

## 🚀 Alternativas Modernas

### 🐳 Docker (Recomendado)

Para desenvolvimento moderno, considere usar Docker:

```dockerfile
# Dockerfile
FROM php:8.1-apache
COPY . /var/www/html/
EXPOSE 80
```

```yaml
# docker-compose.yml
version: "3.8"
services:
  web:
    build: .
    ports:
      - "80:80"
    volumes:
      - .:/var/www/html
```

**Vantagens:**

- ✅ Isolamento completo
- ✅ Configuração reproduzível
- ✅ Fácil de compartilhar
- ✅ Sem conflitos de versão

### 🎯 Laravel Valet (Windows)

Para projetos Laravel:

```bash
# Instalar via Composer
composer global require cretueusebiu/valet-windows

# Configurar
valet install
valet park
```

**Vantagens:**

- ✅ Configuração automática
- ✅ SSL automático
- ✅ Múltiplos projetos
- ✅ Performance superior

### 🔧 WAMP Server

Alternativa ao XAMPP com interface gráfica:

- Interface mais amigável
- Configuração visual de Virtual Hosts
- Melhor gerenciamento de serviços

### ☁️ Servidores de Desenvolvimento

Para desenvolvimento moderno:

- **Laravel Sail**: Docker para Laravel
- **Lando**: Ferramenta de desenvolvimento local
- **DDEV**: Ambiente de desenvolvimento containerizado

## 📊 Considerações de Escalabilidade

### 🚀 Múltiplos Virtual Hosts

**Limitações do XAMPP:**
- ⚠️ Performance pode ser afetada com 50+ Virtual Hosts
- ⚠️ Arquivo `httpd-vhosts.conf` pode ficar muito grande
- ⚠️ Tempo de inicialização do Apache pode aumentar

**Recomendações:**
- ✅ Use scripts avançados para gerenciar múltiplos projetos
- ✅ Monitore logs do Apache regularmente
- ✅ Considere alternativas modernas para projetos complexos
- ✅ Faça backup regular das configurações

### 🔧 Otimizações para Produção

**Para ambientes com muitos Virtual Hosts:**
```apache
# Use configurações otimizadas
<VirtualHost *:80>
    ServerName projeto.local
    DocumentRoot "C:/caminho/projeto"
    <Directory "C:/caminho/projeto">
        # Configurações mínimas para performance
        Options -Indexes -ExecCGI
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
```

### 🐳 Alternativas para Escalabilidade

**Docker (Recomendado para múltiplos projetos):**
```yaml
# docker-compose.yml
version: "3.8"
services:
  projeto1:
    build: ./projeto1
    ports:
      - "8080:80"
  projeto2:
    build: ./projeto2
    ports:
      - "8081:80"
  projeto3:
    build: ./projeto3
    ports:
      - "8082:80"
```

**Vantagens do Docker:**
- ✅ Isolamento completo entre projetos
- ✅ Escalabilidade horizontal
- ✅ Configuração reproduzível
- ✅ Sem conflitos de versão

## 🤝 Contribuindo

Contribuições são sempre bem-vindas! Se você tem sugestões ou encontrou algum problema:

1. 🍴 Faça um **Fork** do projeto
2. 🌿 Crie uma **branch** para sua feature (`git checkout -b feature/AmazingFeature`)
3. 💾 **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. 📤 **Push** para a branch (`git push origin feature/AmazingFeature`)
5. 🔄 Abra um **Pull Request**

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

<div align="center">

**⭐ Se este tutorial te ajudou, considere dar uma estrela no repositório! ⭐**

Feito com 💙 por [Seu Nome](https://github.com/GersonResplandes)

</div>
