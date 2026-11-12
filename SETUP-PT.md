# Guia de instalação (uma vez só, ~20 min)

## 1. Criar o banco de dados online gratuito (Supabase)
1. Crie uma conta em https://supabase.com e clique em **New project** (região: South America / São Paulo). Anote a senha do banco.
2. No menu, abra **SQL Editor → New query**, cole todo o conteúdo do arquivo `setup.sql` e clique em **Run**.
3. Vá em **Project Settings → API** e copie o **Project URL** e a chave **anon public**.
4. Em **Authentication → Providers → Email**, desative **Confirm email** (o acesso já é liberado manualmente pelo administrador; isso evita depender de e-mails de confirmação).
5. (Depois do passo 6) Em **Authentication → URL Configuration**, coloque o endereço do GitHub Pages em **Site URL** (usado nos e-mails de redefinição de senha).

> **Já criou o banco antes?** Cole e rode o `setup.sql` novamente: ele só acrescenta as colunas novas (campos de empréstimo) e não apaga dados.

## 2. Configurar o app
Abra `config.js`, cole o Project URL e a chave anon entre as aspas e salve. (Opcional: chave do Google Maps em `mapsKey`.)

## 3. Publicar no GitHub
1. Suba **todos** os arquivos desta pasta para um repositório (mantenha a pasta `.github`).
2. **Settings → Pages → Source: GitHub Actions**. Em **Actions → Publish web app → Run workflow**.
3. O endereço (https://SEU-USUARIO.github.io/NOME-DO-REPOSITORIO/) é a versão para celular e navegador.
4. Instaladores de PC: **Actions → Build installers → Run workflow** e baixe o `.exe`, `.dmg`, `.AppImage` ou `.deb`.

## 4. Primeiro acesso
- A **primeira conta criada vira administradora**. Crie-a você mesmo (Create account).
- Os demais criam a própria conta e ficam **pending**; você libera em **Settings → Team and roles** (viewer, editor ou admin).
- Para remover uma pessoa: apague o usuário em Supabase → Authentication → Users.

## 5. Celular e leitura de QR Code
Abra o endereço do GitHub Pages no celular e use **Adicionar à tela inicial** (Android: menu ⋮; iPhone: Compartilhar). Toque em **Scan QR**, permita a câmera e aponte para a etiqueta. No computador, a webcam funciona do mesmo modo.

## Observações
- Projetos gratuitos do Supabase são pausados após cerca de 7 dias sem uso (basta reativar no painel) e têm 500 MB de banco.
- Faça backup periódico: **Export CSV** / **Export Darwin Core** na aba Specimens.

## Instalação por plataforma
| Plataforma | Como obter | Como instalar |
|---|---|---|
| **Windows** | `CHTC-…-win-x64.exe` (Actions → *Build installers*) | Abra o `.exe`. Se aparecer "SmartScreen": *Mais informações → Executar assim mesmo*. |
| **macOS** (Intel e Apple Silicon) | `CHTC-…-mac-x64.dmg` ou `…-arm64.dmg` | Arraste para Aplicativos. Na 1ª vez: clique com o botão direito → *Abrir*. |
| **Linux** | `…linux-x64.AppImage` ou `.deb` | AppImage: `chmod +x arquivo.AppImage` e execute. Deb: `sudo apt install ./arquivo.deb`. |
| **Android** | Endereço do GitHub Pages | Chrome → menu ⋮ → *Instalar app* / *Adicionar à tela inicial*. (Opcional: APK em Actions → *Build Android APK*; instalar exige permitir "fontes desconhecidas".) |
| **iPhone / iPad** | Endereço do GitHub Pages no **Safari** | Compartilhar → *Adicionar à Tela de Início*. |

Para publicar uma versão com links de download na página *Releases* do GitHub, crie uma tag, por exemplo `v1.0.0` (Releases → *Draft a new release* → tag `v1.0.0` → Publish). Os instaladores são anexados automaticamente.

**Sobre iPhone:** apps nativos do iOS exigem conta paga da Apple (US$ 99/ano) e a App Store. A versão instalada pela tela inicial funciona igual (login, banco online, câmera para QR Code), mas não aparece na App Store.
