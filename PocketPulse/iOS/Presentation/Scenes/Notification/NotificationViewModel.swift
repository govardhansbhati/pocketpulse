//
//  NotificationViewModel.swift
//  PocketPulse
//
//  Created by govardhan singh on 02/01/26.
//

import Foundation

@MainActor
final class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let useCase: NotificationUseCaseProtocol
    
    init(useCase: NotificationUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func loadNotifications() async {
        isLoading = true
        errorMessage = nil
        do {
            notifications = try await useCase.loadNotifications()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func markAllAsRead() {
        // Optimistic update
        notifications = notifications.map { var n = $0; n.isRead = true; return n }
        Task {
            try? await useCase.markAllAsRead()
        }
    }
}
