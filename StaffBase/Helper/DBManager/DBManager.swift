//
//  DBManager.swift
//  StaffBase
//
//  Created by Vijith TV on 05/03/22.
//

import CoreData
import Combine

enum DBError: Error {
    case objectNotFound
}

class DBHelper {
    
    //MARK: - MODEL NAME
    private static let modelName = "StaffBase"
    
    //MARK: - PERSISTENT CONTAINER
    static var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //MARK: - MAINCONTEXT
    static var moc: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    //MARK: - CONTEXT
    static var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = moc
        return context
    }()
    
}

public extension NSManagedObject {
    
    convenience init(using usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }
}

class DBManager<Entity: NSManagedObject> {
    
    //MARK: - MODEL NAME
    private let modelName = "StaffBase"
    
    //MARK: - PERSISTENT CONTAINER
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //MARK: - MAINCONTEXT
    private lazy var moc: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    //MARK: - CONTEXT
    private lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = moc
        return context
    }()
    
    //MARK: - OBJECT FROM ID

    func object(_ id: NSManagedObjectID) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    guard let entity = try? context.existingObject(with: id) as? Entity else {
                        promise(.failure(DBError.objectNotFound))
                        return
                    }
                    promise(.success(entity))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    //MARK: - STORE DATA INTO CORE DATA
    func store(_ body: @escaping (inout Entity) -> Void) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future  { promise in
                context.perform {
                    var entity = Entity(context: context)
                    body(&entity)
                    do {
                        try context.save()
                        promise(.success(entity))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //MARK: - FETCH DATA FROM COREDATA
    func fetch(sortDescriptors: [NSSortDescriptor] = [],
               predicate: NSPredicate? = nil) -> AnyPublisher<[Entity], Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    let request = Entity.fetchRequest()
                    request.sortDescriptors = sortDescriptors
                    request.predicate = predicate
                    do {
                        let results = try context.fetch(request) as! [Entity]
                        promise(.success(results))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
