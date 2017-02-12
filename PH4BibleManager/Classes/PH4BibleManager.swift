//
//  PH4BibleManager.swift
//  Pods
//
//  Created by Elliot Schrock on 12/26/16.
//
//

import UIKit
import BibleManager
import SQLite

public class PH4BibleManager: BibleManager {
    fileprivate let VersesTable = "verses"
    fileprivate let VerseNumber = "verse"
    fileprivate let VerseText = "text"
    fileprivate let VerseChapter = "chapter"
    
    fileprivate let BookTable = "books"
    fileprivate let BookName = "long_name"
    fileprivate let BookAbbreviation = "short_name"
    fileprivate let BookNumber = "book_number"
    
    open var sourceFilePath: String?
    lazy var dbManager: DBManager = {
        let lazyManager = DBManager(sourcePath: self.sourceFilePath)
        return lazyManager 
    }()
    
    fileprivate static let ph4BibleManager: PH4BibleManager = PH4BibleManager(sourceFilePath: Bundle.main.path(forResource: "bible", ofType: "db"))
    public static var bibleManager: BibleManager { get {
            return ph4BibleManager
        }
        set{
            
        }
    }
    
    public init(sourceFilePath: String?) {
        if let file = sourceFilePath {
            self.sourceFilePath = file
        }
    }
    
    public func books(completion: ((Array<Book>) -> Void)) {
        var books = Array<Book>()
        
        let columns = BookNumber + "," + BookName + "," + BookAbbreviation
        let queryString = "SELECT " + columns + " FROM " + BookTable + " ORDER BY " + BookNumber
        do {
            for bookRow in try dbManager.database.prepare(queryString) {
                let book = Book(objectId: bookRow[0] as! Int64, name: bookRow[1] as! String, abbreviation: bookRow[2] as! String)
                books.append(book)
            }
        } catch _ {
            
        }
        
        completion(books)
    }
    
    public func numberOfChapters(of book: Book, completion: ((Int64) -> Void)) {
        var numberOfChapters: Int64 = 0
        
        let selectStatement = "SELECT " + VerseChapter + " FROM " + VersesTable
        let whereStatement = " WHERE " + BookNumber + " = " + String(book.objectId)
        let orderStatement = " ORDER BY " + VerseChapter + " DESC LIMIT 1 "
        let queryString = selectStatement + whereStatement + orderStatement
        do {
            let result = try dbManager.database.prepare(queryString)
            for row in result {
                numberOfChapters = row[0] as! Int64
                break
            }
        }catch _ {
            
        }
        
        completion(numberOfChapters)
    }
    
    public func verses(of book: Book, chapter: Int64, completion: ((Array<Verse>) -> Void)){
        var verses = Array<Verse>()
        
        let columns = VerseNumber + "," + VerseText
        let selectStatement = "SELECT " + columns + " FROM " + VersesTable
        let whereStatement = " WHERE " + BookNumber + " = " + String(book.objectId) + " AND " + VerseChapter + " = " + String(chapter)
        let orderStatement = " ORDER BY " + VerseNumber + " ASC"
        let queryString = selectStatement + whereStatement + orderStatement
        
        do {
            for verseRow in try dbManager.database.prepare(queryString) {
                let verse = Verse(bookId: book.objectId, chapter: chapter, number: verseRow[0] as! Int64, text: verseRow[1] as! String)
                verses.append(verse)
            }
        }catch _ {
            
        }
        
        completion(verses)
    }

}
