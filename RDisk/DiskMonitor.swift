//
//  DiskMonitor.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 23/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import DiskArbitration


// MARK: - Notifications

extension Notification.Name {
    
    /// Posted by the `DiskMonitor` when a disk appears. The notification's object is the raw `DADisk`.
    static let rawDiskAppeared = Notification.Name("DiskMonitor.rawDiskAppeared")
    
    /// Posted by the `DiskMonitor` when a disk dissapears. The notification's object is the raw `DADisk`.
    static let rawDiskDisappeared = Notification.Name("DiskMonitor.rawDiskDisappeared")
    
    /// Posted by the `DiskMonitor` when a disk gets renamed. The notification's object is the raw `DADisk`.
    static let rawDiskRenamed = Notification.Name("DiskMonitor.rawDiskRenamed")
}

// MARK: - Getting Instance

extension DiskMonitor {
    
    /// Shared instance that posts updates about disks.
    static let shared = DiskMonitor()
}

// MARK: - Class Definition

/// Simple class that acts as a wrapper around the `DiskArbritation` framework from Apple that notifies
/// about changes with disk drives.
///
/// In order to start the monitoring process call `startMonitoring()`, and the DiskMonitor will start
/// to post notifications with the raw `DADisk`s on disk appearing/ejecting/renaming.
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
    
    /// Makes the disk monitor start monitor what disks are added/ejected/renamed.
    ///
    /// It posts notifications for adding/ejecting/renaming `.rawDiskAppeared`/`.rawDiskDisappeared`/`.rawDiskRenamed`.
    ///
    /// You can stop the monitoring process with `stopMonitoring()`.
    func startMonitoring() {
        DARegisterDiskAppearedCallback(session, kDADiskDescriptionMatchVolumeMountable.takeUnretainedValue(), { disk, pointer in
            NotificationCenter.default.post(name: .rawDiskAppeared, object: disk, userInfo: nil)
        }, nil)
        
        DARegisterDiskDisappearedCallback(session, nil, {disk, pointer in
            NotificationCenter.default.post(name: .rawDiskDisappeared, object: disk, userInfo: nil)
        }, nil)
        
        DARegisterDiskDescriptionChangedCallback(session, nil, nil, {disk, keys, context in
            NotificationCenter.default.post(name: .rawDiskRenamed, object: disk, userInfo: nil)
        }, nil)
        
        DASessionSetDispatchQueue(session, DispatchQueue.main)
    }
    
    /// Stops the currently launched disk monitoring.
    ///
    /// You can start it again with `startMonitoring()`.
    func stopMonitoring() {
        DASessionSetDispatchQueue(session, nil)
    }
}
