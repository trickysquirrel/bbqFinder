//
//  Array+Safe.swift
//  FoodNutrientsFinder
//
//  Created by Richard Moult on 13/10/2015.
//  Copyright © 2015 TrickySquirrel. All rights reserved.
//

import Foundation


extension Array {

    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}