// swiftlint:disable line_length
//
//  AppStrings.swift
//  PocketPulse
//
//  Created by govardhan singh on 01/01/26.
//

import Foundation

struct AppStrings {
    
    struct Common {
        static var viewAll: String { NSLocalizedString("common_view_all", comment: "View All button") }
        static var accounts: String { NSLocalizedString("common_accounts", comment: "Accounts header") }
        static var done: String { NSLocalizedString("common_done", comment: "Done action") }
        static var cancel: String { NSLocalizedString("common_cancel", comment: "Cancel action") }
        static var save: String { NSLocalizedString("common_save", comment: "Save action") }
        static var error: String { NSLocalizedString("common_error", comment: "Error title") }
        static var ok: String { NSLocalizedString("common_ok", comment: "OK action") }
        static var select: String { NSLocalizedString("common_select", comment: "Select action") }
        static var delete: String { NSLocalizedString("common_delete", comment: "Delete action") }
        static var selectPlaceholder: String { NSLocalizedString("common_select_placeholder", comment: "Select placeholder") }
    }
    
    struct Home {
        static var currentBalance: String { NSLocalizedString("home_current_balance", comment: "Current Balance section title") }
        static var incomeTitle: String { NSLocalizedString("home_income_title", comment: "Income label") }
        static var expensesTitle: String { NSLocalizedString("home_expenses_title", comment: "Expenses label") }
        static var yourCards: String { NSLocalizedString("home_your_cards", comment: "Your Cards section title") }
        static var noCardsTitle: String { NSLocalizedString("home_no_cards_title", comment: "No cards placeholder title") }
        static var noCardsSubtitle: String { NSLocalizedString("home_no_cards_subtitle", comment: "No cards placeholder subtitle") }
        static var addFirstCard: String { NSLocalizedString("home_add_first_card", comment: "Add first card button") }
        static var recentTransactions: String { NSLocalizedString("home_recent_transactions", comment: "Recent transactions section title") }
        static var noTransactionsTitle: String { NSLocalizedString("home_no_transactions_title", comment: "No transactions placeholder title") }
        static var noTransactionsSubtitle: String { NSLocalizedString("home_no_transactions_subtitle", comment: "No transactions placeholder subtitle") }
        static var welcomeMessage: String { NSLocalizedString("home_welcome_message", comment: "Default welcome message") }
        
        static var quickActions: String { NSLocalizedString("home_quick_actions", comment: "Quick Actions title") }
        static var actionAddExpense: String { NSLocalizedString("home_action_add_expense", comment: "Add Expense action") }
        static var actionAddIncome: String { NSLocalizedString("home_action_add_income", comment: "Add Income action") }
        static var actionSendMoney: String { NSLocalizedString("home_action_send_money", comment: "Send Money action") }
        static var actionMore: String { NSLocalizedString("home_action_more", comment: "More action") }
        
        static var budgetTitle: String { NSLocalizedString("home_budget_title", comment: "Budget title") }
        static var budgetRemaining: String { NSLocalizedString("home_budget_remaining", comment: "Budget remaining") }
        
        // swiftlint:disable:next nesting
        struct Breakdown {
            static var title: String { NSLocalizedString("breakdown_title", comment: "Balance Breakdown title") }
            static var totalNetWorth: String { NSLocalizedString("breakdown_net_worth", comment: "Total Net Worth label") }
            static var totalBalance: String { NSLocalizedString("breakdown_total_balance", comment: "Total Balance label") }
        }
    }
    
    struct Transaction {
        static var listTitle: String { NSLocalizedString("transaction_list_title", comment: "Title for transaction list view") }
        
