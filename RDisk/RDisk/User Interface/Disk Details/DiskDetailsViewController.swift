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
            
            disk?.eject { [weak self] error in
                guard error != nil else { self?.handleError(error); return }
                NSApp.hideInTray(true)
            }
        }
    }
    
    @IBAction private func closeButtonTapped(_ sender: NSButton) {
        NSApp.hideInTray(true)
    }
}

// MARK: - Helpers

extension DiskDetailsViewController {
    
    
    private func handleError(_ error: RAMDisk.Error?) {
        
        let alert = NSAlert()
        alert.messageText = "Error occured when ejecting '\(disk?.name ?? "")'"
        alert.informativeText = "Details : \(error?.associatedValue ?? "")"
        
        let okButton = alert.addButton(withTitle: "OK")
        okButton.keyEquivalent = "\r"
        alert.alertStyle = NSAlert.Style.critical
        alert.runModal()
    }
}
