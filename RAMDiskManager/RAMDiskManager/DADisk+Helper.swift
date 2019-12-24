//
//  DADisk+Helper.swift
//  RAMDiskManager
//
//  Created by Stoyan Stoyanov on 24/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - RAM Disk Check

extension DADisk {
    
    /// A simple check whether this `DADisk` could potentially be representing a ram disk created by RDisk.
    var isRAMDisk: Bool {
        guard deviceModel == "Disk Image" else { return false }
        guard deviceProtocol == "Virtual Interface" else { return false }
        guard isRemovable == true else { return false }
        guard busName == "/" else { return false }
        guard busPath == "IODeviceTree:/" else { return false }
        guard mediaUUID == volumeUUID else { return false }
        guard deviceVendor == "Apple" else { return false }
        guard isVolumeNetwork == false else { return false }
        
        return true
    }
}