        // swiftlint:disable:next nesting
        struct Add {
            static var expenseTitle: String { NSLocalizedString("transaction_add_expense_title", comment: "Title for add expense view") }
            static var incomeTitle: String { NSLocalizedString("transaction_add_income_title", comment: "Title for add income view") }
            static var expenseDetails: String { NSLocalizedString("transaction_expense_details", comment: "Header for expense details section") }
            static var incomeDetails: String { NSLocalizedString("transaction_income_details", comment: "Header for income details section") }
            static var titlePlaceholderExpense: String { NSLocalizedString("transaction_title_placeholder_expense", comment: "Placeholder for expense title") }
            static var titlePlaceholderIncome: String { NSLocalizedString("transaction_title_placeholder_income", comment: "Placeholder for income title") }
            static var amountPlaceholder: String { NSLocalizedString("transaction_amount_placeholder", comment: "Placeholder for amount") }
            static var dateLabel: String { NSLocalizedString("transaction_date_label", comment: "Label for date picker") }
            static var categorizationHeader: String { NSLocalizedString("transaction_categorization_header", comment: "Header for categorization section") }
            static var categoryLabel: String { NSLocalizedString("transaction_category_label", comment: "Label for category picker") }
            static var payFromLabel: String { NSLocalizedString("transaction_pay_from_label", comment: "Label for pay from picker") }
            static var depositToLabel: String { NSLocalizedString("transaction_deposit_to_label", comment: "Label for deposit to picker") }
            static var selectSourcePlaceholder: String { NSLocalizedString("transaction_select_source_placeholder", comment: "Placeholder for source selection") }
            static var selectAccountPlaceholder: String { NSLocalizedString("transaction_select_account_placeholder", comment: "Placeholder for account selection") }
        }
    }
    
    struct Wallet {
        static var title: String { NSLocalizedString("wallet_title", comment: "Main wallet view title") }
        static var tabCards: String { NSLocalizedString("wallet_tab_cards", comment: "Cards tab title") }
        static var tabAccounts: String { NSLocalizedString("wallet_tab_accounts", comment: "Accounts tab title") }
        static var chooseTab: String { NSLocalizedString("wallet_choose_tab", comment: "Picker label for choosing tab") }
        static var yourCardsTitle: String { NSLocalizedString("wallet_your_cards_title", comment: "Your Cards section title") }
        static var addCardButton: String { NSLocalizedString("wallet_add_card_button", comment: "Add Card button") }
        static var noCardsTitle: String { NSLocalizedString("wallet_no_cards_title", comment: "No cards placeholder title") }
        static var noCardsSubtitle: String { NSLocalizedString("wallet_no_cards_subtitle", comment: "No cards placeholder subtitle") }
        static var addFirstCard: String { NSLocalizedString("wallet_add_first_card", comment: "Add first card button") }
        static var yourAccountsTitle: String { NSLocalizedString("wallet_your_accounts_title", comment: "Your Accounts section title") }
        static var addAccountButton: String { NSLocalizedString("wallet_add_account_button", comment: "Add Account button") }
        static var noAccountsTitle: String { NSLocalizedString("wallet_no_accounts_title", comment: "No accounts placeholder title") }
        static var noAccountsSubtitle: String { NSLocalizedString("wallet_no_accounts_subtitle", comment: "No accounts placeholder subtitle") }
        static var addFirstAccount: String { NSLocalizedString("wallet_add_first_account", comment: "Add first account button") }
        
        static var placeholderCardHolder: String { NSLocalizedString("wallet_card_holder_title", value: "CARD HOLDER", comment: "Card placeholder holder title") }
        static var placeholderExpires: String { NSLocalizedString("wallet_card_expires_title", value: "EXPIRES", comment: "Card placeholder expires title") }

        static var cardDetailsTitle: String { NSLocalizedString("wallet_card_details_title", comment: "Card Details Screen Title") }
        static var cardHolderLabel: String { NSLocalizedString("wallet_card_holder_label", comment: "Label for card holder") }
        static var bankLabel: String { NSLocalizedString("wallet_bank_label", comment: "Label for bank") }
        static var creditLimitLabel: String { NSLocalizedString("wallet_credit_limit_label", comment: "Label for credit limit") }
        static var outstandingLabel: String { NSLocalizedString("wallet_outstanding_label", comment: "Label for outstanding amount") }
        static var editAction: String { NSLocalizedString("wallet_edit_action", comment: "Edit action button") }
        
