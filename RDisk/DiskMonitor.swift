//
//  DiskMonitor.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 23/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import DiskArbitration

// MARK: - Getting Instance

extension DiskMonitor {
    
    /// Shared instance that posts updates about disks.
    static let shared = DiskMonitor()
}

// MARK: - Class Definition

final class DiskMonitor {
    
    /// Retain handle for the `DiskArbitration` session that provides disk info from the operating system.
    var session: DASession
    
    private init() {
        session = DASessionCreate(kCFAllocatorDefault)!
    }
 
    deinit {
        stopMonitoring()
    }
}

// MARK: - Actions

extension DiskMonitor {
    
    func startMonitoring() {
        DARegisterDiskAppearedCallback(session, kDADiskDescriptionMatchVolumeMountable.takeUnretainedValue(), { disk, pointer in
            //            let wholeDisk = DADiskCopyWholeDisk(disk)
            //            print(wholeDisk) // <DADisk 0x600000c9ccf0 [0x7fff89d3d090]>{id = /dev/disk0}
            
            guard let description = DADiskCopyDescription(disk) as? [String: AnyObject] else { return }
            print(description["DAVolumeName"])
            
            print("\n ---------- \n")
            
        }, nil)
        
        
        DARegisterDiskDisappearedCallback(session, nil, {disk, pointer in
            
            let wholeDisk = DADiskCopyWholeDisk(disk)
            print(wholeDisk) // <DADisk 0x600000c9ccf0 [0x7fff89d3d090]>{id = /dev/disk0}
            
            guard let description = DADiskCopyDescription(disk) as? [String: AnyObject] else { return }
            print(description)
            
            
        }, nil)
        
        DARegisterDiskDescriptionChangedCallback(session, nil, nil, {disk, keys, context in
            guard let description = DADiskCopyDescription(disk) as? [String: AnyObject] else { return }
            print(description["DAVolumeName"]!)
        }, nil)
        
        DASessionSetDispatchQueue(session, DispatchQueue.main)
    }
    
    func stopMonitoring() {
        DASessionSetDispatchQueue(session, nil)
    }
}
