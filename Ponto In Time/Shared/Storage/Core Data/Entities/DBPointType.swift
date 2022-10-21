/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import CoreData


@objc(DBPointType)
public class DBPointType: NSManagedObject, Identifiable {
    
    /* MARK: - Atributos */

    @NSManaged public var title: String
    @NSManaged public var isDefault: Bool
    @NSManaged public var points: NSSet


    
    /* MARK: - Métodos */

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBPointType> {
        return NSFetchRequest<DBPointType>(entityName: "DBPointType")
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
