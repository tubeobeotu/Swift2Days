//
//  Song.swift
//  RockCoreStore
//
//  Created by Techmaster on 9/12/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation
import CoreData


class Song: NSManagedObject {

    func addSinger(singer: Singer) {
        let singers = self.mutableSetValueForKey("isSungByManySingers")
        singers.addObject(singer)
    }

}
