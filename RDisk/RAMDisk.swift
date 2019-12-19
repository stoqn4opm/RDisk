//
//  RAMDisk.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 19/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - Model Definition

class RAMDisk {
    
    /// The size of this ram disk in MB.
    let capacity: Float
    
    /// The name of this ram disk.
    let name: String
    
    /// The file system that this drive is formatted into.
    let fileSystem: String
    
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
    init(capacity: Float, name: String, fileSystem: String) {
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
        return RAMDisk.eraseDisk(withID: id, name: name, fileSystem: fileSystem)
    }
    
    /// Ejects this ram disk from Finder, destroying all things stored in it.
    ///
    /// - Returns: `true` if eject was successful, `false` otherwise.
    @discardableResult func eject() -> Bool {
        guard let id = identifier else { return false }
        return RAMDisk.ejectDisk(withID: id)
    }
}
