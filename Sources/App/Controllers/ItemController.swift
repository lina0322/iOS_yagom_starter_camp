import Fluent
import Vapor

struct ItemController: RouteCollection {
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    private let header: HTTPHeaders = ["Content-Type": "application/json; charset=utf-8"]
    
    func boot(routes: RoutesBuilder) throws {
        let items = routes.grouped("items")
        items.get(use: readAll)
        
        let item = routes.grouped("item")
        item.post(use: create)
        item.patch(":id", use: update)
        item.delete(":id", use: delete)
    }
    
    private func readAll(req: Request) throws -> EventLoopFuture<Response> {
        return Item.query(on: req.db).all().flatMapThrowing { things in
            let group = Dictionary(grouping: things, by: { $0.state })
            var lists: [ItemList] = []
            for (key, value) in group {
                lists.append(ItemList(state: key, list: value))
            }
            let body = try jsonEncoder.encode(lists)
            return Response(status: .ok,
                            headers: header,
                            body: .init(data: body))
        }
    }
    
    private func create(req: Request) throws -> EventLoopFuture<Response> {
        try checkContentType(req.headers.contentType)
        try Item.validate(content: req)
        let item = try req.content.decode(Item.self)

        return item.save(on: req.db).flatMapThrowing {
            let body = try jsonEncoder.encode(item)
            return Response(status: .created,
                            headers: header,
                            body: .init(data: body))
        }
    }
    
    private func update(req: Request) throws -> EventLoopFuture<Response> {
        try checkContentType(req.headers.contentType)
        let id = try checkID(req)

        try EditedItem.validate(content: req)
        let editedItem = try req.content.decode(EditedItem.self)
        
        return Item.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { item in
                if let title = editedItem.title {
                    item.title = title
                }
                if let body = editedItem.body {
                    item.body = body
                }
                if let deadline = editedItem.deadline {
                    item.deadline = deadline
                }
                if let state = editedItem.state {
                    item.state = state
                }
                item.save(on: req.db)
                
                let body = try jsonEncoder.encode(item)
                return Response(status: .ok,
                                headers: header,
                                body: .init(data: body))
            }
    }
    
    private func delete(req: Request) throws -> EventLoopFuture<Response> {
        try checkAccessToken(req)
        let id = try checkID(req)
        
        return Item.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { item in
                item.delete(on: req.db)
                let body = try jsonEncoder.encode(item)
                return Response(status: .ok,
                                headers: header,
                                body: .init(data: body))
            }
    }
    
    private func checkContentType(_ contentType: HTTPMediaType?) throws {
        guard let contentType = contentType, contentType == .json else {
            throw Abort(.unsupportedMediaType)
        }
    }
    
    private func checkID(_ req: Request) throws -> Int {
        guard let parameterID = req.parameters.get("id"), let id = Int(parameterID) else {
            throw ItemError.invalidID
        }
        return id
    }
    
    private func checkAccessToken(_ req: Request) throws {
        guard let accessToken = try? req.query.decode(AccessToken.self) else {
            throw ItemError.noAccessToken
        }
        if accessToken.key != AccessKey.key {
            throw ItemError.invalidAccessKey
        }
    }
}
