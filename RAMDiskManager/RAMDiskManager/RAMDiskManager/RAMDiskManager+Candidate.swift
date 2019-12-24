//
//  RAMDiskManager+Candidate.swift
//  RAMDiskManager
//
//  Created by Stoyan Stoyanov on 24/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import DiskUtil
import DiskArbitration


// MARK: - RAMDisk Candidate

extension RAMDiskManager {
    
    /// Container holding data from which a ram disk is in a process of creation by the `RAMDiskManager`.
    struct Candidate: Hashable {
        
        /// Stores the name of the drive that `RamDiskManager` is creating.
        let name: String
        
        /// Stores the file system of the drive that `RamDiskManager` is creating.
        let fileSystem: FileSystem
        
        /// Stores the capacity of the drive that `RamDiskManager` is creating.
        let capacity: Int
        
        /// Stores the device path of the drive that `RamDiskManager` is creating.
        let devicePath: String
    }
}

// MARK: - Recognition

extension RAMDiskManager.Candidate {
    
    /// Gives whether a given raw disk, could potentially be describing this `RAMDiskManager.Candidate`.
    ///
    /// - Parameter disk: The raw `DADisk` disk that you want to test.
    func isMatchedByRawDisk(_ disk: DADisk) -> Bool {
        guard name == disk.volumeName else { return false }
        guard let mediaSize = disk.mediaSize else { return false }
        
        let percentOfSize = 5 * mediaSize / 100
        guard abs(capacity * .countOfBytesIn1MB - mediaSize) < percentOfSize else { return false }
        
        return true
    }
}
