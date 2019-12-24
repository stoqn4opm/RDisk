//
//  DiskMonitor.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 23/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import DiskArbitration


// MARK: - DiskMonitorDelegate

/// Requirements for being a delegate to a `DiskMonitor`.
protocol DiskMonitorDelegate: AnyObject {
    
    /// Called when a raw disk appears.
    ///
    /// - Parameters:
    ///   - monitor: The monitor that found it.
    ///   - diskAppeared: The raw `DADisk`.
    func rawDiskMonitor(_ monitor: DiskMonitor, diskAppeared: DADisk)
    
    /// Called when a raw disk disappears.
    ///
    /// - Parameters:
    ///   - monitor: The monitor that found it.
    ///   - diskAppeared: The raw `DADisk`.
    func rawDiskMonitor(_ monitor: DiskMonitor, diskDisappeared: DADisk)
    
    /// Called when a raw disk was renamed.
    ///
    /// - Parameters:
    ///   - monitor: The monitor that found it.
    ///   - diskAppeared: The raw `DADisk`.
    func rawDiskMonitor(_ monitor: DiskMonitor, diskRenamed: DADisk)
}

// MARK: - Notifications

extension Notification.Name {
    
    /// Posted by the `DiskMonitor` when a disk appears. The notification's object is the raw `DADisk`.
    static let rawDiskAppeared = Notification.Name("DiskMonitor.rawDiskAppeared")
    
    /// Posted by the `DiskMonitor` when a disk dissapears. The notification's object is the raw `DADisk`.
    static let rawDiskDisappeared = Notification.Name("DiskMonitor.rawDiskDisappeared")
    
    /// Posted by the `DiskMonitor` when a disk gets renamed. The notification's object is the raw `DADisk`.
    static let rawDiskRenamed = Notification.Name("DiskMonitor.rawDiskRenamed")
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
    
    /// The delegate object that gets notified in the case of new discoveries.
    weak var delegate: DiskMonitorDelegate?
    
    
    /// Creates a new disk monitor with an optional delegate passed.
    ///
    /// `DiskMonitor` is a simple class that acts as a wrapper around the `DiskArbritation` framework from Apple that notifies
    /// about changes with disk drives.
    ///
    /// - Parameter delegate: The delegate object that you want notified in the case of new discoveries.
    init(withDelegate delegate: DiskMonitorDelegate? = nil) {
        session = DASessionCreate(kCFAllocatorDefault)!
        self.delegate = delegate
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(rawDiskAppeared(_:)), name: .rawDiskAppeared, object: nil)
        DARegisterDiskAppearedCallback(session, kDADiskDescriptionMatchVolumeMountable.takeUnretainedValue(), { disk, pointer in
            NotificationCenter.default.post(name: .rawDiskAppeared, object: disk, userInfo: nil)
        }, nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(rawDiskDisappeared(_:)), name: .rawDiskDisappeared, object: nil)
        DARegisterDiskDisappearedCallback(session, nil, {disk, pointer in
            NotificationCenter.default.post(name: .rawDiskDisappeared, object: disk, userInfo: nil)
        }, nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(rawDiskRenamed(_:)), name: .rawDiskRenamed, object: nil)
        DARegisterDiskDescriptionChangedCallback(session, nil, nil, {disk, keys, context in
            NotificationCenter.default.post(name: .rawDiskRenamed, object: disk, userInfo: nil)
        }, nil)
        
        DASessionSetDispatchQueue(session, DispatchQueue.main)
    }
    
    /// Stops the currently launched disk monitoring.
    ///
    /// You can start it again with `startMonitoring()`.
    func stopMonitoring() {
        NotificationCenter.default.removeObserver(self, name: .rawDiskAppeared, object: nil)
        NotificationCenter.default.removeObserver(self, name: .rawDiskDisappeared, object: nil)
        NotificationCenter.default.removeObserver(self, name: .rawDiskRenamed, object: nil)
        
        DASessionSetDispatchQueue(session, nil)
    }
}

// MARK: - Delegate Helpers

extension DiskMonitor {
    
    @objc private func rawDiskAppeared(_ notification: Notification) {
        let disk = notification as! DADisk
        delegate?.rawDiskMonitor(self, diskAppeared: disk)
    }
    
    @objc private func rawDiskDisappeared(_ notification: Notification) {
        let disk = notification as! DADisk
        delegate?.rawDiskMonitor(self, diskDisappeared: disk)
    }
    
    @objc private func rawDiskRenamed(_ notification: Notification) {
        let disk = notification as! DADisk
        delegate?.rawDiskMonitor(self, diskRenamed: disk)
    }
}
