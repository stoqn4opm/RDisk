//
//  RAMDisk.swift
//  RAMDiskManager
//
//  Created by Stoyan Stoyanov on 24/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import DiskArbitration
import DiskUtil


/// Class that holds info about a single `RAMDisk` created by RDisk.
///
/// It acts as a wrapper around `DADisk` from `DiskArbitration` framework.
public class RAMDisk {
    
    /// The raw `DADisk` object from Apple's `DiskArbitration` framework representing our ram disk.
    var rawDisk: DADisk
    
    /// The device path of the created "Disk Image" acting as a whole disk to the current formatted ram disk.
    public let devicePath: String
    
    init(devicePath: String, rawDisk: DADisk) {
        self.devicePath = devicePath
        self.rawDisk = rawDisk
    }
}

// MARK: - Actions

extension RAMDisk {
    
    /// Ejects this disk, making the RAMDiskManager post notification about it being removed.
    ///
    /// - Parameter completion: Completion block executed on the main thread.
    /// - Parameter error: Error parameter populated if error has occured during the process.
    public func eject(withCompletion completion: ((_ error: Error?) -> ())? = nil) {
        DiskUtil.ejectDisk(withDevicePath: devicePath) { (responce) in
            DispatchQueue.main.async {        
                guard responce.error.isEmpty else { completion?(.ejectingError(responce.error)); return }
                completion?(nil)
            }
        }
    }
}

// MARK: - Accessors

extension RAMDisk {
    
    /// The name of this ram disk.
    public var name: String { rawDisk.volumeName ?? "" }
    
    /// The unique identifier of this disk, given by the operating system.
    public var identifier: String { rawDisk.mediaUUID ?? "" }
    
    /// The size of this ram disk in MB.
    public var capacity: Int { rawDisk.mediaSize ?? 0 }
    
    /// The file system that this drive is formatted into.
    public var fileSystem: FileSystem { .apfs }
    
    /// The bsd name of this ram disk.
    public var bsdName: String { rawDisk.mediaBSDName ?? ""}
}

// MARK: - CustomStringConvertible

extension RAMDisk: CustomStringConvertible {
    
    public var description: String {
        "\nRAMDisk: name - '\(name)', bsdName - '\(bsdName)', identifier - '\(identifier)', device path - '\(devicePath)', capacity - '\(ByteCountFormatter().string(fromByteCount: Int64(capacity)))', file system - '\(fileSystem)'"
    }
}
