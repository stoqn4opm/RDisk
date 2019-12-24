//
//  RAMDiskManager.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 24/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation
import DiskUtil
import DiskMonitor


// MARK: - Notification

extension Notification.Name {
    
    /// Posted when there are changes with the mounted ram disks array.
    ///
    /// To be specific, when a disk is added/ejected/renamed. The object of this notification
    /// is the RamDiskManager that is keeping track disks.
    public static let ramDisksWereUpdated = Notification.Name("RAMDiskManager.ramDisksWereUpdated")
}

// MARK: - Shared Instance

extension RAMDiskManager {
    
    /// Shared instance of `RAMDiskManager`.
    ///
    /// No other instances should be created.
    public static let shared = RAMDiskManager()
}

// MARK: - Class Definition

/// Class that deals with creating/ejecting ram disks,
/// notifying the remaining of the app about creating/ejecting/renaming
/// of ram disks.
///
/// To access its functionality, use the `.shared` instance.
public final class RAMDiskManager {
    
    /// Object that handles the notifications from the operating system about all disks.
    let diskMonitor: DiskMonitor
    
    /// Property that holds data needed for creation of a new ram disk while we wait for the operating system
    /// To reply with `DADisk` object, representing the newly created ram disk.
    var diskCreatingCompletions: [Candidate: (RAMDisk?, RAMDisk.Error?) -> ()] = [:]
    
    /// Property that holds all currently mounted ram disks. Each time this array changes,
    /// a `.ramDisksWereUpdated` notification is posted.
    public var mountedRAMDisks: [RAMDisk] = [] { didSet { NotificationCenter.default.post(name: .ramDisksWereUpdated, object: self) } }
    
    /// Do not use it, use `RAMDiskManager.shared` instead.
    private init() {
        diskMonitor = DiskMonitor()
        diskMonitor.delegate = self
        diskMonitor.startMonitoring()
    }
    
    deinit {
        diskMonitor.stopMonitoring()
    }
}

// MARK: - Interface

extension RAMDiskManager {
    
    /// Creates a new `RAMDisk` with given parameters.
    ///
    /// This is the only way to create new `RAMDisk`s.
    ///
    /// This method first allocates appropriate memory region, then formats it
    /// and only after the operating system gives raw representation of it in the form of`DADisk`
    /// calls the completion handler with the ready object.
    ///
    /// A `.ramDisksWereUpdated` notification gets posted as a result of modifying the `mountedRAMDisks` array.
    ///
    /// - Parameters:
    ///   - name: The desired name of the ram disk.
    ///   - fileSystem: The desired file system of the ram disk.
    ///   - capacity: The desired capacity of the ram disk.
    ///   - completion: Completion block executed on the main thread.
    ///   - disk: The ready ram disk, in case the process finishes successfully.
    ///   - error: Parameter populated if error has occured during the process.
    public func createRAMDisk(name: String, fileSystem: FileSystem, capacity: Int, completion: @escaping (_ disk: RAMDisk?, _ error: RAMDisk.Error?) -> ()) {
        DiskUtil.createDiskImage(withSize: capacity) { [weak self] (responce) in
            guard responce.error.isEmpty else { completion(nil, .allocationError(responce.error)); return }
            guard responce.output.isEmpty == false else { completion(nil, .allocationError(nil)); return }
            
            let devicePath = responce.output
            let candidate = Candidate(name: name, fileSystem: fileSystem, capacity: capacity, devicePath: devicePath)
            self?.diskCreatingCompletions[candidate] = completion
            
            DiskUtil.eraseDisk(withDevicePath: devicePath, name: name, fileSystem: fileSystem) { (responce) in
                guard responce.error.isEmpty == false else {return }
                completion(nil, .formattingError(responce.error))
                self?.diskCreatingCompletions[candidate] = nil
            }
        }
    }
    
    /// Tries to complete the creation of a ramdisk, started from `RAMDiskManager`'s `createRAMDisk(name:,fileSystem:,capacity:,completion)`.
    ///
    /// This method gets invoked after the operating system replies with a `DADisk` that could potentially be
    /// one that is representing some that we expect.
    /// 
    /// - Parameter disk: The raw disk that the operating system gives, that could
    /// potentially be the disk we are looking for.
    ///
    /// - Returns: `true` if `RAMDiskManager` was expecting this `DADisk`, `false`
    /// if it is just any other disk.
    private func tryToFinishCreationOfRAMDisks(withRawDisk disk: DADisk) -> Bool {
        var result = false
        
        diskCreatingCompletions.keys.forEach { candidate in
            guard candidate.isMatchedByRawDisk(disk) else { return }
            
            if let index = mountedRAMDisks.firstIndex(where: { $0.identifier == disk.mediaUUID }) {
                mountedRAMDisks.remove(at: index)
            }
            
            let ramDisk = RAMDisk(devicePath: candidate.devicePath, rawDisk: disk)
            mountedRAMDisks.append(ramDisk)
            diskCreatingCompletions[candidate]?(ramDisk, nil)
            diskCreatingCompletions[candidate] = nil
            result = true
        }
        
        return result
    }
    
    /// Ejects a ram disk by invoking it's eject method.
    ///
    /// A `.ramDisksWereUpdated` notification gets posted as a result of modifying the `mountedRAMDisks` array.
    ///
    /// - Parameters:
    ///   - ramDisk: The ram disk you want ejected.
    ///   - completion: Completion block executed on the main thread.
    ///   - error: Parameter populated if error has occured during the process.
    public func ejectRAMDisk(_ ramDisk: RAMDisk, completion: @escaping (_ error: RAMDisk.Error?) -> ()) {
        ramDisk.eject(withCompletion: completion)
    }
}

// MARK: - DiskMonitorDelegate

extension RAMDiskManager: DiskMonitorDelegate {
    
    public func rawDiskMonitor(_ monitor: DiskMonitor, diskAppeared disk: DADisk) {
        guard disk.isRAMDisk else { return }
        guard tryToFinishCreationOfRAMDisks(withRawDisk: disk) == false else { return }
    }
    
    public func rawDiskMonitor(_ monitor: DiskMonitor, diskDisappeared disk: DADisk) {
        guard let index = mountedRAMDisks.firstIndex(where: {$0.rawDisk == disk }) else { return }
        mountedRAMDisks.remove(at: index)
    }
    
    public func rawDiskMonitor(_ monitor: DiskMonitor, diskRenamed disk: DADisk) {
        guard let index = mountedRAMDisks.firstIndex(where: {$0.rawDisk == disk }) else { return }
        mountedRAMDisks[index].rawDisk = disk
        NotificationCenter.default.post(name: .ramDisksWereUpdated, object: self)
    }
}


extension Int {
    
    /// = 1 000 000
    static var countOfBytesIn1MB: Int { 1_000_000 }
}
