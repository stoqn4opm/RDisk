//
//  CreateNewDiskViewController.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 18/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Cocoa


// MARK: - Class Definition

final class CreateNewDiskViewController: NSViewController {
    
    /// The storyboard identifier for this view controller.
    static let identifier = "CreateNewDiskViewController"
    
    @IBOutlet private weak var sizeTextField: NSTextField!
}

// MARK: - User Actions

extension CreateNewDiskViewController {
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        NSApp.hideInTray(true)
    }
    
    @IBAction private func createButtonTapped(_ sender: Any) {
        NSApp.hideInTray(true)
    }
}
