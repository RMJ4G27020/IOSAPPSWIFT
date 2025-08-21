//
//  String+Extensions.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: - Validation Extensions
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneRegex = #"^[\+]?[1-9][\d]{0,15}$"#
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    var isValidURL: Bool {
        guard let url = URL(string: self) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    // MARK: - Formatting Extensions
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var capitalized: String {
        return self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
    
    // MARK: - Utility Extensions
    var isNotEmpty: Bool {
        return !self.trimmed.isEmpty
    }
    
    func truncated(limit: Int, trailing: String = "...") -> String {
        guard self.count > limit else { return self }
        return String(self.prefix(limit)) + trailing
    }
    
    // MARK: - Security Extensions
    var masked: String {
        guard self.count > 4 else { return String(repeating: "*", count: self.count) }
        let start = String(self.prefix(2))
        let end = String(self.suffix(2))
        let middle = String(repeating: "*", count: self.count - 4)
        return start + middle + end
    }
}

// MARK: - UIApplication Extension for URL validation
import UIKit

private extension UIApplication {
    static var shared: UIApplication {
        guard let shared = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication else {
            fatalError("No access to UIApplication")
        }
        return shared
    }
}
