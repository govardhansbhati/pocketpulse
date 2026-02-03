//
//  BreakdownView.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import SwiftUI

struct BreakdownView: View {
    @StateObject private var viewModel: BreakdownViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: BreakdownViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: AppConstants.Layout.spacingLarge) {
                // Header
                HStack {
                    AppText.Header(text: AppStrings.Home.Breakdown.title)
                    Spacer()
                    Button(action: { dismiss() }, label: {
                        IconView(icon: AppAssets.Icons.xmarkCircleFill,
                                 size: 24,
                                 color: AppTheme.adaptiveText.opacity(AppConstants.Opacity.medium))
                    })
                }
                .padding(.horizontal)
                .padding(.top, AppConstants.Layout.paddingStandard)
                
                // Total Balance Card
                GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                    VStack(spacing: 8) {
                        AppText.Headline(text: AppStrings.Home.Breakdown.totalNetWorth,
                                         color: AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                        Text(viewModel.totalBalance, format: .currency(code: AppConstants.Currency.isoCode))
                            .font(.system(size: AppConstants.Size.iconContainerSmall,
                                          weight: .bold,
                                          design: .rounded))
                            .foregroundColor(AppTheme.adaptiveText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .padding(.horizontal)
                
                // Accounts List
                ScrollView {
                    VStack(spacing: AppConstants.Layout.spacingMedium) {
                        if viewModel.accounts.isEmpty {
                            ContentUnavailableView(
                                AppStrings.Wallet.noAccountsTitle,
                                systemImage: AppAssets.Icons.buildingColumnsFill,
                                description: Text(AppStrings.Wallet.addAccountButton)
                                // Or "Add accounts to see breakdown" if I made a string. I used "no_accounts_subtitle"? No, I made "wallet_no_accounts_subtitle".
                            )
                        } else {
                            ForEach(viewModel.accounts) { account in
                                GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(AppTheme.primaryColor.opacity(AppConstants.Opacity.faint))
                                                .frame(width: AppConstants.Size.iconContainer,
                                                       height: AppConstants.Size.iconContainer)
                                            IconView(icon: AppAssets.Icons.buildingColumnsFill,
                                                     size: AppConstants.Size.iconSmall,
                                                     color: AppTheme.primaryColor)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(account.name)
                                                .font(.headline)
                                                .foregroundColor(AppTheme.adaptiveText)
                                            Text(account.institution)
                                                .font(.caption)
                                                .foregroundColor(AppTheme.adaptiveText
                                                    .opacity(AppConstants.Opacity.medium))
                                        }
                                        
                                        Spacer()
                                        
                                        Text(account.balance, format: .currency(code: AppConstants.Currency.isoCode))
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(AppTheme.adaptiveText)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
