//
//  RAMDiskManager+Persistance.swift
//  RAMDiskManager
//
//  Created by Stoyan Stoyanov on 24/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - Persistance

extension RAMDiskManager {
    
    /// Prepares user defaults for storing and disk setup saves and restores.
    ///
    /// On first launch, it populates the key `"shouldStoreDiskSetup"` appropriately.
    public static func prepareShouldStoreDiskSetupPersistance() {
        UserDefaults.standard.register(defaults: ["shouldStoreDiskSetup" : shouldStoreDiskSetup])
        shouldStoreDiskSetup = UserDefaults.standard.bool(forKey: "shouldStoreDiskSetup")
    }
    
    /// Controls whether the currently mounted disks setup should be restored on next launch or not.
    ///
    /// This method only recreats the "stored" disks, no data will be recovered from before.
    public static var shouldStoreDiskSetup = false {
        didSet {
            UserDefaults.standard.set(shouldStoreDiskSetup, forKey: "shouldStoreDiskSetup")
            UserDefaults.standard.synchronize()
            
            if shouldStoreDiskSetup {
                storeDiskSetup()
            } else {
                clearStoredDiskSetup()
            }
        }
    }
    
    /// Takes all currently mounted disks and stores them in user defaults if `RAMDisk.shouldStoreDiskSetup` is true.
    ///
    /// Use `restoreDiskSetup()` to read them back.
    static func storeDiskSetupIfNeeded() {
        guard shouldStoreDiskSetup else { return }
        storeDiskSetup()
    }
    
    /// Takes all currently mounted disks and stores them in user defaults.
    ///
    /// Use `restoreDiskSetup()` to read them back.
    static func storeDiskSetup() {
//        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: allMountedDisks, requiringSecureCoding: false) else { return }
//        UserDefaults.standard.setValue(data, forKey: "disks")
//        UserDefaults.standard.synchronize()
    }
    
    /// Restores previously mounted disks from a state save in user defaults.
    ///
    /// Use `storeDiskSetup()` to save them to user defaults.
    public static func restoreDiskSetup() {
//        guard let data = UserDefaults.standard.value(forKey: "disks") as? Data else { return }
//        guard let disks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [RAMDisk] else { return }
//        disks.forEach { $0.create() }
    }
    
    /// Deletes previously stored mounted disks in user defaults.
    ///
    /// Use `storeDiskSetup()` to save them to user defaults again.
    static func clearStoredDiskSetup() {
        UserDefaults.standard.setValue(nil, forKey: "disks")
        UserDefaults.standard.synchronize()
    }
}

