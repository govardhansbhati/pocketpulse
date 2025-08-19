PocketPulse: Project Roadmap
This document outlines the complete development roadmap for PocketPulse, an offline-first personal finance management app for iOS. It covers the foundational work completed, the features planned for the 1.0 release, and the long-term vision for the project.

✅ Version 0.9 (Completed)

This milestone represents the core foundation of the application, including all features implemented to date.

Core App Foundation:

Set up the initial Xcode project and a feature-oriented file structure.

Implemented the core SwiftData models for Account, Card, and Transaction.

Designed and built the main tab bar container (TabV) with four distinct sections.

Created a custom animated tab bar with a dynamic arc and interactive buttons.

Developed a custom expanding floating action button for adding income and expenses.

Implemented the animated splash screen for the initial app launch.

Wallet Feature:

Built the main WalletView with a segmented control to switch between accounts and cards.

Developed the "Add/Edit Account" and "Add/Edit Card" sheets with full CRUD functionality.

Implemented smart form logic for both accounts and cards (e.g., hiding irrelevant fields, auto-populating bank names).

Added "Tap for Details, Swipe to Delete" functionality.

Implemented a safety check to prevent the deletion of a bank account if it has cards linked to it.

Transaction Management:

Developed the AddExpenseView and AddIncomeView with their ViewModels.

Implemented a unified "Pay From" picker that includes all payment sources: bank accounts, cash, credit cards, and debit cards.

Added logic to correctly update balances based on the payment source.

🚀 Version 1.0 (In Progress)

This milestone focuses on adding advanced features and polish to prepare the app for a university submission and its initial App Store release.

Epic 1: Enhanced Home Screen Experience

Interactive Balance View: Tapping the "Current Balance" will present a pop-up showing a breakdown of balances from all individual accounts.

Dynamic "View All" Buttons: The "View All" buttons for cards and transactions will be hidden if the list count is below a certain threshold.

Full CRUD in Transaction List: The "View All" transactions screen will be a fully functional list where users can tap to edit and swipe to delete with a confirmation alert.

Epic 2: Advanced Statistics & Filtering

Smart Time Filters: The "This Week" and "This Month" filters will only be enabled if transaction data exists within those timeframes.

Intelligent Custom Date Picker: The custom date picker will be restricted to only the range where transaction data is available, with smart "To/From" date logic.

Epic 3: Smart Bill Reminders & Notifications

Local Push Notifications: The app will request notification permissions and allow users to set reminders for their bills, which will trigger local push notifications.

Epic 4: Advanced Wallet Management

Drag-and-Drop Reordering: Users will be able to drag and drop their accounts and cards in the Wallet tab to set a custom display order.

🔮 Future Scope (Post 1.0)

This section outlines the long-term vision for PocketPulse, focusing on features that would elevate it to a complete financial wellness platform.

☁️ iCloud Sync: Integrate iCloud to allow users to seamlessly sync their data across all their Apple devices (iPhone, iPad, Mac).

👥 User Authentication & Shared Wallets: Add a user authentication system to secure data and enable collaborative features like shared family budgets.

🧠 Advanced Analytics & Budgeting: Introduce a dedicated budgeting feature where users can set monthly spending limits for categories and receive predictive insights based on their habits.

📈 Investment Tracking: Add a new section for users to track their investments in stocks, mutual funds, and other assets to get a full picture of their net worth.

🔗 Open Banking Integration: Explore integrating with a service like Plaid to allow users to securely link their real bank accounts for automatic transaction importing.
