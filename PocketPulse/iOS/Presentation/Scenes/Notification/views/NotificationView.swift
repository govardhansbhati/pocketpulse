//
//  NotificationView.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import SwiftData
import SwiftUI

struct NotificationView: View {
    @StateObject private var viewModel: NotificationViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: NotificationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        IconView(icon: AppAssets.Icons.chevronLeft,
                                 size: AppConstants.Size.iconTiny,
                                 color: AppTheme.adaptiveText)
                            .padding(AppConstants.Layout.paddingTen)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    AppText.Title(text: AppStrings.Notification.title)
                        .padding(.leading, AppConstants.Layout.paddingSmall)
                    
                    Spacer()
                    
                    if !viewModel.notifications.isEmpty {
                        Button(action: {
                            viewModel.markAllAsRead()
                        }) {
                            AppText.Tiny(text: AppStrings.Notification.markAllRead,
                                         color: AppTheme.primaryColor)
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, AppConstants.Layout.headerTopPadding)
                .padding(.bottom)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.notifications.isEmpty {
                    ContentUnavailableView(
                        AppStrings.Notification.emptyTitle,
                        systemImage: AppAssets.Icons.bellSlashFill,
                        description: Text(AppStrings.Notification.emptyBody)
                    )
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: AppConstants.Layout.spacingMedium) {
                            ForEach(viewModel.notifications) { item in
                                NotificationRow(item: item)
                            }
                        }
                        .padding()
                    }
                }
            }
            .ignoresSafeArea()
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadNotifications()
        }
    }
}

struct NotificationRow: View {
    let item: NotificationModel
    
    var body: some View {
        GlassCard(cornerRadius: AppConstants.Layout.cornerRadiusMedium) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(item.type.color.opacity(0.15))
                        .frame(width: AppConstants.Size.iconProfilePlaceholder,
                               height: AppConstants.Size.iconProfilePlaceholder)
                    
                    IconView(icon: item.type.icon, size: AppConstants.Size.iconTiny, color: item.type.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(item.isRead ? AppTheme.adaptiveText.opacity(0.6) : AppTheme.adaptiveText)
                    
                    Text(item.message)
                        .font(.subheadline)
                        .foregroundColor(AppTheme.adaptiveText.opacity(0.7))
                        .lineLimit(2)
                    
                    Text(item.timeAgo)
                        .font(.caption2)
                        .foregroundColor(AppTheme.adaptiveText.opacity(0.4))
                        .padding(.top, AppConstants.Layout.paddingTopNano)
                }
                
                Spacer()
                
                if !item.isRead {
                    Circle()
                        .fill(AppTheme.primaryColor)
                        .frame(width: AppConstants.Size.progressBarHeight, height: AppConstants.Size.progressBarHeight)
                        .padding(.top, AppConstants.Layout.paddingSmall)
                }
            }
            .padding()
        }
    }
}

#Preview {
    // Mock logic for preview
    NotificationView(
        viewModel: NotificationViewModel(useCase: NotificationUseCase(service: NotificationService(context: try! ModelContainer(for: NotificationModel.self).mainContext))))
}