        static var detailsSection: String { NSLocalizedString("wallet_details_section", comment: "Details section header") }
        static var balanceLabel: String { NSLocalizedString("wallet_balance_label", comment: "Label for balance") }
        static var institutionLabel: String { NSLocalizedString("wallet_institution_label", comment: "Label for institution") }
        static var accountNumberLabel: String { NSLocalizedString("wallet_account_number_label", comment: "Label for account number") }

        static var creditUtilizationTitle: String { NSLocalizedString("wallet_credit_utilization_title", value: "Credit Utilization", comment: "Credit Utilization Title") }
        static var creditUsedPercentFormat: String { NSLocalizedString("wallet_credit_used_percent_format", value: "%.0f%% Used", comment: "Credit Used Percent Format") }
        static var creditLimitFormat: String { NSLocalizedString("wallet_credit_limit_format", value: "Limit: %@", comment: "Credit Limit Format") }
        static var creditUsedFormat: String { NSLocalizedString("wallet_credit_used_format", value: "Used: %@", comment: "Credit Used Format") }
        static var netWorthTitle: String { NSLocalizedString("wallet_net_worth_title", value: "Net Worth", comment: "Net Worth Title") }
        static var currencyCode: String { NSLocalizedString("wallet_currency_code", value: "INR", comment: "Currency Code") }
        
        static var creditUtilization: String { NSLocalizedString("wallet_credit_utilization", comment: "Credit Utilization") }
        static var availableCredit: String { NSLocalizedString("wallet_available_credit", comment: "Available Credit") }
        static var totalLimit: String { NSLocalizedString("wallet_total_limit", comment: "Total Limit") }
        static var billingDateLabel: String { NSLocalizedString("wallet_billing_date_label", comment: "Billing Date label") }
        static var paymentDueLabel: String { NSLocalizedString("wallet_payment_due_label", comment: "Payment Due label") }
        static var linkedAccountLabel: String { NSLocalizedString("wallet_linked_account_label", comment: "Linked Account label") }
        static var expiryLabel: String { NSLocalizedString("wallet_expiry_label", comment: "Expiry label") }
        static func dayPrefix(_ day: Int) -> String { String(format: NSLocalizedString("wallet_day_prefix", comment: "Day prefix"), day) }
        
        static var notesLabel: String { NSLocalizedString("wallet_notes_label", comment: "Notes label") }
        static var ifscLabel: String { NSLocalizedString("wallet_ifsc_label", comment: "IFSC Code label") }
        static var openingDateLabel: String { NSLocalizedString("wallet_opening_date_label", comment: "Opening Date label") }
        static var statusLabel: String { NSLocalizedString("wallet_status_label", comment: "Status label") }
        
