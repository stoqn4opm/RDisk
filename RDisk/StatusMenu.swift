//
//  StatusMenu.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 18/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Cocoa


// MARK: - Singleton Instance

extension StatusMenu {
    
    /// Shared instance of the app's status bar menu.
    static let shared = StatusMenu()
}

// MARK: - Class Definition

/// Class containing all logic regarding the status menu of the app. Think of it as the status bar icon.
///
/// The way to use it is by its shared instance.
final class StatusMenu: NSObject {
    
    /// Retain hook for the system's status bar item.
    private var statusBarItem: NSStatusItem
    
    /// Init should not be called, use `.shared` instead.
    private override init() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "􀋧"
        statusBarItem.button?.font = NSFont.systemFont(ofSize: 18)
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatusBarMenu), name: .diskCreated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatusBarMenu), name: .diskEjected, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .diskCreated, object: nil)
        NotificationCenter.default.removeObserver(self, name: .diskEjected, object: nil)
    }
}

// MARK: - Status Bar Menu

extension StatusMenu {
    
    /// Method used for showing generating the status bar menu and presenting it in the status bar.
    func show() {
        updateStatusBarMenu()
    }
    
    /// Creates the status bar menu,
    @objc private func updateStatusBarMenu() {
        
        let statusBarMenu = NSMenu(title: "RDisk Status Bar Menu")
        statusBarItem.menu = statusBarMenu
        
        prepareDiskSectionFor(statusBarMenu)
        statusBarMenu.addItem(NSMenuItem.separator())
        preparePreferencesSectionFor(statusBarMenu)
        statusBarMenu.addItem(NSMenuItem.separator())
        prepareQuitSectionFor(statusBarMenu)
    }
}

// MARK: - Menu Entries

extension StatusMenu {
    
    private func prepareDiskSectionFor(_ statusBarMenu: NSMenu) {
        let create = statusBarMenu.addItem(withTitle: "Create New RAM Disk...", action: #selector(createNewDisk), keyEquivalent: "")
        create.target = self
        
        let statusItem = statusBarMenu.addItem(withTitle: "Created Disks", action: nil, keyEquivalent: "")
        let subMenu = NSMenu(title: "Created Disks Submenu")
        
        if RAMDisk.allMountedDisks.isEmpty {
            subMenu.addItem(withTitle: "No Disks...", action: nil, keyEquivalent: "")
        } else {
            RAMDisk.allMountedDisks.enumerated().forEach { index, element in
                let item = subMenu.addItem(withTitle: element.name, action: #selector(diskTapped(_:)), keyEquivalent: "")
                item.tag = index
                item.target = self
            }
        }
        
        statusBarMenu.setSubmenu(subMenu, for: statusItem)
    }
    
    private func preparePreferencesSectionFor(_ statusBarMenu: NSMenu) {
        let preferences = statusBarMenu.addItem(withTitle: "Preferences...", action: #selector(openPreferences), keyEquivalent: "")
        let about = statusBarMenu.addItem(withTitle: "About RDisk", action: #selector(openAboutPage), keyEquivalent: "")
        preferences.target = self
        about.target = self
    }
    
    private func prepareQuitSectionFor(_ statusBarMenu: NSMenu) {
        let quit = statusBarMenu.addItem(withTitle: "Quit", action: #selector(quitApp), keyEquivalent: "Q")
        quit.target = self
    }
}

// MARK: - Menu Actions

extension StatusMenu: NSUserInterfaceValidations {
    
    func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool { true }
    
    @objc private func createNewDisk() {
        guard let viewController = NSStoryboard(name: "Main", bundle: Bundle(for: CreateNewDiskViewController.self)).instantiateController(withIdentifier: CreateNewDiskViewController.identifier) as? CreateNewDiskViewController else { return }
        presentViewController(viewController)
    }
    
    @objc private func openPreferences() {
        
    }
    
    @objc private func openAboutPage() {
        guard let viewController = NSStoryboard(name: "Main", bundle: Bundle(for: AboutViewController.self)).instantiateController(withIdentifier: AboutViewController.identifier) as? AboutViewController else { return }
        presentViewController(viewController)
    }
    
    @objc private func diskTapped(_ menuItem: NSMenuItem) {
        guard RAMDisk.allMountedDisks.indices.contains(menuItem.tag) else { return }
        let disk = RAMDisk.allMountedDisks[menuItem.tag]
        
        guard let viewController = NSStoryboard(name: "Main", bundle: Bundle(for: DiskDetailsViewController.self)).instantiateController(withIdentifier: DiskDetailsViewController.identifier) as? DiskDetailsViewController else { return }
        viewController.disk = disk
        presentViewController(viewController)
    }
    
    @objc private func quitApp() {
        NSApp.terminate(self)
    }
}

// MARK: - Helper Methods

extension StatusMenu: NSWindowDelegate {
    
    private func presentViewController(_ viewController: NSViewController) {
        NSApp.hideInTray(false)
        
        guard let controller = NSStoryboard(name: "Main", bundle: Bundle(for: StatusMenu.self)).instantiateController(withIdentifier: "Window") as? NSWindowController else { return }
        guard let window = controller.window else { return }
        window.delegate = self
        window.title = viewController.title ?? ""
        window.contentViewController = viewController
        window.center()
        window.makeKeyAndOrderFront(self)
    }
    
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        guard NSApp.windows.contains(where: { $0.className != "NSStatusBarWindow" && $0 != window }) == false else { return }
        NSApp.setActivationPolicy(.accessory)
    }
}
