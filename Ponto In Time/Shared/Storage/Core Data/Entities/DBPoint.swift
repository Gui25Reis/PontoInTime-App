/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class CoreData.NSFetchRequest
import class CoreData.NSManagedObject
import class Foundation.NSSet
import struct Foundation.UUID


@objc(DBPoint)
public class DBPoint: NSManagedObject, Identifiable {
    
    /* MARK: - Atributos */
    
    @NSManaged public var uuid: UUID
    @NSManaged public var status: String
    @NSManaged public var time: String
    @NSManaged public var files: NSSet?
    @NSManaged public var pointType: DBPointType
    @NSManaged public var dayWork: DBDayWork
    
    
    public var getFiles: [DBFiles] {
        let set = self.files as? Set<DBFiles> ?? []
        return set.map() {$0}
    }
    
    
    /* MARK: - Métodos */
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBPoint> {
        return NSFetchRequest<DBPoint>(entityName: "DBPoint")
    }
    
    
    
    /* MARK: - Relacionamentos */
    
    @objc(addFilesObject:)
    @NSManaged public func addToFiles(_ value: DBFiles)

    @objc(removeFilesObject:)
    @NSManaged public func removeFromFiles(_ value: DBFiles)

    @objc(addFiles:)
    @NSManaged public func addToFiles(_ values: NSSet)

    @objc(removeFiles:)
    @NSManaged public func removeFromFiles(_ values: NSSet)
}