        // swiftlint:disable:next nesting
        struct Add {
            // Add Card
            static var cardType: String { NSLocalizedString("wallet_add_card_type", comment: "Add Card Sheet Type Label") }
            static var cardDetailsHeader: String { NSLocalizedString("wallet_add_card_details_header", comment: "Add Card Sheet Details Header") }
            static var cardHolderPlaceholder: String { NSLocalizedString("wallet_add_card_holder_placeholder", comment: "Card Holder placeholder") }
            static var cardNumberPlaceholder: String { NSLocalizedString("wallet_add_card_number_placeholder", comment: "Card Number placeholder") }
            static var expiryLabel: String { NSLocalizedString("wallet_add_card_expiry_label", comment: "Expiry date label") }
            static var bankNamePlaceholder: String { NSLocalizedString("wallet_add_card_bank_name_placeholder", comment: "Bank Name placeholder") }
            static var providerLabel: String { NSLocalizedString("wallet_add_card_provider_label", comment: "Provider label") }
            static var linkAccountHeader: String { NSLocalizedString("wallet_add_card_link_account_header", comment: "Link to bank account header") }
            static var accountLabel: String { NSLocalizedString("wallet_add_card_account_label", comment: "Account Picker Label") }
            static var selectAccountPlaceholder: String { NSLocalizedString("wallet_add_card_select_account_placeholder", comment: "Select Account Placeholder") }
            static var creditDetailsHeader: String { NSLocalizedString("wallet_add_card_credit_details_header", comment: "Credit Details Header") }
            static var creditLimitPlaceholder: String { NSLocalizedString("wallet_add_card_credit_limit_placeholder", comment: "Credit Limit Placeholder") }
            static var billingDatePlaceholder: String { NSLocalizedString("wallet_add_card_billing_date_placeholder", comment: "Billing Date Placeholder") }
            static var dueDatePlaceholder: String { NSLocalizedString("wallet_add_card_due_date_placeholder", comment: "Due Date Placeholder") }
            static var designHeader: String { NSLocalizedString("wallet_add_card_design_header", comment: "Card Design Header") }
            static var designLabel: String { NSLocalizedString("wallet_add_card_design_label", comment: "Design Label") }
            static var editCardTitle: String { NSLocalizedString("wallet_add_card_edit_title", comment: "Edit Card Title") }
            static var addNewCardTitle: String { NSLocalizedString("wallet_add_card_new_title", comment: "Add New Card Title") }
            
            // Add Account
            static var accountTypeLabel: String { NSLocalizedString("wallet_add_account_type_label", comment: "Account Type Label") }
            static var accountDetailsHeader: String { NSLocalizedString("wallet_add_account_details_header", comment: "Account Details Header") }
            static var accountNicknamePlaceholder: String { NSLocalizedString("wallet_add_account_nickname_placeholder", comment: "Account Nickname Placeholder") }
            static var institutionPlaceholder: String { NSLocalizedString("wallet_add_account_institution_placeholder", comment: "Institution Placeholder") }
            static var initialBalancePlaceholder: String { NSLocalizedString("wallet_add_account_initial_balance_placeholder", comment: "Initial Balance Placeholder") }
            static var bankIdentifiersHeader: String { NSLocalizedString("wallet_add_account_identifiers_header", comment: "Bank Identifiers Header") }
            static var accountNumberPlaceholder: String { NSLocalizedString("wallet_add_account_number_placeholder", comment: "Account Number Placeholder") }
            static var ifscPlaceholder: String { NSLocalizedString("wallet_add_account_ifsc_placeholder", comment: "IFSC Code Placeholder") }
            static var otherDetailsHeader: String { NSLocalizedString("wallet_add_account_other_header", comment: "Other Details Header") }
            static var openingDateLabel: String { NSLocalizedString("wallet_add_account_opening_date_label", comment: "Opening Date Label") }
            static var statusLabel: String { NSLocalizedString("wallet_add_account_status_label", comment: "Status Label") }
            static var notesPlaceholder: String { NSLocalizedString("wallet_add_account_notes_placeholder", comment: "Notes Placeholder") }
            static var editAccountTitle: String { NSLocalizedString("wallet_add_account_edit_title", comment: "Edit Account Title") }
            static var addNewAccountTitle: String { NSLocalizedString("wallet_add_account_new_title", comment: "Add New Account Title") }
        }
    }
    
    struct Profile {
        static var tapToEdit: String { NSLocalizedString("profile_tap_to_edit", comment: "Tap to edit profile hint") }
        static var appSettingsHeader: String { NSLocalizedString("profile_app_settings_header", comment: "App Settings Header") }
        static var menuDailyReminder: String { NSLocalizedString("profile_menu_daily_reminder", comment: "Daily Reminder Menu Item") }
        static var menuSecurity: String { NSLocalizedString("profile_menu_security", comment: "Security Menu Item") }
        static var menuDataManagement: String { NSLocalizedString("profile_menu_data_management", comment: "Data Management Menu Item") }
        
