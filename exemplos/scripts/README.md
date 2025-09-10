# 🔧 Scripts de Automação

Esta pasta contém scripts para automatizar a criação e gerenciamento de Virtual Hosts no XAMPP.

## 📋 Scripts Disponíveis

### 🚀 `criar-virtualhost.bat`
Cria um novo Virtual Host automaticamente (versão básica).

**Uso:**
```bash
criar-virtualhost.bat nome-do-projeto "caminho-do-projeto"
```

**Exemplo:**
```bash
criar-virtualhost.bat meuprojeto "C:\Users\Usuario\Projetos\meuprojeto"
```

### 🚀 `criar-virtualhost-avancado.bat`
Cria um novo Virtual Host com validação robusta e rollback automático.

**Uso:**
```bash
criar-virtualhost-avancado.bat nome-do-projeto "caminho-do-projeto" [porta]
```

**Exemplo:**
```bash
criar-virtualhost-avancado.bat meuprojeto "C:\Users\Usuario\Projetos\meuprojeto" 8080
```

**Funcionalidades Avançadas:**
- ✅ Validação robusta de entrada
- ✅ Verificação de duplicatas
- ✅ Rollback automático em caso de erro
- ✅ Suporte a portas personalizadas
- ✅ Log de criação
- ✅ Timestamp compatível com diferentes localizações

### 🔍 `validar-configuracao.bat`
Valida a configuração atual de Virtual Hosts.

**Uso:**
```bash
validar-configuracao.bat
```

**Funcionalidades:**
- ✅ Verifica se o XAMPP está instalado
- ✅ Testa configuração do Apache
- ✅ Verifica se o Apache está rodando
- ✅ Analisa arquivo hosts
- ✅ Lista Virtual Hosts configurados
- ✅ Verifica permissões
- ✅ Mostra logs de erro

### 📋 `listar-virtualhosts.bat`
Lista todos os Virtual Hosts configurados com informações detalhadas.

**Uso:**
```bash
listar-virtualhosts.bat
```

**Funcionalidades:**
- ✅ Lista todos os Virtual Hosts
- ✅ Mostra caminhos e portas
- ✅ Verifica status dos diretórios
- ✅ Exibe URLs completas
- ✅ Verifica status do Apache
- ✅ Lista entradas do arquivo hosts

### 🗑️ `remover-virtualhost.bat`
Remove um Virtual Host existente.

**Uso:**
```bash
remover-virtualhost.bat nome-do-projeto
```

**Exemplo:**
```bash
remover-virtualhost.bat meuprojeto
```

**Funcionalidades:**
- ✅ Remove configuração do `httpd-vhosts.conf`
- ✅ Remove entrada do arquivo `hosts`
- ✅ Faz backup automático dos arquivos
- ✅ Valida configuração após remoção
- ✅ Limpa cache DNS

### 🔄 `rollback.bat`
Faz rollback para uma configuração anterior.

**Uso:**
```bash
rollback.bat [timestamp]
rollback.bat list
```

**Exemplos:**
```bash
# Listar backups disponíveis
rollback.bat list

# Fazer rollback para um timestamp específico
rollback.bat 20250109_143022
```

**Funcionalidades:**
- ✅ Lista backups disponíveis
- ✅ Restaura configuração anterior
- ✅ Valida configuração após rollback
- ✅ Cria backup da configuração atual
- ✅ Rollback automático em caso de erro

## ⚠️ Requisitos

- **Windows** com XAMPP instalado
- **Permissões de administrador** para editar arquivos do sistema
- **XAMPP** instalado em `C:\xampp\`

## 🚨 Avisos Importantes

1. **Execute como administrador**: Todos os scripts precisam de permissões elevadas
2. **Backup automático**: Os scripts fazem backup antes de modificar arquivos
3. **Validação**: Sempre validam a configuração antes de aplicar mudanças
4. **Desenvolvimento apenas**: Configurações são para desenvolvimento local
5. **Rollback disponível**: Use `rollback.bat` para reverter mudanças

## 🔧 Como Usar

1. **Abra o CMD como administrador**
2. **Navegue até a pasta dos scripts**
3. **Execute o script desejado**

**Exemplo completo:**
```bash
# Abrir CMD como administrador
# Navegar até a pasta
cd C:\caminho\para\exemplos\scripts

# Listar Virtual Hosts existentes
listar-virtualhosts.bat

# Criar Virtual Host avançado
criar-virtualhost-avancado.bat meuprojeto "C:\Users\Usuario\Projetos\meuprojeto" 8080

# Validar configuração
validar-configuracao.bat

# Remover Virtual Host (se necessário)
remover-virtualhost.bat meuprojeto

# Fazer rollback (se necessário)
rollback.bat list
rollback.bat 20250109_143022
```

## 🐛 Solução de Problemas

### Erro: "Acesso negado"
- Execute o CMD como administrador
- Verifique se o antivírus não está bloqueando

### Erro: "XAMPP não encontrado"
- Verifique se o XAMPP está instalado em `C:\xampp\`
- Reinstale o XAMPP se necessário

### Erro: "Configuração inválida"
- Verifique os logs do Apache
- Use o script de validação para diagnosticar
- Use o rollback para reverter mudanças

### Erro: "Nome do projeto inválido"
- Use apenas letras, números, hífens e underscores
- Evite caracteres especiais e espaços

### Erro: "Porta em uso"
- Verifique se a porta está sendo usada por outro serviço
- Use `netstat -an | findstr :porta` para verificar

## 📝 Logs e Backups

Os scripts criam backups automáticos com timestamp:
- `httpd-vhosts.conf.backup.YYYYMMDD_HHMMSS`
- `hosts.backup.YYYYMMDD_HHMMSS`

### Estrutura de Logs
- **Log de criação**: `vhost_creation.log` na pasta do projeto
- **Logs do Apache**: `C:\xampp\apache\logs\error.log`
- **Backups**: Pasta de configuração do XAMPP

## 🔄 Sistema de Rollback

O sistema de rollback permite reverter mudanças:
1. **Listar backups**: `rollback.bat list`
2. **Fazer rollback**: `rollback.bat timestamp`
3. **Validação automática**: Configuração é validada após rollback
4. **Backup da configuração atual**: Criado antes do rollback

## 🚀 Funcionalidades Avançadas

### Validação Robusta
- ✅ Formato de caminho
- ✅ Caracteres especiais
- ✅ Portas válidas
- ✅ Duplicatas
- ✅ Pré-requisitos

### Rollback Automático
- ✅ Em caso de erro de configuração
- ✅ Backup da configuração atual
- ✅ Validação após rollback
- ✅ Restauração automática

### Logging Completo
- ✅ Log de criação
- ✅ Timestamp de operações
- ✅ Status de validação
- ✅ Informações de rollback

## 🤝 Contribuindo

Para melhorar os scripts:
1. Teste em diferentes versões do Windows
2. Adicione validações adicionais
3. Melhore as mensagens de erro
4. Adicione suporte a outros sistemas operacionais
5. Implemente funcionalidades de monitoramento

## 📊 Considerações de Escalabilidade

### Múltiplos Virtual Hosts
- ✅ Scripts suportam múltiplos Virtual Hosts
- ✅ Validação de duplicatas
- ✅ Listagem organizada
- ⚠️ Performance pode ser afetada com 50+ Virtual Hosts

### Recomendações
- Use scripts avançados para projetos críticos
- Faça rollback regularmente
- Monitore logs do Apache
- Considere alternativas modernas (Docker) para projetos complexos