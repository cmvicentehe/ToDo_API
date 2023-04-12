import FluentSQLiteDriver
import FluentKit
import Vapor
import Leaf

public func configure(_ app: Application) throws {

    app.databases.use(.sqlite(.file("toDo_DB.sqlite")),
                      as: .sqlite)
    app.logger.logLevel = .debug
    app.views.use(.leaf)
    app.migrations.add(ToDoTaskMigration())
    try app.autoMigrate().wait()
    try routes(app)
}
