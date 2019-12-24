//
//  Int+Helper.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 22/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - Formatting

extension Int {
 
    /// Returns a string representation of this number, generated with `ByteCountFormatter`
    var byteCountFormatted: String {
        let formatter = ByteCountFormatter()
        return formatter.string(fromByteCount: Int64(self * 1_000_000))
    }
}
