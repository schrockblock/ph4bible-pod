//
//  DBManager.swift
//  Pods
//
//  Created by Elliot Schrock on 2/12/17.
//
//

import UIKit
import SQLite

open class DBManager: NSObject {
    var sourcePath: String!
    lazy var database: Connection = try! {
        let lazyDatabase = try Connection(self.sourcePath)
        return lazyDatabase
        }()
    
    init(sourcePath: String!) {
        super.init()
        self.sourcePath = sourcePath
    }
}
