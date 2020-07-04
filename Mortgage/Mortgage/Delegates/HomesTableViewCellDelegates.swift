//
//  HomesTableViewCellDelegates.swift
//  Mortgage
//
//  Created by Norlan Tibanear on 6/25/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import Foundation

protocol HomesTableViewCellDelegates: class {
    func toggleIsFavorite(for cell: HomesTableViewCell)
}
