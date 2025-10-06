#  Guia Passo a Passo - Configuração do Nginx Proxy Manager

##  Status da Verificação

-  **DuckDNS configurado**: `pedroszpak.duckdns.org` → `191.220.85.224`
-  **IP público verificado**: Coincide com DuckDNS
-  **n8n rodando**: `http://localhost:5678`
-  **Nginx Proxy Manager rodando**: `http://localhost:81`

---

##  PASSO 1: Acessar o Nginx Proxy Manager

1. Abra seu navegador
2. Acesse: **http://localhost:81**
3. Faça login com as credenciais padrão:
   - **Email**: `admin@example.com`
   - **Senha**: `changeme`

4.  **Na primeira vez, você DEVE mudar**:
   - Seu nome
   - Email (sugestão: `pedrohszpaka@gmail.com`)
   - Nova senha

---

##  PASSO 2: Criar o Proxy Host (SEM SSL primeiro)

### Por que sem SSL primeiro?
Para testar se tudo está funcionando antes de adicionar a complexidade do SSL.

1. No menu lateral, clique em **"Proxy Hosts"**
2. Clique no botão **"Add Proxy Host"**

###  Aba "Details"

Preencha exatamente assim:

```
Domain Names: pedroszpak.duckdns.org
Scheme: http
Forward Hostname / IP: n8n
Forward Port: 5678
```

**Marque estas opções:**
-  **Cache Assets**
-  **Block Common Exploits**
-  **Websockets Support**  **MUITO IMPORTANTE!**

**NÃO marque:**
-  Access List

###  Aba "SSL"

**Por enquanto, deixe em branco** (vamos configurar depois)

###  Aba "Advanced"

Cole este código:

```nginx
# Headers essenciais para n8n
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;

# Timeouts para operações longas
proxy_read_timeout 300;
proxy_connect_timeout 300;
proxy_send_timeout 300;

# Websockets - ESSENCIAL para n8n
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
```

3. Clique em **"Save"**

---

##  PASSO 3: Testar Localmente (Sem SSL)

### Teste 1: Acesso Direto ao n8n
```bash
curl -I http://localhost:5678
```
 Deve retornar: `HTTP/1.1 200 OK`

### Teste 2: Acesso via Proxy (Porta 80)
```bash
curl -I http://localhost:80
```
Deve retornar: `HTTP/1.1 200 OK`

### Teste 3: Navegador Local
Abra no navegador: **http://localhost**

Deve carregar a interface do n8n

---

##  PASSO 4: Configurar Port Forwarding no Roteador

Você precisa redirecionar as portas do roteador para seu computador.

### Descobrir IP Local do Mac:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

Anote o IP que começa com `192.168.x.x` ou `10.0.x.x`

### No Roteador:

1. Acesse o painel do seu roteador (geralmente: `192.168.1.1` ou `192.168.0.1`)
2. Procure por:
   - "Port Forwarding"
   - "Virtual Server"
   - "NAT Forwarding"
   - "Redirecionamento de Portas"

3. Adicione duas regras:

**Regra 1 - HTTP:**
```
Nome: n8n-http
Porta Externa: 80
IP Interno: [SEU IP LOCAL DO MAC]
Porta Interna: 80
Protocolo: TCP
```

**Regra 2 - HTTPS:**
```
Nome: n8n-https
Porta Externa: 443
IP Interno: [SEU IP LOCAL DO MAC]
Porta Interna: 443
Protocolo: TCP
```

4. Salve e reinicie o roteador se necessário

### Verificar se funcionou:

De outro dispositivo (celular com dados móveis desligado WiFi):
```
http://pedroszpak.duckdns.org
```

---

##  PASSO 5: Adicionar SSL (Let's Encrypt)

 **IMPORTANTE**: Só faça isso DEPOIS de verificar que o PASSO 4 está funcionando!

1. No Nginx Proxy Manager, vá em **"Proxy Hosts"**
2. Clique nos **3 pontinhos** ao lado do seu host
3. Clique em **"Edit"**
4. Vá na aba **"SSL"**

### Configure assim:

```
SSL Certificate: [Selecione "Request a new SSL Certificate"]
```

**Marque estas opções:**
-  **Force SSL**
-  **HTTP/2 Support**
-  **HSTS Enabled**
-  **I Agree to the Let's Encrypt Terms of Service**

```
Email Address for Let's Encrypt: pedrohszpaka@gmail.com
```

5. Clique em **"Save"**

### O que vai acontecer:

O Nginx vai:
1. Contactar o Let's Encrypt
2. Let's Encrypt vai tentar acessar seu domínio pela porta 80
3. Se conseguir, vai emitir o certificado SSL
4. Seu site ficará com HTTPS! 

---

##  PASSO 6: Atualizar Configuração do n8n

Depois que o SSL estiver funcionando, precisamos avisar o n8n que está usando HTTPS:

Isso já está configurado no seu `.env`:
```env
N8N_HOST=pedroszpak.duckdns.org
N8N_PROTOCOL=https
N8N_SECURE_COOKIE=true
WEBHOOK_URL=https://pedroszpak.duckdns.org/
```

Reinicie o n8n:
```bash
docker compose restart n8n
```

---

##  Resultado Final

Você poderá acessar seu n8n de qualquer lugar:

-  **Localmente**: http://localhost:5678 (direto)
-  **Localmente via proxy**: http://localhost
-  **Externamente**: https://pedroszpak.duckdns.org

---

##  Troubleshooting

### Erro: "502 Bad Gateway"
**Problema**: Nginx não consegue conectar ao n8n

**Solução**:
```bash
# Verificar se n8n está rodando
docker compose ps

# Ver logs
docker compose logs n8n --tail 50

# Reiniciar
docker compose restart n8n
```

### Erro: SSL não funciona - "ERR_SSL_PROTOCOL_ERROR"
**Problema**: Let's Encrypt não conseguiu validar

**Causas possíveis**:
1.  Porta 80 não está aberta no roteador
2.  DuckDNS não está atualizado
3.  Firewall bloqueando

**Solução**:
```bash
# Teste se a porta 80 está acessível externamente
# Use um site como: https://www.yougetsignal.com/tools/open-ports/
# Digite seu IP: 191.220.85.224 e porta: 80
```

### Erro: "This site can't be reached"
**Problema**: Portas não estão redirecionadas

**Solução**:
1. Confirme as regras de port forwarding
2. Teste com celular (dados móveis, não WiFi)
3. Verifique firewall do macOS:
   ```bash
   sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
   ```

---

##  Comandos Úteis

```bash
# Ver status de tudo
docker compose ps

# Logs do Nginx
docker compose logs app -f

# Logs do n8n
docker compose logs n8n -f

# Reiniciar tudo
docker compose restart

# Parar tudo
docker compose down

# Subir tudo novamente
docker compose up -d

# Ver qual porta está usando o quê
sudo lsof -i :80
sudo lsof -i :443
sudo lsof -i :5678
```

---

##  Checklist de Progresso

### Básico
- [x] DuckDNS configurado
- [x] n8n rodando
- [x] Nginx Proxy Manager rodando
- [ ] Proxy Host criado no Nginx
- [ ] Acesso local funcionando (http://localhost)

### Avançado (Acesso Externo)
- [ ] Port forwarding configurado (80 e 443)
- [ ] Acesso externo via HTTP funcionando
- [ ] SSL configurado
- [ ] Acesso externo via HTTPS funcionando

---

##  Próximos Passos

Comece pelo **PASSO 2** - Configurar o Proxy Host sem SSL

Quando terminar cada passo, me avise e eu te ajudo com o próximo! 
