/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import CoreData


@objc(DBFiles)
public class DBFiles: NSManagedObject, Identifiable {

    /* MARK: - Atributos */

    @NSManaged public var link: String
    @NSManaged public var name: String
    @NSManaged public var point: DBPoint



    /* MARK: - Métodos */

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBFiles> {
        return NSFetchRequest<DBFiles>(entityName: "DBFiles")
    }
}
