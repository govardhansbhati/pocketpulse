//
//  TransactionSMSParser.swift
//  PocketPulse
//
//  Created by govardhan singh on 08/09/26.
//

import Foundation

struct TransactionSMSParser {
    
    // MARK: - Public API
    
    /// Parses financial SMS or payment alert text and returns a DetectedTransaction if valid.
    static func parse(text: String, source: DetectionSource = .clipboard) -> DetectedTransaction? {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return nil }
        
        // 1. Safety check: Filter out pure OTP / 2FA messages that do not contain actual transactions
        if isPureOTP(cleaned) {
            return nil
        }
        
        // 2. Determine Transaction Type (Debit vs Credit)
        guard let type = determineType(cleaned) else {
            return nil
        }
        
        // 3. Extract Amount
        guard let amount = extractAmount(cleaned), amount > 0 else {
            return nil
        }
        
        // 4. Extract Merchant / Payee Title
        let merchant = extractMerchant(cleaned, type: type)
        
        // 5. Extract Account / Card Hint
        let accountHint = extractAccountHint(cleaned)
        
        // 6. Infer Category
        let category = inferCategory(merchant: merchant, fullText: cleaned, type: type)
        
        // 7. Extract Date (or default to current)
        let date = extractDate(cleaned) ?? Date()
        
