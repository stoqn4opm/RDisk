//
//  String+Helper.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 21/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Cocoa


// MARK: - Styling Helpers

extension String {
    
    /// Returns this string as `NSAttributedString`starting with a green checkmark and a tab.
    var checkmarked: NSAttributedString {
        let result = NSMutableAttributedString(string: "􀆅", attributes: [NSAttributedString.Key.foregroundColor : NSColor.green])
        result.append(NSAttributedString(string: "\t\(self)"))
        return result
    }
    
    /// Returns this string as `NSAttributedString`starting with a red cross and a tab.
    var crossed: NSAttributedString {
        let result = NSMutableAttributedString(string: "􀆄", attributes: [NSAttributedString.Key.foregroundColor : NSColor.red])
        result.append(NSAttributedString(string: "\t\(self)"))
        return result
    }
}

// MARK: - Trimming

extension String {
    
    /// Removes the whitespace from the end of the string.
    func trimTrailingWhitespaces() -> String {
        replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
}
