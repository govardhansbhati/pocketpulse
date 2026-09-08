//
//  CardDetailView.swift
//  PocketPulse
//
//  Created by govardhan singh bhati on 16/08/25.
//
import SwiftUI

// MARK: - Card Detail View (New)
struct CardDetailView: View {
    @Environment(\.presentWalletSheet) private var presentSheet
    @StateObject private var viewModel: CardDetailViewModel
    
    init(card: CardModel) {
        _viewModel = StateObject(wrappedValue: CardDetailViewModel(card: card))
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: AppConstants.Layout.spacingLarge) {
                    
                    // MARK: - Visual Card Representation
                    CardView(card: viewModel.card)
                        .frame(height: AppConstants.Size.cardCarouselHeight)
                        .padding(.top, AppConstants.Layout.paddingStandard)
                        .shadow(color: Color.black.opacity(AppConstants.Opacity.low),
                                radius: AppConstants.Layout.shadowRadiusMedium,
                                x: 0,
                                y: AppConstants.Layout.shadowYMedium)
                    
                    // MARK: - Credit Statistics (Only for Credit Cards)
                    if viewModel.isCreditCard {
                        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
                            VStack(spacing: AppConstants.Layout.spacingMedium) {
                                HStack {
                                    AppText.Header(text: AppStrings.Wallet.creditUtilization)
                                    Spacer()
                                    if viewModel.creditLimit > 0 {
                                        Text(viewModel.utilizationPercentageText)
                                            .font(.headline)
                                            .foregroundColor(viewModel.utilizationColor)
                                    }
                                }
                                
                                // Progress Bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.white.opacity(AppConstants.Opacity.faint))
                                            .frame(height: AppConstants.Layout.paddingTen)
                                        
                                        if viewModel.creditLimit > 0 {
                                            Capsule()
                                                .fill(viewModel.utilizationColor)
                                                .frame(
                                                    width: min(
                                                        CGFloat(viewModel.utilizationRatio) * geometry.size.width,
                                                        geometry.size.width
                                                    ),
                                                    height: AppConstants.Layout.paddingTen
                                                )
                                        }
                                    }
                                }
                                .frame(height: AppConstants.Layout.paddingTen)
                                
                                Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        AppText.Caption(text: AppStrings.Wallet.availableCredit,
                                                        color: AppTheme.adaptiveText
                                            .opacity(AppConstants.Opacity.medium))
                                        Text(viewModel.availableCreditText)
                                            .font(.headline)
                                            .foregroundColor(AppTheme.adaptiveText)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        AppText.Caption(text: AppStrings.Wallet.totalLimit,
                                                        color: AppTheme.adaptiveText
                                            .opacity(AppConstants.Opacity.medium))
                                        Text(viewModel.totalLimitText)
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
                                    Text(viewModel.billingDayText)
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
                                    Text(viewModel.paymentDueDayText)
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
                                      value: viewModel.cardHolderName,
                                      icon: AppAssets.Icons.personFill)
                            Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                            DetailRow(label: AppStrings.Wallet.bankLabel,
                                      value: viewModel.bankName,
                                      icon: AppAssets.Icons.buildingColumnsFill)
                            Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                            DetailRow(label: AppStrings.Wallet.providerLabel,
                                      value: viewModel.providerName,
                                      icon: AppAssets.Icons.creditCardFill)
                            
                            if viewModel.isDebitCard, let linkedAccountName = viewModel.linkedAccountName {
                                Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                                DetailRow(label: AppStrings.Wallet.linkedAccountLabel,
                                          value: linkedAccountName,
                                          icon: AppAssets.Icons.link)
                            }
                            
                            Divider().background(Color.white.opacity(AppConstants.Opacity.faint))
                            DetailRow(label: AppStrings.Wallet.expiryLabel,
                                      value: viewModel.expiryDate,
                                      icon: AppAssets.Icons.calendarBadgeExclamationmark)
                        }
                        .padding(AppConstants.Layout.paddingMedium)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: AppConstants.Layout.spacerHeightMedium)
                }
                .padding(.bottom, AppConstants.Layout.spacerHeightMedium)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(AppStrings.Wallet.editAction) {
                    presentSheet?(.addCard(viewModel.card))
                }
            }
        }
    }
    
    // Helper View for Rows (Reused)
    private struct DetailRow: View {
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
                
                VStack(alignment: .leading, spacing: AppConstants.Layout.spacingNano) {
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
}