        return DetectedTransaction(
            rawText: cleaned,
            amount: amount,
            title: merchant,
            type: type,
            category: category,
            date: date,
            accountHint: accountHint,
            source: source,
            detectedAt: Date()
        )
    }
    
    // MARK: - Validation & Type Determination
    
    private static func isPureOTP(_ text: String) -> Bool {
        let lower = text.lowercased()
        let hasOTPKeyword = lower.contains("otp") ||
                            lower.contains("verification code") ||
                            lower.contains("security code") ||
                            lower.contains("one time password")
        
        let hasFinancialAction = lower.contains("debited") ||
                                 lower.contains("credited") ||
                                 lower.contains("spent") ||
                                 lower.contains("paid ") ||
                                 lower.contains("charged")
        
        return hasOTPKeyword && !hasFinancialAction
    }
    
    private static func determineType(_ text: String) -> TransactionType? {
        let lower = text.lowercased()
        
        let debitKeywords = [
            "debited", "spent", "paid", "charged", "withdrawn",
            "sent to", "transferred to", "transfer to", "purchase of", "payment to"
        ]
        
        let creditKeywords = [
            "credited", "received", "deposited", "refunded",
            "cashback", "salary", "added to account", "received from"
        ]
        
        let isDebit = debitKeywords.contains { lower.contains($0) }
        let isCredit = creditKeywords.contains { lower.contains($0) }
        
        if isDebit && !isCredit {
            return .expense
        } else if isCredit && !isDebit {
            return .income
        } else if isDebit && isCredit {
            let debitIndex = debitKeywords.compactMap { lower.range(of: $0)?.lowerBound }.min()
            let creditIndex = creditKeywords.compactMap { lower.range(of: $0)?.lowerBound }.min()
            if let firstDebit = debitIndex, let firstCredit = creditIndex {
                return firstDebit < firstCredit ? .expense : .income
            }
            return .expense
        }
        
        return nil
    }
    
    // MARK: - Amount Extraction
    
    private static func extractAmount(_ text: String) -> Double? {
        let patterns = [
            #"(?:INR|Rs\.?|₹|\$|USD|EUR|€|GBP|£)\s*([0-9]+(?:,[0-9]+)*(?:\.[0-9]{1,2})?)"#,
            #"(?:debited|credited|amount)\s*(?:by|for|with|of)?\s*(?:INR|Rs\.?|₹|\$)?\s*([0-9]+(?:,[0-9]+)*(?:\.[0-9]{1,2})?)"#
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]),
               let match = regex.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)),
               match.numberOfRanges > 1,
               let range = Range(match.range(at: 1), in: text) {
                let amountStr = text[range].replacingOccurrences(of: ",", with: "")
                if let val = Double(amountStr) {
                    return val
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Merchant Extraction
    
    private static func extractMerchant(_ text: String, type: TransactionType) -> String {
        let patterns = [
            #"(?:at|towards|info\/|transfer\s+to|paid\s+to|sent\s+to|to)\s+([A-Za-z0-9\.\-\&\'\s]{2,28}?)(?=[,.;]|\s+(?:on|ref|avl|bal|using|via|dated|for)|$)"#,
            #"(?:received\s+from|from)\s+([A-Za-z0-9\.\-\&\'\s]{2,28}?)(?=[,.;]|\s+(?:on|ref|avl|bal|using|via|dated)|$)"#
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]),
               let match = regex.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)),
               match.numberOfRanges > 1,
               let range = Range(match.range(at: 1), in: text) {
                let rawCandidate = String(text[range])
                let candidate = cleanMerchantName(rawCandidate)
                if !candidate.isEmpty && candidate.count > 1 {
                    return candidate
                }
            }
        }
        
        return type == .expense ? "Expense" : "Income"
    }
    
    private static func cleanMerchantName(_ raw: String) -> String {
        var clean = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let prefixes = ["vpa", "upi", "user", "mr", "mrs", "ms"]
        for prefix in prefixes where clean.lowercased().hasPrefix("\(prefix) ") {
            clean = String(clean.dropFirst(prefix.count + 1))
        }
        if let atIndex = clean.firstIndex(of: "@") {
            clean = String(clean[..<atIndex])
        }
        clean = clean.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        return clean.capitalized
    }
    
    // MARK: - Account / Card Hint Extraction
    
    private static func extractAccountHint(_ text: String) -> String? {
        let banks = ["HDFC", "SBI", "ICICI", "Axis", "Kotak", "Chase", "Citi", "Wells Fargo", "Amex", "BoA"]
        var detectedBank: String?
        for bank in banks where text.localizedCaseInsensitiveContains(bank) {
            detectedBank = bank
            break
        }
        
        let digitPattern = #"(?:a\/c|acct|account|card)\s*(?:no\.?)?\s*(?:ending\s*(?:with)?)?[*xX\s]*([0-9]{4})"#
        if let regex = try? NSRegularExpression(pattern: digitPattern, options: [.caseInsensitive]),
           let match = regex.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)),
           match.numberOfRanges > 1,
           let range = Range(match.range(at: 1), in: text) {
            let digits = String(text[range])
            if let bank = detectedBank {
                return "\(bank) (••\(digits))"
            }
            return "••\(digits)"
        }
        
        return detectedBank
    }
    
    // MARK: - Smart Category Inference
    
    private static func inferCategory(merchant: String, fullText: String, type: TransactionType) -> TransactionCategory {
        let combined = "\(merchant) \(fullText)".lowercased()
        
        if type == .income {
            return inferIncomeCategory(combined)
        }
        return inferExpenseCategory(combined)
    }
    
    private static func inferIncomeCategory(_ text: String) -> TransactionCategory {
        if text.contains("salary") || text.contains("payroll") || text.contains("stipend") {
            return .salary
        }
        if text.contains("freelance") || text.contains("upwork") || text.contains("fiverr") {
            return .freelance
        }
        if text.contains("dividend") || text.contains("interest") || text.contains("zerodha") || text.contains("groww") {
            return .investment
        }
        return .other
    }
    
    private static func inferExpenseCategory(_ text: String) -> TransactionCategory {
        let foodKeywords = ["swiggy", "zomato", "starbucks", "mcdonald", "domino", "kfc",
                            "burger", "pizza", "cafe", "restaurant", "dining", "bakery", "subway", "food"]
        if foodKeywords.contains(where: { text.contains($0) }) {
            return .food
        }
        
        let transportKeywords = ["uber", "ola", "rapido", "petrol", "fuel", "shell",
                                 "hpcl", "bpcl", "ioc", "metro", "parking", "flight", "indigo", "irctc"]
        if transportKeywords.contains(where: { text.contains($0) }) {
            return .transport
        }
        
        let shoppingKeywords = ["amazon", "flipkart", "myntra", "zara", "nike", "adidas",
                                "apple store", "walmart", "target", "mart", "supermarket", "blinkit", "zepto"]
        if shoppingKeywords.contains(where: { text.contains($0) }) {
            return .shopping
        }
        
        let billKeywords = ["electricity", "bescom", "airtel", "jio", "vodafone",
                            "broadband", "wifi", "water bill", "gas bill", "utility", "billdesk", "recharge"]
        if billKeywords.contains(where: { text.contains($0) }) {
            return .bills
        }
        
        let entertainmentKeywords = ["netflix", "spotify", "prime video", "hotstar",
                                     "cinema", "pvr", "inox", "bookmyshow", "disney", "youtube", "steam"]
        if entertainmentKeywords.contains(where: { text.contains($0) }) {
            return .entertainment
        }
        
        let healthKeywords = ["pharmacy", "apollo", "hospital", "clinic", "doctor",
                              "medical", "1mg", "pharma", "medplus", "practo"]
        if healthKeywords.contains(where: { text.contains($0) }) {
            return .health
        }
        
        if text.contains("rent") || text.contains("landlord") || text.contains("maintenance") {
            return .rent
        }
        
        return .other
    }
    
    // MARK: - Date Extraction
    
    private static func extractDate(_ text: String) -> Date? {
        let datePatterns = [
            #"([0-3]?[0-9]-[A-Za-z]{3}-(?:20)?[0-9]{2})"#,
            #"([0-3]?[0-9]\/[0-1]?[0-9]\/(?:20)?[0-9]{2})"#,
            #"([0-3]?[0-9][A-Za-z]{3}(?:20)?[0-9]{2})"#
        ]
        
        let formatters: [DateFormatter] = [
            makeDateFormatter("dd-MMM-yy"),
            makeDateFormatter("dd/MM/yy"),
            makeDateFormatter("ddMMMyy")
        ]
        
        for (index, pattern) in datePatterns.enumerated() {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []),
               let match = regex.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)),
               match.numberOfRanges > 1,
               let range = Range(match.range(at: 1), in: text) {
                let dateStr = String(text[range])
                if index < formatters.count, let parsedDate = formatters[index].date(from: dateStr) {
                    return parsedDate
                }
            }
        }
        
        return nil
    }
    
    private static func makeDateFormatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter
    }
}
