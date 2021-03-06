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
    func boot(router: Router) throws {
        router.get(use: getHomeHandler)
        router.get(use: getTasksInViewHandler)
        router.get("tasks", use: getTasksHandler)
        router.delete("task", ToDoTask.parameter, use: deleteTaskByIdHandler)
        router.patch("task", use: updateTaskByIdHandler)
        router.post("task", use: postTaskHandler)
        // Form
        router.post("sendTaskInFormView", use: postTaskInFormHandler)
        router.post("deleteTaskInFormView", ToDoTask.parameter, use: deleteTaskByIdInViewHandler)
    }
}

// MARK: - Routes methods
private extension ToDoController {
    func getHomeHandler(_ request: Request) throws -> Future<View> {
        return try request.view().render("home")
    }

    func getTasksInViewHandler(_ request: Request) throws -> Future<View> {
        return ToDoTask.query(on: request).sort(\ToDoTask.dueDate, .descending).all().flatMap(to: View.self) { tasks in
            let context = ["tasks": tasks]
            return try request.view().render("home.leaf", context)
        }
    }

    func getTasksHandler(_ request: Request) throws -> Future<[ToDoTask]> {
       return ToDoTask.query(on: request).sort(\ToDoTask.id, .descending).all()
    }

    func postTaskHandler(_ request: Request) throws -> Future<HTTPStatus> {
        let taskElement = try task(from: request)
        return taskElement.create(on: request).transform(to: .created)
    }

    func postTaskInFormHandler(_ request: Request) throws -> Future<Response> {
        let taskElement = try task(from: request)
        return taskElement.create(on: request).map(to: Response.self) { _ in
            return request.redirect(to: "/")
        }
    }

   func deleteTaskByIdInViewHandler(_ request: Request) throws -> Future<Response> {
       return try request.parameters.next(ToDoTask.self).flatMap(to: Response.self) { taskElement in
        return taskElement.delete(on: request).map(to: Response.self) { task in
               return request.redirect(to: "/")
           }
       }
   }

   func deleteTaskByIdHandler(_ request: Request) throws -> Future<HTTPStatus> {
       return try request.parameters.next(ToDoTask.self).flatMap(to: HTTPStatus.self) { taskElement in
           return taskElement.delete(on: request).transform(to: .noContent)
       }
   }

    func updateTaskByIdHandler(_ request: Request) throws -> Future<HTTPStatus> {
        let taskElement = try task(from: request)
        return taskElement.update(on: request).transform(to: .ok)
    }
}

// MARK: - Utils methods
private extension ToDoController {

    func task(from request: Request) throws -> ToDoTask {
        let id: String = try request.content.syncGet(String.self, at: "id")
        let name: String = try request.content.syncGet(at: "name")
        let dueDate: String = try request.content.syncGet(at: "dueDate")
        let date = CustomDateFormatter.convertDateStringToDate(dateString: dueDate,
                                                               with: .default)
        let notes: String = try request.content.syncGet(at: "notes")
        let state: Int = try request.content.syncGet(at: "state")
        let taskState: TaskState = translateState(from: state)
        let task = ToDoTask(id: UUID(uuidString: id),
                            name: name,
                            dueDate: date,
                            notes: notes,
                            state: taskState)

        return task
    }

    func translateState(from integer: Int) -> TaskState {
        switch integer {
        case 0:
            return .toDo
        case 1:
            return .done
        default:
            return .unknown
        }
    }
}
