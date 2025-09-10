# 🔧 Scripts de Automação

Esta pasta contém scripts para automatizar a criação e gerenciamento de Virtual Hosts no XAMPP.

## 📋 Scripts Disponíveis

### 🚀 `criar-virtualhost.bat`

Cria um novo Virtual Host automaticamente.

**Uso:**

```bash
criar-virtualhost.bat nome-do-projeto "caminho-do-projeto"
```

**Exemplo:**

```bash
criar-virtualhost.bat meuprojeto "C:\Users\Usuario\Projetos\meuprojeto"
```

**Funcionalidades:**

- ✅ Cria configuração no `httpd-vhosts.conf`
- ✅ Adiciona entrada no arquivo `hosts`
- ✅ Faz backup automático dos arquivos
- ✅ Valida configuração do Apache
- ✅ Limpa cache DNS

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

## ⚠️ Requisitos

- **Windows** com XAMPP instalado
- **Permissões de administrador** para editar arquivos do sistema
- **XAMPP** instalado em `C:\xampp\`

## 🚨 Avisos Importantes

1. **Execute como administrador**: Todos os scripts precisam de permissões elevadas
2. **Backup automático**: Os scripts fazem backup antes de modificar arquivos
3. **Validação**: Sempre validam a configuração antes de aplicar mudanças
4. **Desenvolvimento apenas**: Configurações são para desenvolvimento local

## 🔧 Como Usar

1. **Abra o CMD como administrador**
2. **Navegue até a pasta dos scripts**
3. **Execute o script desejado**

**Exemplo completo:**

```bash
# Abrir CMD como administrador
# Navegar até a pasta
cd C:\caminho\para\exemplos\scripts

# Criar Virtual Host
criar-virtualhost.bat meuprojeto "C:\Users\Usuario\Projetos\meuprojeto"

# Validar configuração
validar-configuracao.bat

# Remover Virtual Host (se necessário)
remover-virtualhost.bat meuprojeto
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

## 📝 Logs e Backups

Os scripts criam backups automáticos com timestamp:

- `httpd-vhosts.conf.backup.YYYYMMDD_HHMMSS`
- `hosts.backup.YYYYMMDD_HHMMSS`

## 🤝 Contribuindo

Para melhorar os scripts:

1. Teste em diferentes versões do Windows
2. Adicione validações adicionais
3. Melhore as mensagens de erro
4. Adicione suporte a outros sistemas operacionais
