//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Тихтей  Павел on 26.04.2023.
//

import UIKit

struct TrackerCategory {
    let id: UUID
    let title: String
    var trackers: [Tracker]
}
