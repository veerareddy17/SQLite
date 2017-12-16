//
//  Event.swift
//  EventManager
//
//  Created by vera on 22/11/17.
//   Copyright © 2017 vera. All rights reserved.
//

import Foundation
import SQLite

    class Event {
        static let shared = Event()
        
        private let tblEvent = Table("EventTable")
        private let id = Expression<Int64>("id")
        private let name = Expression<String>("name")
        private let dateTime = Expression<Date>("DateTime")
        
        private init() {
            //Create table if not exists
            do {
                if let connection = DatabaseManager.shared.connection {
                    try connection.run(tblEvent.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                        table.column(self.id, primaryKey: true)
                        table.column(self.name)
                        table.column(self.dateTime)
                    }))
                    print("Create table event successfully")
                }
            } catch {
                let nserror = error as NSError
                print("Create table event failed. Error is: \(nserror), \(nserror.userInfo)")
            }
        }

        func insert(name: String, dateTime: Date) -> Int64? {
            do {
                let insert = tblEvent.insert(self.name <- name,
                                                self.dateTime <- dateTime)
                let insertedId = try DatabaseManager.shared.connection!.run(insert)
                return insertedId
            } catch {
                let nserror = error as NSError
                print("Cannot insert new Employee. Error is: \(nserror), \(nserror.userInfo)")
                return nil
            }
        }
        func queryAll() -> AnySequence<Row>? {
            do {
                return try DatabaseManager.shared.connection?.prepare(self.tblEvent.order(self.dateTime.desc))
//                return try DatabaseManager.shared.connection?.prepare(self.tblEvent)
            } catch {
                let nserror = error as NSError
                print("Cannot query all Events. Error is: \(nserror), \(nserror.userInfo)")
                return nil
            }
        }
        
        func getEventDetails(event: Row) -> (String, Date){
            return (event[self.name],event[self.dateTime])
        }
        
        func toString(event: Row) {
            print("""
                Event details: name = \(event[self.name]),
                dateTime = \(event[self.dateTime])
                """)
        }
    }
