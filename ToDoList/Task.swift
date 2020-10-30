//
//  Task.swift
//  ToDoList
//
//  Created by Yaroslav on 22.10.2020.
//  Copyright © 2020 Yaroslav. All rights reserved.
//

import Foundation

struct Task: Codable {
    var task: String
    var isUrgent: Bool
    var isDone: Bool
    var inProgress: Bool
}
