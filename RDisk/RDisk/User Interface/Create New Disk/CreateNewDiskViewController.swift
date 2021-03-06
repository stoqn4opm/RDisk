//
//  CreateNewDiskViewController.swift
//  RDisk
//
//  Created by Stoyan Stoyanov on 18/12/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import Cocoa
import DiskUtil
import RAMDiskManager


// MARK: - Class Definition

final class CreateNewDiskViewController: NSViewController {
    
    /// The storyboard identifier for this view controller.
    static let identifier = "CreateNewDiskViewController"
    
    @IBOutlet private weak var nameField: NSTextField!
    @IBOutlet private weak var sizeField: NSTextField!
    @IBOutlet private weak var sizeStepper: NSStepper!
    @IBOutlet private weak var fileSystemPicker: NSPopUpButton!
    @IBOutlet private weak var createButton: NSButton!
    
    /// The name of the ram disk.
    private var name = "RAM Disk"
    
    /// The picked size of the ram disk in MB.
    private var pickedSize = 1000 {
        didSet {
            sizeField.integerValue = pickedSize
            sizeStepper.integerValue = pickedSize
        }
    }
    
    /// The currently picked filesystem index.
    private var pickedFileSystemIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.stringValue = name
        sizeField.integerValue = pickedSize
        sizeField.formatter = NumberFormatter()
        fileSystemPicker.removeAllItems()
        fileSystemPicker.addItems(withTitles: FileSystem.allCases.map({ $0.description }))
        fileSystemPicker.selectItem(at: pickedFileSystemIndex)
        updateCreateButtonIfNeeded()
    }
}

// MARK: - User Actions

extension CreateNewDiskViewController {
    
    @IBAction private func stepperDidStepped(_ sender: NSStepper) {
        pickedSize = sender.integerValue
    }
    
    @IBAction private func fileSystemPicked(_ sender: NSPopUpButton) {
        pickedFileSystemIndex = sender.indexOfSelectedItem
    }
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        NSApp.hideInTray(true)
    }
    
    @IBAction private func createButtonTapped(_ sender: Any) {
        RAMDiskManager.shared.createRAMDisk(name: name, fileSystem: FileSystem.allCases[pickedFileSystemIndex], capacity: pickedSize) { [weak self] (ramDisk, error) in
            guard error == nil else { self?.handleError(error); return }
            guard ramDisk != nil else { self?.handleError(nil); return }
            NSApp.hideInTray(true)        
        }
    }
}

// MARK: - NSTextFieldDelegate

extension CreateNewDiskViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        if textField == sizeField {
            pickedSize = textField.integerValue
        } else if textField == nameField {
            name = textField.stringValue
        }
        
        updateCreateButtonIfNeeded()
    }
}

// MARK: - Helpers

extension CreateNewDiskViewController {
    
    private func updateCreateButtonIfNeeded() {
        createButton.isEnabled = !name.isEmpty && pickedSize != 0
    }
    
    private func handleError(_ error: RAMDisk.Error?) {
        
        let alert = NSAlert()
        alert.messageText = "Error Occured During Creating of new Ram Disk"
        alert.informativeText = "Details : \(error?.associatedValue ?? "")"
        
        let okButton = alert.addButton(withTitle: "OK")
        okButton.keyEquivalent = "\r"
        alert.alertStyle = NSAlert.Style.critical
        alert.runModal()
    }
}
