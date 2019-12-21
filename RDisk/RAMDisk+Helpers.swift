//
//  RAMDisk+Helpers.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 19/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - Block Calculations

extension RAMDisk {
    
    /// The count of blocks in 1MB. Helpful when trying to calculate how many block you will have for specific capacity.
    static let blockCountInMegabyte: Float = 2048
}

// MARK: - Workers

extension RAMDisk {
    
    /// Allocates a ram region with a given size in megabytes.
    ///
    /// - Parameter size: The size of the ram region you want in MB.
    /// Returns: The "hardware" `id` of the disk.
    static func allocateRAMRegion(withSize size: Float) -> String? {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/hdid")
        task.arguments = ["-nomount", "ram://\(2048 * size)"]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.waitUntilExit()
        task.launch()
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        let output = String(decoding: outputData, as: UTF8.self)
        let error = String(decoding: errorData, as: UTF8.self)
        
        guard error.isEmpty else { return nil }
        return output.trimTrailingWhitespaces()
    }
    
    /// Erases an allocated RAM region with a given id to a specific filesystem and mounts it.
    ///
    /// - Parameters:
    ///   - id: The id of the RAM region.
    ///   - name: The name you want set to your new RAM Disk
    ///   - fileSystem: the file system in which you want your ram region formatted.
    /// - Returns: `true` if erase was successful, `false` if error had occured.
    @discardableResult static func eraseDisk(withID id: String, name: String, fileSystem: String) -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/diskutil")
        
        task.arguments = ["erasedisk", fileSystem, name, id]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.waitUntilExit()
        
        task.launch()
        
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let error = String(decoding: errorData, as: UTF8.self)
        return error.isEmpty
    }
    
    /// Ejects a ram disk from Finder, destroying all things stored in it.
    ///
    /// - Parameter id: The id of the disk that you want ejected.
    /// - Returns: `true` if eject was successful, `false` otherwise.
    @discardableResult static func ejectDisk(withID id: String) -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/diskutil")
        
        task.arguments = ["eject", id]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.waitUntilExit()
        
        task.launch()
        
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let error = String(decoding: errorData, as: UTF8.self)
        return error.isEmpty
    }
}

// MARK: - Helpers

extension Float {
    
    /// Calculates how many blocks you will need if you want to create a ram disk with capacity in megabytes equals to this number.
    fileprivate var blocksCount: Int { Int(self * RAMDisk.blockCountInMegabyte) }
}

extension String {
    
    /// Removes the whitespace from the end of the string.
    func trimTrailingWhitespaces() -> String {
        replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
}
