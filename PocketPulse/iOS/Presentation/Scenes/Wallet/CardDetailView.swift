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
                        .frame(height: AppConstants.Size.cardCarouselHeight)
                        .padding(.top, 20)
                        .shadow(color: Color.black.opacity(AppConstants.Opacity.low), radius: 15, x: 0, y: 10)
                    
                    // MARK: - Credit Statistics (Only for Credit Cards)
                    if card.cardType == .credit {
                        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                            VStack(spacing: AppConstants.Layout.spacingMedium) {
                                HStack {
                                    AppText.Header(text: AppStrings.Wallet.creditUtilization)
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
                                            .fill(Color.white.opacity(AppConstants.Opacity.faint))
                                            .frame(height: AppConstants.Layout.paddingTen)
                                        
                                        if let limit = card.creditLimit,
                                           let balance = card.outstandingBalance, limit > 0 {
                                            Capsule()
                                                .fill(utilizationColor(balance: balance, limit: limit))
                                                .frame(width: min(CGFloat(balance / limit) * geometry.size.width,
                                                                  geometry.size.width),
                                                       height: AppConstants.Layout.paddingTen)
                                        }
                                    }
                                }
                                .frame(height: AppConstants.Layout.paddingTen)
                                
                                Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        AppText.Caption(text: AppStrings.Wallet.availableCredit,
                                                        color: AppTheme.adaptiveText.opacity(AppConstants.Opacity.medium))
                                        if let limit = card.creditLimit, let balance = card.outstandingBalance {
                                            Text("\((limit - balance).formatted(.currency(code: AppConstants.Currency.isoCode)))")
                                                .font(.headline)
                                                .foregroundColor(AppTheme.adaptiveText)
                                        }
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        AppText.Caption(text: AppStrings.Wallet.totalLimit,
                                                        color: AppTheme.adaptiveText.opacity(AppConstants.Opacity.medium))
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
                                    Label(AppStrings.Wallet.billingDateLabel, systemImage: AppAssets.Icons.calendar)
                                        .font(.caption)
                                        .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                                    Text(AppStrings.Wallet.dayPrefix(card.billingDate ?? 1))
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(AppTheme.adaptiveText)
                                }
                                Spacer()
                                Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                                Spacer()
                                VStack(alignment: .leading) {
                                    Label(AppStrings.Wallet.paymentDueLabel, systemImage: AppAssets.Icons.clockFill)
                                        .font(.caption)
                                        .foregroundColor(.red.opacity(AppConstants.Opacity.high))
                                    Text(AppStrings.Wallet.dayPrefix(card.paymentDueDate ?? 1))
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
                            DetailRow(label: AppStrings.Wallet.cardHolderLabel,
                                      value: card.cardHolderName,
                                      icon: AppAssets.Icons.personFill)
                            Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                            DetailRow(label: AppStrings.Wallet.bankLabel,
                                      value: card.bankName,
                                      icon: AppAssets.Icons.buildingColumnsFill)
                            Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                            DetailRow(label: "Provider",
                                      value: card.providerType.rawValue.capitalized,
                                      icon: AppAssets.Icons.creditCardFill)
                            
                            if card.cardType == .debit, let linkedAccount = card.linkedBankAccount {
                                Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                                DetailRow(label: AppStrings.Wallet.linkedAccountLabel,
                                          value: linkedAccount.name,
                                          icon: AppAssets.Icons.link)
                            }
                             
                            Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                            DetailRow(label: AppStrings.Wallet.expiryLabel,
                                      value: card.expiryDate,
                                      icon: AppAssets.Icons.calendarBadgeExclamationmark)
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
            IconView(icon: icon, size: AppConstants.Size.iconMedium, color: iconColor)
                .frame(width: AppConstants.Size.iconMedium, height: AppConstants.Size.iconMedium)
                .background(Color.white.opacity(AppConstants.Opacity.faint))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.medium))
                Text(value)
                    .font(.body)
                    .foregroundColor(AppTheme.adaptiveText)
            }
            Spacer()
        }
    }
}