        static var informationHeader: String { NSLocalizedString("profile_information_header", comment: "Information Header") }
        static var menuAboutDeveloper: String { NSLocalizedString("profile_menu_about_developer", comment: "About Developer Menu Item") }
        static var menuRateApp: String { NSLocalizedString("profile_menu_rate_app", comment: "Rate App Menu Item") }
        
        static var aboutMeText: String { NSLocalizedString("profile_about_me_text", comment: "About Me Description") }
        static var viewGithub: String { NSLocalizedString("profile_view_github", comment: "View on GitHub Link") }
        static var connectLinkedIn: String { NSLocalizedString("profile_connect_linkedin", comment: "Connect on LinkedIn Link") }
        static var aboutMeTitle: String { NSLocalizedString("profile_about_me_title", comment: "About Me Title") }
        
        static var personalInfoHeader: String { NSLocalizedString("profile_personal_info_header", comment: "Personal Information Header") }
        static var namePlaceholder: String { NSLocalizedString("profile_name_placeholder", comment: "Name Placeholder") }
        static var editProfileTitle: String { NSLocalizedString("profile_edit_title", comment: "Edit Profile Title") }
        
        // swiftlint:disable:next nesting
        struct DataManagement {
            static var cloudSyncHeader: String { NSLocalizedString("profile_dm_cloud_sync_header", comment: "Cloud Sync Header") }
            static var cloudSyncFooter: String { NSLocalizedString("profile_dm_cloud_sync_footer", comment: "Cloud Sync Footer") }
            static var enableSync: String { NSLocalizedString("profile_dm_enable_sync", comment: "Enable Sync Toggle") }
            static var exportHeader: String { NSLocalizedString("profile_dm_export_header", comment: "Export Data Header") }
            static var exportCSV: String { NSLocalizedString("profile_dm_export_csv", comment: "Export CSV Button") }
            static var dangerZone: String { NSLocalizedString("profile_dm_danger_zone", comment: "Danger Zone Header") }
            static var resetData: String { NSLocalizedString("profile_dm_reset_data", comment: "Reset Data Button") }
            static var resetAlertTitle: String { NSLocalizedString("profile_dm_reset_alert_title", comment: "Reset Alert Title") }
            static var resetAlertMessage: String { NSLocalizedString("profile_dm_reset_alert_message", comment: "Reset Alert Message") }
            static var title: String { NSLocalizedString("profile_dm_title", comment: "Data Management Title") }
        }
        
        // swiftlint:disable:next nesting
        struct Security {
            static var appLockHeader: String { NSLocalizedString("profile_sec_app_lock_header", comment: "App Lock Header") }
            static var appLockFooter: String { NSLocalizedString("profile_sec_app_lock_footer", comment: "App Lock Footer") }
            static var enablePasscode: String { NSLocalizedString("profile_sec_enable_passcode", comment: "Enable Passcode Toggle") }
            static var biometricsHeader: String { NSLocalizedString("profile_sec_biometrics_header", comment: "Biometrics Header") }
            static var useBiometrics: String { NSLocalizedString("profile_sec_use_biometrics", comment: "Use Biometrics Toggle") }
            static var title: String { NSLocalizedString("profile_sec_title", comment: "Security Settings Title") }
        }
        
        // swiftlint:disable:next nesting
        struct DailyReminder {
            static var header: String { NSLocalizedString("profile_dr_header", comment: "Daily Reminder Header") }
            static var footer: String { NSLocalizedString("profile_dr_footer", comment: "Daily Reminder Footer") }
            static var enable: String { NSLocalizedString("profile_dr_enable", comment: "Enable Reminder Toggle") }
            static var timeLabel: String { NSLocalizedString("profile_dr_time_label", comment: "Reminder Time Label") }
            static var title: String { NSLocalizedString("profile_dr_title", comment: "Daily Reminder Title") }
        }
    }
    
