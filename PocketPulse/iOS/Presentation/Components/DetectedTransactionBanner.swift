//
//  DetectedTransactionBanner.swift
//  PocketPulse
//
//  Created by govardhan singh on 08/09/26.
//

import SwiftUI

struct DetectedTransactionBanner: View {
    let transaction: DetectedTransaction
    let onQuickAdd: () -> Void
    let onReview: () -> Void
    let onDismiss: () -> Void
    
    @State private var isSparklePulsing = false
    
    var body: some View {
        VStack(spacing: AppConstants.Layout.paddingSmall) {
            // MARK: - Header
            HStack(spacing: AppConstants.Layout.paddingSmall) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.primaryColor)
                        .scaleEffect(isSparklePulsing ? 1.15 : 0.95)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isSparklePulsing)
                    
                    Text(AppStrings.Detection.bannerHeader)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(0.8)
                        .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                }
                
                Spacer()
                
                // Source Pill
                HStack(spacing: 4) {
                    Image(systemName: transaction.source == .shortcut ? "bolt.fill" : "doc.on.clipboard.fill")
                        .font(.system(size: 9))
                    Text(transaction.source.rawValue)
                        .font(.system(size: 10, weight: .medium))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(AppTheme.primaryColor.opacity(AppConstants.Opacity.light))
                )
                .foregroundColor(AppTheme.primaryColor)
                
                // Close button
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onDismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.dim))
                })
            }
            
            // MARK: - Transaction Info Card
            HStack(alignment: .center, spacing: AppConstants.Layout.paddingMedium) {
                // Category Icon
                ZStack {
                    Circle()
                        .fill(transactionTypeColor.opacity(AppConstants.Opacity.light))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: categoryIconName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(transactionTypeColor)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(transaction.title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.adaptiveText)
                        .lineLimit(1)
                    
                    HStack(spacing: 6) {
                        Text(transaction.category.displayName)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.secondary))
                        
                        if let hint = transaction.accountHint {
                            Text("•")
                                .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.dim))
                            Text(hint)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppTheme.primaryColor)
                        }
                    }
                }
                
                Spacer()
                
                // Amount Display
                VStack(alignment: .trailing, spacing: 2) {
                    Text(formattedAmount)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(transactionTypeColor)
                    
                    Text(formattedDate)
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(AppTheme.adaptiveText.opacity(AppConstants.Opacity.dim))
                }
            }
            .padding(.vertical, 2)
            
            // MARK: - Action Buttons
            HStack(spacing: AppConstants.Layout.paddingSmall) {
                // Review & Edit Button
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onReview()
                }, label: {
                    HStack(spacing: 6) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12, weight: .semibold))
                        Text(AppStrings.Detection.review)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .foregroundColor(AppTheme.adaptiveText)
                })
                
                // Quick Add Button
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onQuickAdd()
                }, label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 12, weight: .semibold))
                        Text(AppStrings.Detection.quickAdd)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(AppTheme.primaryGradient)
                            .shadow(color: AppTheme.primaryColor.opacity(0.3), radius: 6, x: 0, y: 3)
                    )
                    .foregroundColor(.white)
                })
            }
            .padding(.top, 4)
        }
        .padding(AppConstants.Layout.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.35),
                                    AppTheme.primaryColor.opacity(0.2),
                                    Color.white.opacity(0.08)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.2
                        )
                )
                .shadow(color: Color.black.opacity(0.18), radius: 16, x: 0, y: 8)
        )
        .padding(.horizontal, AppConstants.Layout.paddingMedium)
        .onAppear {
            isSparklePulsing = true
        }
    }
    
    // MARK: - Helpers
    
    private var transactionTypeColor: Color {
        transaction.type == .income ? AppTheme.income : AppTheme.expense
    }
    
    private var formattedAmount: String {
        let prefix = transaction.type == .income ? "+" : "-"
        let symbol = Locale.current.currencySymbol ?? "₹"
        return "\(prefix)\(symbol)\(String(format: "%.2f", transaction.amount))"
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, hh:mm a"
        return formatter.string(from: transaction.date)
    }
    
    private var categoryIconName: String {
        switch transaction.category {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "cart.fill"
        case .bills: return "bolt.fill"
        case .entertainment: return "tv.fill"
        case .health: return "cross.case.fill"
        case .education: return "book.fill"
        case .rent: return "house.fill"
        case .salary: return "briefcase.fill"
        case .freelance: return "laptopcomputer"
        case .business: return "chart.bar.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .other: return "ellipsis.circle.fill"
        }
    }
}
