//
//  DataManager.swift
//  Todo
//
//  Created by 唐子轩 on 2018/7/4.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import Foundation

public class DataManager {
    
    //gets Doc. Directory
    static fileprivate func getDocDirec () -> URL {
        
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Unable to Acsess Doc Direc")
        }
        
    }
    
    //save any kind of codable objects
    static func save <T:Encodable> (_ object:T, with fileName:String) {
        
        let url = getDocDirec().appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    //load any kind of coable obj
    static func load <T:Decodable> (_ fileName:String, with type:T.Type) -> T {
        
        let url = getDocDirec().appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File NOT Found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
            
        } else {
            fatalError("Data Unavailable at path \(url.path)")
        }
        
    }
    
    //load data from a file
    static func loadData (_ fileName:String) -> Data? {
        
        let url = getDocDirec().appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File NOT Found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            
            return data
            
        } else {
            fatalError("Data Unavailable at path \(url.path)")
        }
        
    }
    
    //load all files from a directory
    static func loadAll <T:Decodable> (_ type:T.Type) -> [T] {
    
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocDirec().path)
            var modelObjects = [T]()
            for FileName in files {
                modelObjects.append(load(FileName, with: type))
            }
            return modelObjects
            
        } catch {
            fatalError("Could NOT Load any Files")
        }
    }
    
    //delete a file
    static func delete (_ fileName:String) {
        let url = getDocDirec().appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
            
        }
    }
    
    
}