    struct Passcode {
        static var enterTitle: String { NSLocalizedString("passcode_enter_title", comment: "Enter Passcode Title") }
        static var digitsPlaceholder: String { NSLocalizedString("passcode_digits_placeholder", comment: "4-digit passcode placeholder") }
        static var errorIncorrect: String { NSLocalizedString("passcode_error_incorrect", comment: "Incorrect Passcode Error") }
        static var createHeader: String { NSLocalizedString("passcode_create_header", comment: "Create Passcode Header") }
        static var createFooter: String { NSLocalizedString("passcode_create_footer", comment: "Create Passcode Footer") }
        static var enterNewPlaceholder: String { NSLocalizedString("passcode_enter_new_placeholder", comment: "Enter new passcode placeholder") }
        static var confirmPlaceholder: String { NSLocalizedString("passcode_confirm_placeholder", comment: "Confirm passcode placeholder") }
        static var setTitle: String { NSLocalizedString("passcode_set_title", comment: "Set Passcode Title") }
        static var errorLength: String { NSLocalizedString("passcode_error_length", comment: "Passcode length error") }
        static var errorMismatch: String { NSLocalizedString("passcode_error_mismatch", comment: "Passcode mismatch error") }
    }
    
    struct Bill {
        static var title: String { NSLocalizedString("bill_title", comment: "Main bill view title") }
        static var segmentBills: String { NSLocalizedString("bill_segment_bills", comment: "Bills segment title") }
        static var segmentBorrowLend: String { NSLocalizedString("bill_segment_borrow_lend", comment: "Borrowed/Lent segment title") }
        static var sectionPickerLabel: String { NSLocalizedString("bill_section_picker_label", comment: "Section picker label") }
        static var upcomingHeader: String { NSLocalizedString("bill_upcoming_header", comment: "Upcoming Bills header") }
        static var noBillsTitle: String { NSLocalizedString("bill_no_bills_title", comment: "No bills placeholder title") }
        static var noBillsSubtitle: String { NSLocalizedString("bill_no_bills_subtitle", comment: "No bills placeholder subtitle") }
        static var addManualButton: String { NSLocalizedString("bill_add_manual_button", comment: "Add manual bill button") }
        static var borrowLendHeader: String { NSLocalizedString("bill_borrow_lend_header", comment: "Borrowed & Lent header") }
        static var noEntriesTitle: String { NSLocalizedString("bill_no_entries_title", comment: "No entries placeholder title") }
        static var noEntriesSubtitle: String { NSLocalizedString("bill_no_entries_subtitle", comment: "No entries placeholder subtitle") }
        static var totalUpcoming: String { NSLocalizedString("bill_total_upcoming", comment: "Total upcoming header") }
        static var netBalance: String { NSLocalizedString("bill_net_balance", comment: "Net balance header") }
        static func lentAmount(_ amount: String) -> String { String(format: NSLocalizedString("bill_lent_format", comment: "Lent amount format"), amount) }
        static func borrowedAmount(_ amount: String) -> String { String(format: NSLocalizedString("bill_borrowed_format", comment: "Borrowed amount format"), amount) }
        static var addFirstEntryButton: String { NSLocalizedString("bill_add_first_entry_button", comment: "Add first entry button") }
        static var addBillButton: String { NSLocalizedString("bill_add_bill_button", comment: "Add Bill button label") }
        static var addEntryButton: String { NSLocalizedString("bill_add_entry_button", comment: "Add Entry button label") }
        
        static var detailsSection: String { NSLocalizedString("bill_details_section", comment: "Details section header") }
        static var amountLabel: String { NSLocalizedString("bill_amount_label", comment: "Amount label") }
        static var dueDateLabel: String { NSLocalizedString("bill_due_date_label", comment: "Due Date label") }
        static var statusLabel: String { NSLocalizedString("bill_status_label", comment: "Status label") }
        static var statusPaid: String { NSLocalizedString("bill_status_paid", comment: "Paid status") }
        static var statusUnpaid: String { NSLocalizedString("bill_status_unpaid", comment: "Unpaid status") }
        static var editAction: String { NSLocalizedString("bill_edit_action", comment: "Edit action") }
        
