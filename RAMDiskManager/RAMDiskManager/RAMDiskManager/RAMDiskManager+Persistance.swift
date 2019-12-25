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
    public func prepareShouldStoreDiskSetupPersistance() {
        UserDefaults.standard.register(defaults: ["shouldStoreDiskSetup" : shouldStoreDiskSetup])
        shouldStoreDiskSetup = UserDefaults.standard.bool(forKey: "shouldStoreDiskSetup")
    }
    
    /// Takes all currently mounted disks and stores them in user defaults if `RAMDisk.shouldStoreDiskSetup` is true.
    ///
    /// Use `restoreDiskSetup()` to read them back.
    func storeDiskSetupIfNeeded() {
        guard shouldStoreDiskSetup else { return }
        storeDiskSetup()
    }
    
    /// Takes all currently mounted disks and stores them in user defaults.
    ///
    /// Use `restoreDiskSetup()` to read them back.
    func storeDiskSetup() {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: mountedRAMDisks.map { $0.restorationData }, requiringSecureCoding: false) else { return }
        UserDefaults.standard.setValue(data, forKey: "disksRestoreData")
        UserDefaults.standard.synchronize()
    }
    
    /// Restores previously mounted disks from a state save in user defaults.
    ///
    /// Use `storeDiskSetup()` to save them to user defaults.
    public func restoreDiskSetup() {
        guard let data = UserDefaults.standard.value(forKey: "disksRestoreData") as? Data else { return }
        guard let disks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [RAMDiskRestorationData] else { return }
        restoreData = disks
    }
    
    /// Deletes previously stored mounted disks in user defaults.
    ///
    /// Use `storeDiskSetup()` to save them to user defaults again.
    func clearStoredDiskSetup() {
        UserDefaults.standard.setValue(nil, forKey: "disksRestoreData")
        UserDefaults.standard.synchronize()
    }
}

