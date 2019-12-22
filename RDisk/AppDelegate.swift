//
//  AppDelegate.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 18/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.hideInTray(true)
        
        RAMDisk.restoreDiskSetup()
        RAMDisk.prepareShouldStoreDiskSetupPersistance()
        StatusMenu.shared.show()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        RAMDisk.allMountedDisks.forEach { $0.eject() }
    }
    
    @objc func orderABurrito() {
        print("Ordering a burrito!")
    }
}
