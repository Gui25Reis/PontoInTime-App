/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import CoreData


@objc(DBDayWork)
public class DBDayWork: NSManagedObject, Identifiable {
    
    /* MARK: - Atributos */
    
    @NSManaged public var id: UUID
    @NSManaged public var date: String
    @NSManaged public var startTime: String
    @NSManaged public var endTime: String
    @NSManaged public var points: NSSet
    


    /* MARK: - Métodos */

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBDayWork> {
        return NSFetchRequest<DBDayWork>(entityName: "DBDayWork")
    }



    /* MARK: - Relacionamentos */
    
    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: DBPoint)

    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: DBPoint)

    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: NSSet)

    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: NSSet)
}
