//
//  InitMusicData.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/12/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import CoreStore
class InitMusicData: ConsoleScreen {

    override func viewDidLoad() {
        super.viewDidLoad()
        initMusicSampleData(initSampleComplete)
        
    }
    //http://stackoverflow.com/questions/17018634/core-data-insertion-into-one-to-many-relationship
    func initMusicSampleData(completion: (result: SaveResult) -> Void = { _ in }) {
        Music.dataStack.beginAsynchronous { transaction in
            transaction.deleteAll(From(Singer))
            transaction.deleteAll(From(Genre))
            transaction.deleteAll(From(Song))
            
            //Singer
            let taylorSwift = transaction.create(Into<Singer>())
            taylorSwift.name = "TaylorSwift"
            
            let adele = transaction.create(Into<Singer>())
            adele.name = "Adele"
            
            let charliePuth = transaction.create(Into<Singer>())
            charliePuth.name = "Charlie Puth"
            
            let selenaGomez = transaction.create(Into<Singer>())
            selenaGomez.name = "Selena Gomez"
            
            //Genre
            let pop = transaction.create(Into<Genre>())
            pop.name = "Pop"
            
            let rock = transaction.create(Into<Genre>())
            rock.name = "Rock"
            
            let classical = transaction.create(Into<Genre>())
            classical.name = "Classical"
            
            //Song
            let hello = transaction.create(Into<Song>())
            hello.title = "Hello"
            hello.isCategoriedByOneGenre = pop
            hello.addSinger(adele)
            
            let weDontTalkAnyMore = transaction.create(Into<Song>())
            weDontTalkAnyMore.title = "We don't talk any more"
            weDontTalkAnyMore.isCategoriedByOneGenre = rock
            weDontTalkAnyMore.addSinger(charliePuth)
            weDontTalkAnyMore.addSinger(selenaGomez)
            
            
            let slowDown = transaction.create(Into<Song>())
            slowDown.title = "Slow Down"
            //slowDown.isCategoriedByOneGenre = rock
            slowDown.addSinger(selenaGomez)
            
            
            transaction.commit(completion)

        }
    }
    
    func initSampleComplete (result: SaveResult)  {
        if let songs = Music.dataStack.fetchAll(From<Song>()) {
            songs.forEach({ (song) in
                if let genre = song.isCategoriedByOneGenre?.name! {
                    print("\(song.title!) -  \(genre)")
                } else {
                    print("\(song.title!)")
                }
                
                song.isSungByManySingers?.forEach({ (singer) in
                    print("    \(singer.name!)")
                })
            })
        }
        
    }



}
