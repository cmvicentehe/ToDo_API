import Vapor

public func routes(_ router: Router) throws {
    let toDoController = ToDoController()
    try router.register(collection: toDoController)
}
