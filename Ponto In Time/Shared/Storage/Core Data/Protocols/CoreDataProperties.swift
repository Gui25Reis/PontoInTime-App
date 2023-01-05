/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.NSObject

import class CoreData.NSManagedObjectContext
import class CoreData.NSPersistentContainer


/// Propriedades do core data
protocol CoreDataProperties: NSObject {
    
    /// Usada para fazer alterações na tabela
    var mainContext: NSManagedObjectContext { get }
    
    /// Tabela que a classe está mexendo (pegando a tebela e tornando em uma variável)
    var container: NSPersistentContainer { get }
    

    /// Salvando e atualizando alterações que tiveram no core data
    func saveContext() throws -> ErrorCDHandler?
}
