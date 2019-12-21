//
//  DiskDetailsViewController.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 21/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Cocoa


// MARK: - Class Definition

final class DiskDetailsViewController: NSViewController {
    
    /// The storyboard identifier for this view controller.
    static let identifier = "DiskDetailsViewController"
    
    @IBOutlet private weak var nameLabel: NSTextField!
    @IBOutlet private weak var sizeLabel: NSTextField!
    @IBOutlet private weak var fileSystemLabel: NSTextField!
    
    var disk: RAMDisk?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let disk = disk else { return }
        
        nameLabel.stringValue = disk.name
        sizeLabel.stringValue = "\(disk.capacity) MB"
        fileSystemLabel.stringValue = disk.fileSystem.description
    }
}

// MARK: - User Actions

extension DiskDetailsViewController {
    
    @IBAction private func ejectButtonTapped(_ sender: NSButton) {
        disk?.eject()
        NSApp.hideInTray(true)
    }
    
    @IBAction private func closeButtonTapped(_ sender: NSButton) {
        
        NSApp.hideInTray(true)
    }
}
