//
//  MockAccountsService.swift
//  PocketPulse
//
//  Created by Govardhan Singh Bhati on 28/12/25.
//


//
//  MockAccountsService.swift
//  PocketPulse
//

import Foundation

final class MockAccountsService: AccountsServiceProtocol {
    func fetchAccounts() async throws -> [AccountModel] {
        MockData.accounts
    }
    func delete(_ item: AccountModel) async throws {}
}