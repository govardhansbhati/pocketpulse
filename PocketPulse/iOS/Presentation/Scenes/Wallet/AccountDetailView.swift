//
//  AccountDetailView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 16/08/25.
//
import SwiftUI

struct AccountDetailView: View {
    @Environment(\.presentWalletSheet) private var presentSheet
    let account: AccountModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: AppConstants.Layout.spacingLarge) {
                    
                    // MARK: - Header Section
                    VStack(spacing: AppConstants.Layout.spacingSmall) {
                        Text(account.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.adaptiveText)
                        
                        Text(account.balance.formatted(.currency(code: AppConstants.Currency.isoCode)))
                            .font(.system(size: AppConstants.Size.balanceFontSize, weight: .heavy, design: .rounded))
                            .foregroundColor(AppTheme.primaryColor)
                            .shadow(color: AppTheme.primaryColor.opacity(AppConstants.Opacity.low),
                                    radius: 10,
                                    x: 0,
                                    y: 5)
                        
                        Text(account.institution)
                            .font(.headline)
                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Details Card
                    GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                        VStack(alignment: .leading, spacing: AppConstants.Layout.spacingMedium) {
                            AccountDetailRow(label: AppStrings.Wallet.institutionLabel,
                                             value: account.institution,
                                             icon: AppAssets.Icons.buildingColumnsFill)
                            
                            if let accNumber = account.accountNumber, !accNumber.isEmpty {
                                Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                                AccountDetailRow(label: AppStrings.Wallet.accountNumberLabel,
                                                 value: maskedAccountNumber(accNumber),
                                                 icon: AppAssets.Icons.numberSquareFill)
                            }
                            
                            if let ifsc = account.ifscCode, !ifsc.isEmpty {
                                Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                                AccountDetailRow(label: AppStrings.Wallet.ifscLabel,
                                                 value: ifsc,
                                                 icon: AppAssets.Icons.building2Fill)
                            }
                            
                            Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                            AccountDetailRow(label: AppStrings.Wallet.openingDateLabel,
                                             value: account.openingDate.formatted(date: .abbreviated, time: .omitted),
                                             icon: AppAssets.Icons.calendar)
                            
                            Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                            AccountDetailRow(label: AppStrings.Wallet.statusLabel,
                                             value: account.status.rawValue,
                                             icon: AppAssets.Icons.circleFill,
                                             iconColor: account.status == .active ? .green : .red)
                        }
                        .padding(AppConstants.Layout.paddingMedium)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Notes Card (if present)
                    if let notes = account.notes, !notes.isEmpty {
                        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                            VStack(alignment: .leading, spacing: 8) {
                                AppText.Headline(text: AppStrings.Wallet.notesLabel)
                                Text(notes)
                                    .font(.body)
                                    .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.high))
                            }
                            .padding(AppConstants.Layout.paddingMedium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 50)
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(AppStrings.Wallet.editAction) {
                    presentSheet?(.addAccount(account))
                }
            }
        }
    }
    
    // Helper to mask account number
    private func maskedAccountNumber(_ number: String) -> String {
        guard number.count > 4 else { return number }
        let suffix = number.suffix(4)
        let prefixLength = number.count - 4
        let mask = String(repeating: "•", count: prefixLength)
        return "\(mask) \(suffix)"
    }
}

// Helper View for Rows
private struct AccountDetailRow: View {
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
