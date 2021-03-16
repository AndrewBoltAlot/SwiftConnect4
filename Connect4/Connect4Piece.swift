//
//  Connect4Piece.swift
//  Connect4
//
//  Created by Roisin Bolt on 11/03/2021.
//  Copyright © 2021 CS UCD. All rights reserved.
//

import Foundation
struct Connect4Piece : Hashable {
    let col: Int
    let row: Int
    let isAlpha: Bool // true for Red, False for Yellow
}
