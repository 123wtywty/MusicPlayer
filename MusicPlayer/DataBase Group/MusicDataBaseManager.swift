//
//  MusicDataBaseManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-05-12.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import CoreData
import Cocoa

class MusicDataBaseManager{
    
    private let entityName = "MusicData"
    private let dataBase = (NSApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    
    private var dataCached = Dictionary<String, (music: MusicDataStruct, item: NSManagedObject)>()
    private var dataCachedIsValid = false
    
    
    func readData() -> [MusicDataStruct]{
        if dataCachedIsValid {
            return dataCached.values.map {$0.music}
        }
        
        dataCached = self.readDataFromDataBase()
        dataCachedIsValid = true
        
        return readData()
    }
    
    
    private func readDataFromDataBase() -> [String: (music: MusicDataStruct, item: NSManagedObject)]{
        print(#function)
        var datas : [NSManagedObject] = []
        var res = Dictionary<String, (music: MusicDataStruct, item: NSManagedObject)>()
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            datas = try dataBase.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for item in datas{
            
            let dic = item.dictionaryWithValues(
                forKeys: ["name", "isFavorite", "playCount"])
            
            let name = dic["name"] as? String ?? ""
            let playCount = dic["playCount"] as? Double ?? 0.0
            let isFavorite = dic["isFavorite"] as? Bool ?? false

            
            let musicData = MusicDataStruct(name: name, isFavorite: isFavorite, playCount: playCount)
            res[musicData.name] = (musicData, item)
        }
        
        return res
        
    }
    
    func addData(data: MusicDataStruct){
        
        let d1 = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: entityName,
                                                                    in: dataBase)!,
                                 insertInto: dataBase)
        //                print(item.title)
        d1.setValue(data.name, forKey: "name")
        d1.setValue(data.isFavorite, forKey: "isFavorite")
        d1.setValue(data.playCount, forKey: "playCount")

        dataCachedIsValid = false
        try? dataBase.save()
        
        
    }
    
    func removeData(musicName: String){
        if !dataCachedIsValid{
            self.readData()
        }
        
        guard let item = dataCached[musicName] else { return }
        
        dataCachedIsValid = false
        dataBase.delete(item.item)
        try? dataBase.save()
        
    }
    
    func clear(){
        var db : [NSManagedObject] = []
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            db = try dataBase.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for item in db{
            dataBase.delete(item)
            
        }
        
        try? dataBase.save()
        
    }
    
    
}
