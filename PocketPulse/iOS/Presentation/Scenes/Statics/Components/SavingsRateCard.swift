
import SwiftUI

struct SavingsRateCard: View {
    let savingsRate: Double
    let savingsMessage: String
    let statusColor: Color
    let indicatorColor: Color
    
    var body: some View {
        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusExtraLarge) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    AppText.Subtitle(text: AppStrings.Statics.savingsRate, color: AppTheme.adaptiveText.opacity(0.8))
                    AppText.Header(text: savingsRate.formatted(.percent.precision(.fractionLength(1))),
                                   color: indicatorColor)
                    
                    AppText.Caption(text: savingsMessage, color: statusColor)
                }
                
                Spacer()
                
                // Circular Progress
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 8)
                    Circle()
                        .trim(from: 0, to: savingsRate)
                        .stroke(
                            AngularGradient(colors: [AppTheme.income, .teal], center: .center),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .shadow(color: AppTheme.income.opacity(AppConstants.Opacity.dim), radius: 10)
                }
                .frame(width: AppConstants.Size.iconExtraLarge, height: AppConstants.Size.iconExtraLarge)
            }
            .padding(AppConstants.Layout.paddingLarge)
        }
    }
}
