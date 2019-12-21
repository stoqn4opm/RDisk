//
//  RAMDisk.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 19/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - All Disks Reference

extension RAMDisk {
    
    /// Holds reference to all currently mounted ram disks.
    static var allMountedDisks: [RAMDisk] = []
}

// MARK: - Notifications

extension Notification.Name {
    
    /// Posted by a disk who have just been created. Object of notification is the created disk.
    static let diskCreated = Notification.Name("RAMDiskCreated")
    
    /// Posted by a disk who have just been ejected. Object of notification is the ejected disk.
    static let diskEjected = Notification.Name("RAMDiskEjected")
}

// MARK: - Model Definition

class RAMDisk {
    
    /// The size of this ram disk in MB.
    let capacity: Float
    
    /// The name of this ram disk.
    let name: String
    
    /// The file system that this drive is formatted into.
    let fileSystem: FileSystem
    
    /// The "hardware" identifier of this disk.
    /// Set after the disk is created.
    private(set) var identifier: String?
    
    
    /// Creates a new RAMDisk object with a given parameters.
    ///
    /// In order the create the actual RAMDisk you have to call `create()` on this object.
    ///
    /// - Parameters:
    ///   - capacity: The size of this ram disk in MB.
    ///   - name: The name of this ram disk.
    ///   - fileSystem: The file system that this drive is formatted into.
    init(capacity: Float, name: String, fileSystem: FileSystem) {
        self.capacity = capacity
        self.name = name
        self.fileSystem = fileSystem
    }
}

// MARK: - Actions

extension RAMDisk {
    
    /// Creates the ram disk and mounts it in the file system.
    ///
    /// - Returns: `true` if operation was successfull, `false` otherwise.
    @discardableResult func create() -> Bool {
        guard let id = RAMDisk.allocateRAMRegion(withSize: capacity) else { return false }
        identifier = id
        
        guard RAMDisk.eraseDisk(withID: id, name: name, fileSystem: fileSystem.rawValue) else { return false }
        RAMDisk.allMountedDisks.append(self)
        NotificationCenter.default.post(name: .diskCreated, object: self)
        return true
    }
    
    /// Ejects this ram disk from Finder, destroying all things stored in it.
    ///
    /// - Returns: `true` if eject was successful, `false` otherwise.
    @discardableResult func eject() -> Bool {
        guard let id = identifier else { return false }
        
        guard RAMDisk.ejectDisk(withID: id) else { return false }
        guard let index = RAMDisk.allMountedDisks.firstIndex(of: self) else { return false }
        RAMDisk.allMountedDisks.remove(at: index)
        NotificationCenter.default.post(name: .diskEjected, object: self)
        return true
    }
}

// MARK: - Equatable

extension RAMDisk: Equatable {
    static func == (lhs: RAMDisk, rhs: RAMDisk) -> Bool { lhs === rhs }
}
