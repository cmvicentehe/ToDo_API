//
//  ToDoTask.swift
//  App
//
//  Created by Carlos Manuel Vicente Herrero on 15/12/2019.
//

import Vapor
import Fluent

enum TaskState: Int, Codable, Content {
    
    case unknown = -1
    case toDo = 0
    case done = 1
}

final class ToDoTask: Model, Content, Codable {

    static let schema = "todotask"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @OptionalField(key: "dueDate")
    var dueDate: Date?

    @OptionalField(key: "notes")
    var notes: String?
    
    @Field(key: "state")
    var state: TaskState

    init() {}

    init(id: UUID? = nil,
         name: String,
         dueDate: Date? = nil,
         notes: String? = nil,
         state: TaskState) {
        self.id = id
        self.name = name
        self.dueDate = dueDate
        self.notes = notes
        self.state = state
    }
}
