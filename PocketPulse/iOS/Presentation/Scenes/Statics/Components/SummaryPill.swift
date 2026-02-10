import SwiftUI

struct SummaryPill: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color
    
    var body: some View {
        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusLarge) {
            VStack(alignment: .leading, spacing: AppConstants.Layout.spacingSmall) {
                HStack {
                    Circle()
                        .fill(color.opacity(AppConstants.Opacity.light))
                        .frame(width: AppConstants.Size.iconContainerTiny, height: AppConstants.Size.iconContainerTiny)
                        .overlay(
                            Image(systemName: icon)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(color)
                        )
                    AppText.Caption(text: title, color: AppTheme.adaptiveText.opacity(0.7))
                }
                
                AppText.Title(text: amount.formatted(.currency(code: AppConstants.Currency.isoCode)))
                    .minimumScaleFactor(0.8)
            }
            .padding(AppConstants.Layout.paddingMedium)
        }
    }
}
