/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */



class FilesCDManager {
    
    /* MARK: - Atributos */
    
    /* Protocolo */

    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    public func createIfNeeded(with data: ManagedFiles) -> DBFiles? {
        if let coreDataProperties {
            let newData = DBFiles(context: coreDataProperties.mainContext)
            newData.link = data.link
            newData.name = data.name
            
            return newData
        }
        return nil
    }
    
    
    /// Transforma a entidade do core date para o modelo (struct)
    /// - Parameter entity: a entidade
    /// - Returns: modelo
    static func transformToModel(entity: DBFiles) -> ManagedFiles {
        return ManagedFiles(
            link: entity.link,
            name: entity.name
        )
    }
}
