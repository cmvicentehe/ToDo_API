//
//  ToDoController.swift
//  App
//
//  Created by Carlos Manuel Vicente Herrero on 15/12/2019.
//

import Foundation
import Vapor
import Leaf

class ToDoController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        routes.get(use: getTasksInViewHandler)
        routes.get("tasks", use: getTasksHandler)
        routes.delete("task", use: deleteTaskByIdHandler)
        routes.patch("task", use: updateTaskByIdHandler)
        routes.post("task", use: postTaskHandler)
        // Form
        routes.post("sendTaskInFormView", use: postTaskInFormHandler)
        routes.post("deleteTaskInFormView", use: deleteTaskByIdInViewHandler)
    }
}

// MARK: - Routes methods
private extension ToDoController {

    func getTasksInViewHandler(_ request: Request) -> EventLoopFuture<View> {
        let database = request.db
        return ToDoTask.query(on: database).sort(\ToDoTask.$dueDate, .descending).all().flatMap { tasks in
            let context = ["tasks": tasks]
            return request.view.render("home.leaf", context)
        }
    }

    func getTasksHandler(_ request: Request) async throws -> [ToDoTask] {
        let database = request.db
        return try await ToDoTask.query(on: database).sort(\ToDoTask.$id, .descending).all()
    }

    func postTaskHandler(_ request: Request) throws -> EventLoopFuture<HTTPStatus> {
        let database = request.db
        let taskElement = try task(from: request)
        return taskElement.create(on: database).transform(to: .created)
    }

    func postTaskInFormHandler(_ request: Request) throws -> EventLoopFuture<Response> {
        let database = request.db
        let taskElement = try task(from: request)
        return taskElement.create(on: database).map { _ in
            return request.redirect(to: "/")
        }
    }

    func deleteTaskByIdInViewHandler(_ request: Request) throws -> EventLoopFuture<Response> {
        let database = request.db
        return ToDoTask.find(try request.query.get(at: "id"),
                             on: database)
        .unwrap(or: Abort(.notFound))
        .flatMap { $0.delete(on: database) }
        .map { request.redirect(to: "/") }
    }

    func deleteTaskByIdHandler(_ request: Request) async throws -> HTTPStatus {
        let database = request.db
        guard let toDoTask = try await ToDoTask.find(request.parameters.get("id"),
                                                     on: database) else {
            throw Abort(.notFound)
        }
        try await toDoTask.delete(on: database)
        return .noContent
    }

    func updateTaskByIdHandler(_ request: Request) throws -> EventLoopFuture<HTTPStatus> {
        let database = request.db
        let taskElement = try task(from: request)
        return taskElement.update(on: database).transform(to: .ok)
    }
}

// MARK: - Utils methods
private extension ToDoController {

    func task(from request: Request) throws -> ToDoTask {
        let id: String = try request.content.get(at: "id")
        let name: String = try request.content.get(at: "name")
        let dueDate: String = try request.content.get(at: "dueDate")
        let date = CustomDateFormatter.convertDateStringToDate(dateString: dueDate,
                                                               with: .default)
        let notes: String = try request.content.get(at: "notes")
        let state: String? = try request.content.get(at: "state")
        let taskState: TaskState = translateState(from: state)
        let task = ToDoTask(id: UUID(uuidString: id),
                            name: name,
                            dueDate: date,
                            notes: notes,
                            state: taskState)

        return task
    }

    func translateState(from string: String?) -> TaskState {
        return string != nil ? .done : .toDo
    }
}
