//
//  AboutViewController.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 18/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Cocoa


// MARK: - Class Definition

final class AboutViewController: NSViewController {

    static let identifier = "AboutViewController"
    
}

// MARK: - User Actions

extension AboutViewController {
    
    @IBAction private func closeButtonTapped(_ sender: Any) {
        NSApp.hideInTray(true)
    }
}
