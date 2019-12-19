//
//  NSApp+Extensions.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 18/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Cocoa

extension NSApplication {
    
    /// Hides or shows the main window of the app.
    ///
    /// - Parameter shouldHide: if `true` it hides the app main window and it also removes it
    ///  from the app switcher and the dock, leaving only the status bar icon. If `false` then
    /// main window is presented in addition to the status bar icon.
    func hideInTray(_ shouldHide: Bool) {
        
        if shouldHide {
            keyWindow?.close()
        }
        
        NSApp.setActivationPolicy(shouldHide ? .accessory : .regular)
    }
}
