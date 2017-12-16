//
//  DatabaseManger.swift
//  EventManager
//
//  Created by vera on 22/11/17.
//   Copyright © 2017 vera. All rights reserved.
//

import Foundation
import SQLite

class DatabaseManager{
    static let shared = DatabaseManager()
    public let connection: Connection?
    public let databaseFileName = "eventdatabase.db"
    
    private init(){
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String!
        print(dbPath!)
        do{
            connection = try Connection("\(dbPath!)/(databaseFileName)")
            print(connection!)
        } catch {
            connection = nil
            let err = error as NSError
            print("Cannot connect to db. Error is: \(err), \(err.userInfo)")
        }
    }
}

