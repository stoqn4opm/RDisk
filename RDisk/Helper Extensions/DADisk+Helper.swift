//
//  DADisk+Helper.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 23/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import DiskArbitration


// MARK: - Helpers

extension DADisk {
    
    /// The whole disk containing this one.
    var wholeDiskName: DADisk? { DADiskCopyWholeDisk(self) }
    
    /// Gives a detailed description about this raw `DADisk` with the help of `DADiskCopyDescription` function.
    var description: [String: AnyObject]? { DADiskCopyDescription(self) as? [String: AnyObject] }
    
    /// The value under key `"DAMediaSize"` from this disk's description. This key holds the disk capacity in bytes.
    var mediaSize: Int? { description?["DAMediaSize"] as? Int }
    
    /// The value under key `"DADeviceModel"` from this disk's description.
    var deviceModel: String? { description?["DADeviceModel"] as? String }
    
    /// The value under key `"DAMediaEjectable"` from this disk's description.
    var isEjectable: Bool? { description?["DAMediaEjectable"] as? Bool }
    
    /// The value under key `"DAMediaRemovable"` from this disk's description.
    var isRemovable: Bool? { description?["DAMediaRemovable"] as? Bool }
    
    /// The value under key `"DAMediaName"` from this disk's description.
    var mediaName: String? { description?["DAMediaName"] as? String }
    
    /// The value under key `"DAVolumeName"` from this disk's description.
    var volumeName: String? { description?["DAVolumeName"] as? String }
    
    /// The value under key `"DAMediaBSDName"` from this disk's description.
    var mediaBSDName: String? { description?["DAMediaBSDName"] as? String }
    
    /// The value under key `"DADeviceProtocol"` from this disk's description.
    var deviceProtocol: String? { description?["DADeviceProtocol"] as? String }
    
    /// The value under key `"DADeviceProtocol"` from this disk's description.
    var volumeType: String? { description?["DAVolumeType"] as? String }
    
    /// The value under key `"DAVolumeKind"` from this disk's description.
    var volumeKind: String? { description?["DAVolumeKind"] as? String }
    
    /// The value under key `"DABusName"` from this disk's description.
    var busName: String? { description?["DABusName"] as? String }
    
    /// The value under key `"DABusPath"` from this disk's description.
    var busPath: String? { description?["DABusPath"] as? String }
    
    /// The value under key `"DAVolumeUUID"` from this disk's description.
    var volumeUUID: String? {
        guard let description = description else { return nil }
        guard let value = description["DAVolumeUUID"] else { return nil }
        let cfUUID = value as! CFUUID
        return CFUUIDCreateString(nil, cfUUID) as String?
    }
    
    /// The value under key `"DAMediaUUID"` from this disk's description.
    var mediaUUID: String? {
        guard let description = description else { return nil }
        guard let value = description["DAMediaUUID"] else { return nil }
        let cfUUID = value as! CFUUID
        return CFUUIDCreateString(nil, cfUUID) as String?
    }
}