        static var typeLabel: String { NSLocalizedString("bl_type_label", comment: "Type label") }
        static var contactLabel: String { NSLocalizedString("bl_contact_label", comment: "Contact label") }
        static var statusSettled: String { NSLocalizedString("bl_status_settled", comment: "Settled status") }
        static var statusPending: String { NSLocalizedString("bl_status_pending", comment: "Pending status") }
        
        // swiftlint:disable:next nesting
        struct Add {
            // Add Bill
            static var billDetailsHeader: String { NSLocalizedString("bill_add_details_header", comment: "Bill Details Header") }
            static var titlePlaceholder: String { NSLocalizedString("bill_add_title_placeholder", comment: "Bill Title Placeholder") }
            static var reminderHeader: String { NSLocalizedString("bill_add_reminder_header", comment: "Reminder Header") }
            static var sendReminder: String { NSLocalizedString("bill_add_send_reminder", comment: "Send Reminder Toggle") }
            static var remindMeLabel: String { NSLocalizedString("bill_add_remind_me_label", comment: "Remind Me Label") }
            static var editBillTitle: String { NSLocalizedString("bill_add_edit_title", comment: "Edit Bill Title") }
            static var addNewBillTitle: String { NSLocalizedString("bill_add_new_title", comment: "Add Bill Title") }
            
            // Add Borrow/Lend
            static var entryDetailsHeader: String { NSLocalizedString("bl_add_entry_details_header", comment: "Entry Details Header") }
            static var typeLabel: String { NSLocalizedString("bl_add_type_label", comment: "Type Picker Label") }
            static var typeBorrowed: String { NSLocalizedString("bl_add_type_borrowed", comment: "Type Borrowed") }
            static var typeLent: String { NSLocalizedString("bl_add_type_lent", comment: "Type Lent") }
            static var personNamePlaceholder: String { NSLocalizedString("bl_add_person_placeholder", comment: "Person Name Placeholder") }
            static var contactPlaceholder: String { NSLocalizedString("bl_add_contact_placeholder", comment: "Contact Info Placeholder") }
            static var editEntryTitle: String { NSLocalizedString("bl_add_edit_title", comment: "Edit Entry Title") }
            static var addNewEntryTitle: String { NSLocalizedString("bl_add_new_title", comment: "Add Entry Title") }
        }
    }
    
    struct Notification {
        static var reminderSameDay: String { NSLocalizedString("rem_opt_same_day", comment: "Reminder option: Same day") }
        static var reminderOneDayBefore: String { NSLocalizedString("rem_opt_one_day_before", comment: "Reminder option: 1 day before") }
        static var reminderTwoDaysBefore: String { NSLocalizedString("rem_opt_two_days_before", comment: "Reminder option: 2 days before") }
        static var reminderOneWeekBefore: String { NSLocalizedString("rem_opt_one_week_before", comment: "Reminder option: 1 week before") }
        
        static var dailyTitle: String { NSLocalizedString("notif_daily_title", comment: "Daily transaction reminder title") }
        static var dailyBody: String { NSLocalizedString("notif_daily_body", comment: "Daily transaction reminder body") }
        
        static var title: String { NSLocalizedString("notif_title", comment: "Notifications title") }
        static var markAllRead: String { NSLocalizedString("notif_mark_read", comment: "Mark all as read") }
        static var emptyTitle: String { NSLocalizedString("notif_empty_title", comment: "No notifications title") }
        static var emptyBody: String { NSLocalizedString("notif_empty_body", comment: "No notifications body") }
    }
    
