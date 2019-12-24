//
//  DiskDetailsViewController.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 21/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Cocoa
import RAMDiskManager


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
        sizeLabel.stringValue = disk.capacity.byteCountFormatted
        fileSystemLabel.stringValue = disk.fileSystem.description
    }
}

// MARK: - User Actions

extension DiskDetailsViewController {
    
    @IBAction private func ejectButtonTapped(_ sender: NSButton) {
        
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to eject \(disk?.name ?? "") ?"
        alert.informativeText = "All data on it will be irrevertably lost."
        let yesButton = alert.addButton(withTitle: "Eject")
        let cancelButton = alert.addButton(withTitle: "Cancel")
        
        cancelButton.keyEquivalent = "\r"
        yesButton.keyEquivalent = ""
        alert.alertStyle = NSAlert.Style.warning
        
        if alert.runModal() == .alertFirstButtonReturn {
            #warning("Handle eject error")
            disk?.eject()
            NSApp.hideInTray(true)
        }
    }
    
    @IBAction private func closeButtonTapped(_ sender: NSButton) {
        NSApp.hideInTray(true)
    }
}
