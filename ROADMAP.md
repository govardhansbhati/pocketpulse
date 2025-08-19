# 💳 PocketPulse: Project Roadmap  

This document outlines the complete development roadmap for **PocketPulse**, an **offline-first personal finance management app for iOS**.  
It covers the foundational work completed ✅, the features planned for the **1.0 release 🚀**, and the **long-term vision 🔮** for the project.  

---

## ✅ Version 0.9 (Completed)  

This milestone represents the **core foundation** of the application, including all features implemented to date.  

### 🏗 Core App Foundation  
- 📂 Set up the initial Xcode project and a **feature-oriented file structure**.  
- 🗂 Implemented the **SwiftData models** for `Account`, `Card`, and `Transaction`.  
- 🖥 Designed and built the **main tab bar container** (`TabV`) with **four distinct sections**.  
- 🎨 Created a **custom animated tab bar** with a dynamic arc and interactive buttons.  
- ➕ Developed a **custom expanding floating action button** for adding income and expenses.  
- ✨ Implemented the **animated splash screen** for the initial app launch.  

### 💼 Wallet Feature  
- 📊 Built the **WalletView** with segmented control to switch between accounts and cards.  
- 📝 Developed **Add/Edit Account** and **Add/Edit Card** sheets with **full CRUD functionality**.  
- 🧠 Implemented **smart form logic** (hiding irrelevant fields, auto-populating bank names).  
- 👆 Added **“Tap for Details, Swipe to Delete”** functionality.  
- 🔒 Implemented a **safety check** to prevent deleting a bank account if it has linked cards.  

### 💸 Transaction Management  
- 🏦 Developed the **AddExpenseView** and **AddIncomeView** with their `ViewModels`.  
- 🔄 Implemented a **unified "Pay From" picker** (supports bank accounts, cash, credit cards, debit cards).  
- 📉 Added logic to **update balances correctly** based on the payment source.  

---

## 🚀 Version 1.0 (In Progress)  

This milestone focuses on adding **advanced features** and **polish** for the **university submission 🎓** and **App Store release 📱**.  

### 🎯 Epic 1: Enhanced Home Screen Experience  
- 📊 **Interactive Balance View** → Tapping "Current Balance" shows a **breakdown pop-up** of balances across accounts.  
- 👀 **Dynamic "View All" Buttons** → Hidden if item count is below a threshold.  
- 🛠 **Full CRUD in Transaction List** → Edit & delete transactions with confirmation alerts.  

### 📈 Epic 2: Advanced Statistics & Filtering  
- ⏳ **Smart Time Filters** → "This Week" & "This Month" only enabled if relevant data exists.  
- 📅 **Intelligent Custom Date Picker** → Limited to actual transaction data range with smart `To/From` logic.  

### ⏰ Epic 3: Smart Bill Reminders & Notifications  
- 🔔 **Local Push Notifications** → Request notification permissions & allow users to set bill reminders.  

### 💳 Epic 4: Advanced Wallet Management  
- ↔️ **Drag-and-Drop Reordering** → Users can reorder accounts and cards in the Wallet tab.  

---

## 🔮 Future Scope (Post 1.0)  

Long-term vision to elevate PocketPulse into a **complete financial wellness platform**:  

- ☁️ **iCloud Sync** → Seamlessly sync data across iPhone, iPad, and Mac.  
- 👥 **User Authentication & Shared Wallets** → Secure data & enable family/shared budgets.  
- 🧠 **Advanced Analytics & Budgeting** → Monthly spending limits, predictive insights, smart categorization.  
- 📈 **Investment Tracking** → Track stocks, mutual funds, and assets → get **net worth overview**.  
- 🔗 **Open Banking Integration** → Connect with services like **Plaid** for auto-importing transactions.  

---

📌 **Status:**  
- Version **0.9 ✅ Completed**  
- Version **1.0 🚀 In Progress**  
- Future Scope **🔮 Planned**  
