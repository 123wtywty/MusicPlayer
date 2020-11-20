//
//  AppDelegate.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-28.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    //    var window: NSWindow!
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        
        
        
        self.appInit()
        
        
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application        
    }
    
    
    
    
    private func appInit(){
        
        NSApp.setActivationPolicy(.accessory)
        
        StatusBarView.shared.makeView()
        
        if let str = UserDefaults.standard.value(forKey: "lastTimeData") as? String,
            let data = try? JSONSerialization.jsonObject(with: Data(str.utf8), options: []) as? [String: Any],
            
            let selectingPath = data["selectingPath"] as? [String],
            let blockedPath = data["blockedPath"] as? [String],
            let playingMusicName = data["playingMusicName"] as? String,
            let playingList = data["playingList"] as? String,
            let repeatShuffleStatus = (data["repeatShuffleStatus"] as? String) ?? ("" as? String)
        {
            
            print(selectingPath, blockedPath, playingMusicName, playingList, repeatShuffleStatus)
            
            AppManager.default.appData.selectingPath = selectingPath
            
            
            AppManager.default.appData.blockedPath = blockedPath
            
            
            let list = ViewableMusicListManager.makeFrom(listName: playingList)
            list.playThisList()
            
            AppManager.default.appData.repeatShuffleStatus = Repeat_Shuffle_Status(rawValue: repeatShuffleStatus) ?? Repeat_Shuffle_Status.shuffle
            
            AppManager.default.musicPlayer.playMusic(name: playingMusicName)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//
//            }
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            StatusBarView.shared.openMainWindow()

        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MusicPlayer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving and Undo support
    
    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }
    
    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            
            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }
    
}

