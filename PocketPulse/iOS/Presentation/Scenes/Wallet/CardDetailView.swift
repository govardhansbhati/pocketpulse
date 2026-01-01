//
//  CardDetailView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 16/08/25.
//
import SwiftUI

// MARK: - Card Detail View (New)
// MARK: - Card Detail View (New)
struct CardDetailView: View {
    @Environment(\.presentWalletSheet) private var presentSheet
    let card: CardModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: AppConstants.Layout.spacingLarge) {
                    
                    // MARK: - Visual Card Representation
                    CardView(card: card)
                        .frame(height: 220)
                        .padding(.top, 20)
                        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 10)
                    
                    // MARK: - Credit Statistics (Only for Credit Cards)
                    if card.cardType == .credit {
                        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                            VStack(spacing: AppConstants.Layout.spacingMedium) {
                                HStack {
                                    Text("Credit Utilization")
                                        .font(.headline)
                                        .foregroundColor(AppTheme.adaptiveText)
                                    Spacer()
                                    if let limit = card.creditLimit, let balance = card.outstandingBalance, limit > 0 {
                                        Text("\(Int((balance / limit) * 100))%")
                                            .font(.headline)
                                            .foregroundColor(utilizationColor(balance: balance, limit: limit))
                                    }
                                }
                                
                                // Progress Bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.white.opacity(0.1))
                                            .frame(height: 10)
                                        
                                        if let limit = card.creditLimit, let balance = card.outstandingBalance, limit > 0 {
                                            Capsule()
                                                .fill(utilizationColor(balance: balance, limit: limit))
                                                .frame(width: min(CGFloat(balance / limit) * geometry.size.width, geometry.size.width), height: 10)
                                        }
                                    }
                                }
                                .frame(height: 10)
                                
                                Divider().background(Color.white.opacity(0.1))
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Available Credit")
                                            .font(.caption)
                                            .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
                                        if let limit = card.creditLimit, let balance = card.outstandingBalance {
                                            Text("\((limit - balance).formatted(.currency(code: AppConstants.Currency.isoCode)))")
                                                .font(.headline)
                                                .foregroundColor(AppTheme.adaptiveText)
                                        }
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text("Total Limit")
                                            .font(.caption)
                                            .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
                                        Text(card.creditLimit?.formatted(.currency(code: AppConstants.Currency.isoCode)) ?? "-")
                                            .font(.headline)
                                            .foregroundColor(AppTheme.adaptiveText)
                                    }
                                }
                            }
                            .padding(AppConstants.Layout.paddingMedium)
                        }
                        .padding(.horizontal)
                        
                        // Dates Card
                        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("Billing Date", systemImage: "calendar")
                                        .font(.caption)
                                        .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
                                    Text("Day \(card.billingDate ?? 1)")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(AppTheme.adaptiveText)
                                }
                                Spacer()
                                Divider().background(Color.white.opacity(0.1))
                                Spacer()
                                VStack(alignment: .leading) {
                                    Label("Payment Due", systemImage: "clock.fill")
                                        .font(.caption)
                                        .foregroundColor(.red.opacity(0.8))
                                    Text("Day \(card.paymentDueDate ?? 1)")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(AppTheme.adaptiveText)
                                }
                            }
                            .padding(AppConstants.Layout.paddingMedium)
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - General Details
                    GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingMedium) {
                            DetailRow(label: AppStrings.Wallet.cardHolderLabel, value: card.cardHolderName, icon: "person.fill")
                            Divider().background(Color.white.opacity(0.1))
                            DetailRow(label: AppStrings.Wallet.bankLabel, value: card.bankName, icon: AppAssets.Icons.buildingColumnsFill)
                            Divider().background(Color.white.opacity(0.1))
                            DetailRow(label: "Provider", value: card.providerType.rawValue.capitalized, icon: "creditcard.fill")
                            
                            if card.cardType == .debit, let linkedAccount = card.linkedBankAccount {
                                Divider().background(Color.white.opacity(0.1))
                                DetailRow(label: "Linked Account", value: linkedAccount.name, icon: "link")
                            }
                             
                            Divider().background(Color.white.opacity(0.1))
                            DetailRow(label: "Expiry", value: card.expiryDate, icon: "calendar.badge.exclamationmark")
                        }
                        .padding(AppConstants.Layout.paddingMedium)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 50)
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(AppStrings.Wallet.editAction) {
                    presentSheet?(.addCard(card))
                }
            }
        }
    }
    
    private func utilizationColor(balance: Double, limit: Double) -> Color {
        let ratio = balance / limit
        if ratio < 0.3 { return .green }
        if ratio < 0.7 { return .yellow }
        return .red
    }
}

// Helper View for Rows (Reused)
fileprivate struct DetailRow: View {
    let label: String
    let value: String
    let icon: String
    var iconColor: Color = AppTheme.primaryColor
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
                .background(Color.white.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(AppTheme.adaptiveText.opacity(0.6))
                Text(value)
                    .font(.body)
                    .foregroundColor(AppTheme.adaptiveText)
            }
            Spacer()
        }
    }
}
