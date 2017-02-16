//
//  PH4BibleManagerSpec.swift
//  PH4BibleManager
//
//  Created by Elliot Schrock on 2/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import PH4BibleManager
import Quick
import Nimble
import BibleManager

class PH4BibleManagerSpec: QuickSpec {
    override func spec() {
        describe("BibleManager", { () -> Void in
            
            beforeSuite {
                BibleManager.bibleManager = PH4BibleManager.ph4BibleManager
            }
            
            it("gets all books") {
                waitUntil { done in
                    BibleManager.bibleManager.books(completion: { books in
                        expect(books.count).to(equal(66))
                        done()
                    })
                }
            }
            
            it("gets number of chapters") {
                waitUntil { done in
                    BibleManager.bibleManager.numberOfChapters(of: Book(objectId: 550, name: "Galatians", abbreviation: "Gal"), completion: { (numberOfChapters) in
                        expect(numberOfChapters).to(equal(6))
                        done()
                    })
                }
            }
            
            it("gets verses for chapter") {
                waitUntil { done in
                    BibleManager.bibleManager.verses(of: Book(objectId: 550, name: "Galatians", abbreviation: "Gal"), chapter: 1, completion: { (verses) in
                        expect(verses.count).to(equal(24))
                        done()
                    })
                }
            }
        })
    }
}
