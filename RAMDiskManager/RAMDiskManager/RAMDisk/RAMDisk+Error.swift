//
//  RAMDisk+Error.swift
//  RAMDiskManager
//
//  Created by Stoyan Stoyanov on 24/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - Errors

extension RAMDisk {
    
    /// All possible errors that can occur with `RAMDisk`s.
    public enum Error: Swift.Error {
        
        /// Error that can occur during space allocation for a given `RAMDisk`.
        case allocationError(String?)
        
        /// Error that can occur during formatting of a given `RAMDisk`.
        case formattingError(String?)
        
        /// Error that can occur during ejecting of a given `RAMDisk`.
        case ejectingError(String?)
    }
}

// MARK: - Associated Value

extension RAMDisk.Error {
    
    /// Associated value easy access.
    public var associatedValue: String? {
        
        switch self {
        case .allocationError(let value): return value
        case .formattingError(let value): return value
        case .ejectingError(let value): return value
        }
    }
}