    struct Statics {
        static var title: String { NSLocalizedString("statics_title", comment: "Main statistics view title") }
        static var income: String { NSLocalizedString("statics_income", comment: "Income stat card title") }
        static var expense: String { NSLocalizedString("statics_expense", comment: "Expense stat card title") }
        static var spendingTrends: String { NSLocalizedString("statics_spending_trends", comment: "Spending Trends header") }
        static var dailyTotals: String { NSLocalizedString("statics_daily_totals", comment: "Daily totals header") }
        static var noDataTitle: String { NSLocalizedString("statics_no_data_title", comment: "No data placeholder title") }
        static var noDataSubtitle: String { NSLocalizedString("statics_no_data_subtitle", comment: "No data placeholder subtitle") }
        static var spendingByCategory: String { NSLocalizedString("statics_spending_category", comment: "Spending by category header") }
        static var transactionsHeader: String { NSLocalizedString("statics_transactions", comment: "Transactions header") }
        static var noTransactions: String { NSLocalizedString("statics_no_transactions", comment: "No transactions text") }
        static var savingsRate: String { NSLocalizedString("statics_savings_rate", comment: "Savings Rate title") }
        static var savingsHealthy: String { NSLocalizedString("statics_savings_healthy", comment: "Healthy savings message") }
        static var savingsPush: String { NSLocalizedString("statics_savings_push", comment: "Push to save message") }
        
        static var customTitle: String { NSLocalizedString("stats_custom_title", comment: "Custom date picker title") }
        static var startDate: String { NSLocalizedString("stats_start_date", comment: "Start Date label") }
        static var endDate: String { NSLocalizedString("stats_end_date", comment: "End Date label") }
        static var apply: String { NSLocalizedString("stats_apply", comment: "Apply action") }
        
        // swiftlint:disable:next nesting
        struct Filter {
            static var thisWeek: String { NSLocalizedString("stats_filter_this_week", comment: "Filter: This Week") }
            static var thisMonth: String { NSLocalizedString("stats_filter_this_month", comment: "Filter: This Month") }
            static var custom: String { NSLocalizedString("stats_filter_custom", comment: "Filter: Custom") }
        }
        
        // swiftlint:disable:next nesting
        struct Chart {
            static var breakdown: String { NSLocalizedString("stats_chart_breakdown", comment: "Chart breakdown title") }
            static var total: String { NSLocalizedString("stats_chart_total", comment: "Chart total label") }
        }
        
        static var totalLabel: String { NSLocalizedString("statics_total_label", comment: "Total label") }
    }
    
    struct Error {
        static var validationTitle: String { NSLocalizedString("error_title_validation", comment: "Validation Error Title") }
        static var insufficientFundsTitle: String { NSLocalizedString("error_title_insufficient_funds", comment: "Insufficient Funds Error Title") }
        static var unknown: String { NSLocalizedString("error_unknown", comment: "Unknown error message") }
        
        static var invalidAmount: String { NSLocalizedString("error_invalid_amount", comment: "Invalid amount error") }
        static var missingAccount: String { NSLocalizedString("error_missing_account", comment: "Missing account error") }
        static var invalidCardNumber: String { NSLocalizedString("error_invalid_card_number", comment: "Invalid card number error") }
        static var missingLinkedAccount: String { NSLocalizedString("error_missing_linked_account", comment: "Missing linked account error") }
        static var deletionFailed: String { NSLocalizedString("error_deletion_failed", value: "Deletion Failed", comment: "Deletion failed error") }
        
        static func missingField(_ field: String) -> String {
            String(format: NSLocalizedString("error_missing_field", comment: "Missing field error"), field)
        }
        
        static func invalidCreditCardDetails(_ field: String) -> String {
            String(format: NSLocalizedString("error_invalid_credit_card_details", comment: "Invalid credit card details error"), field)
        }
        
        static func insufficientFundsMessage(accountName: String) -> String {
            String(format: NSLocalizedString("error_insufficient_funds_message", comment: "Insufficient funds message"), accountName)
        }
    }
}
// swiftlint:enable line_length
