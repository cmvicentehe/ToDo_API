import Fluent
import Vapor

func routes(_ app: Application) throws {
    let toDoController = ToDoController()
    try app.register(collection: toDoController)
}
