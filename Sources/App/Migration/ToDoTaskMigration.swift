//
//  ToDoTaskMigration.swift
//  
//
//  Created by Carlos Manuel Vicente Herrero on 10/4/23.
//

import Fluent

struct ToDoTaskMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("todotask")
            .id()
            .field("name", .string, .required)
            .field("dueDate", .date, .required)
            .field("notes", .string, .required)
            .field("state", .int,  .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("todotask").delete()
    }
}

