//
//  RAMDisk+RestorationData.swift
//  RAMDiskManager
//
//  Created by Stoyan Stoyanov on 24/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import DiskUtil


// MARK: - Restoration Data

extension RAMDisk {
    
    /// Information that gets persisted in `UserDefaults`. It holds helpful data that can be used to recognize which `DADisk` corresponds to this `RAMDisk` on next launch.
    var restorationData: RAMDiskRestorationData {
        RAMDiskRestorationData(name: name, identifier: identifier, capacity: capacity, fileSystem: fileSystem, bsdName: bsdName, devicePath: devicePath)
    }
}

// MARK: - Restoration Data Container

/// Class holding information helpful during restoration of previously set ram drive setups.
class RAMDiskRestorationData: NSObject, NSCoding {
    
    /// The name of this ram disk.
    var name: String
    
    /// The unique identifier of this disk, given by the operating system.
    var identifier: String
    
    /// The size of this ram disk in MB.
    var capacity: Int
    
    /// The file system that this drive is formatted into.
    var fileSystem: FileSystem
    
    /// The bsd name of this ram disk.
    var bsdName: String
    
    /// The device path of this ram disk.
    var devicePath: String
    
    /// Creates a simple container holding information helpful during restoration of previously set ram drive setups.
    ///
    /// - Parameters:
    ///   - name: The name of this ram disk.
    ///   - identifier: The unique identifier of this disk, given by the operating system.
    ///   - capacity: The size of this ram disk in MB.
    ///   - fileSystem: The file system that this drive is formatted into.
    ///   - bsdName: The bsd name of this ram disk.
    ///   - devicePath: The device path of this ram disk.
    init(name: String, identifier: String, capacity: Int, fileSystem: FileSystem, bsdName: String, devicePath: String) {
        self.name = name
        self.identifier = identifier
        self.capacity = capacity
        self.fileSystem = fileSystem
        self.bsdName = bsdName
        self.devicePath = devicePath
    }
    
    required init?(coder: NSCoder) {

        guard let name          = coder.decodeObject(forKey: "name") as? String else { return nil }
        guard let identifier    = coder.decodeObject(forKey: "identifier") as? String else { return nil }
        guard let rawFileSystem = coder.decodeObject(forKey: "fileSystem") as? String else { return nil }
        guard let bsdName       = coder.decodeObject(forKey: "bsdName") as? String else { return nil }
        guard let devicePath    = coder.decodeObject(forKey: "devicePath") as? String else { return nil }
        guard let fileSystem = FileSystem(rawValue: rawFileSystem) else { return nil }
        let capacity = coder.decodeInteger(forKey: "capacity")
        
        
        self.name = name
        self.identifier = identifier
        self.capacity = capacity
        self.fileSystem = fileSystem
        self.bsdName = bsdName
        self.devicePath = devicePath
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name,          forKey: "name")
        coder.encode(identifier,    forKey: "identifier")
        coder.encode(capacity,      forKey: "capacity")
        coder.encode(fileSystem.rawValue,    forKey: "fileSystem")
        coder.encode(bsdName,       forKey: "bsdName")
        coder.encode(devicePath,    forKey: "devicePath")
    }
}

// MARK: - Helpers

extension RAMDiskRestorationData {
    
    func isMatchedByRawDisk(_ rawDisk: DADisk) -> Bool {
        name == rawDisk.volumeName &&
        identifier == rawDisk.volumeUUID &&
        capacity == rawDisk.mediaSize &&
        // fileSystem == rawDisk. &&
        bsdName == rawDisk.mediaBSDName
    }
}

// MARK: - CustomStringConvertible

extension RAMDiskRestorationData {
    
    override var description: String {
        "RAMDiskRestorationData: name - '\(name)', identifier - '\(identifier)', capacity - '\(capacity)', fileSystem - '\(fileSystem)', bsdName - '\(bsdName)', devicePath - '\(devicePath)'"
    }
}
