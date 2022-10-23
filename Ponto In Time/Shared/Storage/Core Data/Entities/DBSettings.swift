/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import CoreData


@objc(DBSettings)
public class DBSettings: NSManagedObject, Identifiable {
    
    /* MARK: - Atributos */
    
    @NSManaged public var timeWork: String
    @NSManaged public var sharingID: String
    @NSManaged public var isSharing: Bool



    /* MARK: - Métodos */

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBSettings> {
        return NSFetchRequest<DBSettings>(entityName: "DBSettings")
    }
}
