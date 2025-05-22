# Stray Bookstore App

Bem-vindo ao **Stray Bookstore App**! 📚

Um aplicativo Flutter moderno para gestão pessoal de acervo, empréstimos e controle de dívidas, permitindo o cadastro de amigos, livros, revistas, caixas e dívidas, com operações completas de CRUD para cada módulo.

---

## 📝 Requisitos Funcionais

1. **Cadastro de Usuário**
   - CRUD completo para usuários (criar conta, visualizar).
   - Validação de e-mail e senha.

2. **Cadastro de Amigos**
   - CRUD para amigos que poderão pegar livros ou revistas emprestados.

3. **Cadastro de Revistas**
   - CRUD para revistas, podendo associá-las a caixas.

4. **Cadastro de Caixas**
   - CRUD para caixas, utilizadas para armazenar revistas.

5. **Cadastro de Dívidas**
   - CRUD para dívidas, vinculando amigos e itens emprestados (livros/revistas).

6. **Empréstimos**
   - Registrar e gerenciar empréstimo de itens para amigos.
   - Histórico de empréstimos.

7. **Autenticação e Sessão**
   - Login seguro, logout e persistência de sessão.

---

## 🛡️ Requisitos Não Funcionais

1. **Segurança**
   - Dados sensíveis protegidos com Firebase Authentication.
   - CRUD seguro, com permissões adequadas por usuário.

2. **Usabilidade**
   - Interface intuitiva, responsiva e amigável.
   - Feedback visual para todas as operações (sucesso, erro, carregando).

3. **Performance**
   - Operações CRUD rápidas e eficientes.
   - Carregamento inicial ágil.

4. **Compatibilidade**
   - Suporte a Android e iOS.
   - Adaptação a diferentes tamanhos de tela.

5. **Manutenibilidade**
   - Código organizado, modular e fácil de manter.
   - Uso do Provider para gerenciamento de estado.

6. **Escalabilidade**
   - Estrutura pronta para expansão de funcionalidades, como catálogo online, notificações de devolução, relatórios, entre outros.

---

## 🚀 Como Executar

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/KlayRodrigs/stray_bookstore_app.git
   ```
2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```
3. **Execute o app:**
   ```bash
   flutter run
   ```

---

## 🛠️ Tecnologias Utilizadas
- Flutter
- Firebase Authentication
- Firestore
- Provider (Gerenciamento de Estado)

---

## 🤝 Contribuição
Pull requests são bem-vindos! Para grandes mudanças, abra uma issue para discutirmos o que deseja alterar.

## 📄 Licença
[MIT](LICENSE)
