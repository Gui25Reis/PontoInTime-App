/* Macro - Grupo 05 */

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
}
