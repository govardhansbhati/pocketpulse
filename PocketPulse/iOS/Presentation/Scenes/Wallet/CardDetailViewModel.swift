import Combine
import SwiftUI

class CardDetailViewModel: ObservableObject {
    @Published var card: CardModel
    
    init(card: CardModel) {
        self.card = card
    }
    
    // MARK: - Computed Properties
    
    var isCreditCard: Bool {
        card.cardType == .credit
    }
    
    var creditLimit: Double {
        card.creditLimit ?? 0
    }
    
    var outstandingBalance: Double {
        card.outstandingBalance ?? 0
    }
    
    var utilizationRatio: Double {
        guard creditLimit > 0 else { return 0 }
        return outstandingBalance / creditLimit
    }
    
    var utilizationPercentageText: String {
        guard creditLimit > 0 else { return "0%" }
        return "\(Int(utilizationRatio * 100))%"
    }
    
    var utilizationColor: Color {
        let ratio = utilizationRatio
        if ratio < 0.3 { return .green }
        if ratio < 0.7 { return .yellow }
        return .red
    }
    
    var availableCreditText: String {
        let available = creditLimit - outstandingBalance
        return available.formatted(.currency(code: AppConstants.Currency.isoCode))
    }
    
    var totalLimitText: String {
        card.creditLimit?.formatted(.currency(code: AppConstants.Currency.isoCode)) ?? "-"
    }
    
    var billingDayText: String {
        AppStrings.Wallet.dayPrefix(card.billingDate ?? 1)
    }
    
    var paymentDueDayText: String {
        AppStrings.Wallet.dayPrefix(card.paymentDueDate ?? 1)
    }
    
    var cardHolderName: String {
        card.cardHolderName
    }
    
    var bankName: String {
        card.bankName
    }
    
    var providerName: String {
        card.providerType.rawValue.capitalized
    }
    
    var isDebitCard: Bool {
        card.cardType == .debit
    }
    
    var linkedAccountName: String? {
        card.linkedBankAccount?.name
    }
    
    var expiryDate: String {
        card.expiryDate
    }
}
