# Stray Bookstore App

Welcome to **Stray Bookstore App**! 📚

A modern Flutter application for personal collection management, loans, and debt control. It allows you to register friends, books, magazines, boxes, and debts, with full CRUD operations for each module.

---

## 📝 Functional Requirements

1. **User Registration**
   - Full CRUD for users (create account, view).
   - Email and password validation.

2. **Friends Registration**
   - CRUD for friends who can borrow books or magazines.

3. **Magazine Registration**
   - CRUD for magazines, with the ability to associate them with boxes.

4. **Box Registration**
   - CRUD for boxes, used to store magazines.

5. **Debts Registration**
   - CRUD for debts, linking friends and borrowed items (books/magazines).

6. **Loans**
   - Register and manage item loans to friends.
   - Loan history.

7. **Authentication and Session**
   - Secure login, logout, and session persistence.

---

## 🛡️ Non-Functional Requirements

1. **Security**
   - Sensitive data protected with Firebase Authentication.
   - Secure CRUD, with proper permissions per user.

2. **Usability**
   - Intuitive, responsive, and user-friendly interface.
   - Visual feedback for all operations (success, error, loading).

3. **Performance**
   - Fast and efficient CRUD operations.
   - Quick initial loading.

4. **Compatibility**
   - Supports Android and iOS.
   - Adapts to different screen sizes.

5. **Maintainability**
   - Organized, modular, and easy-to-maintain code.
   - Uses Provider for state management.

6. **Scalability**
   - Structure ready for feature expansion, such as online catalog, return notifications, reports, and more.

---

## 🚀 How to Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/KlayRodrigs/stray_bookstore_app.git
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```

---

## 🛠️ Technologies Used
- Flutter
- Firebase Authentication
- Firestore
- Provider (State Management)

---

## 🧪 Tests & Coverage
This project includes unit tests for the main business logic and data modules, ensuring reliability and maintainability. We always maintain **80%+ code coverage**. Run `./test_coverage.sh` to check the current coverage and view the HTML report.

---

## 🤝 Contribution
Pull requests are welcome! For major changes, please open an issue to discuss what you would like to change.

## 📄 License
[MIT](LICENSE)
