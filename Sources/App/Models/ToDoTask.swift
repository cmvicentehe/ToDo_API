//
//  ToDoTask.swift
//  App
//
//  Created by Carlos Manuel Vicente Herrero on 15/12/2019.
//

import Foundation
import Vapor
import FluentSQLite

enum TaskState: Int, Codable {
    case unknown = -1
    case toDo = 0
    case done = 1
}

struct ToDoTask: Codable {
    var id: UUID?
    let name: String
    let dueDate: Date?
    let notes: String?
    let state: TaskState
}

extension ToDoTask: Content {}
extension ToDoTask: Migration {}
extension ToDoTask: SQLiteUUIDModel {}
extension ToDoTask: Parameter {}
