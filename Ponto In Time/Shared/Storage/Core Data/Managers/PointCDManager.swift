/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */


class PointCDManager {
    
    /* MARK: - Atributos */
    
    
    /* Protocolo */

    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    public func createIfNeeded(with data: ManagedPoint) -> DBPoint? {
        if let coreDataProperties {
            // Dados da entidade
            let newData = DBPoint(context: coreDataProperties.mainContext)
            newData.status = data.status
            newData.time = data.time
            
            /* Relacionamentos */
            
            // Tipo do ponto
            let pointTypeManager = PointTypeCDManager()
            pointTypeManager.coreDataProperties = self.coreDataProperties
            if let pointType = pointTypeManager.createIfNeeded(with: data.pointType) {
                newData.pointType = pointType
            }
            
            // Arquivos
            let filesManager = FilesCDManager()
            filesManager.coreDataProperties = self.coreDataProperties
            for item in data.files {
                if let file = filesManager.createIfNeeded(with: item) {
                    newData.addToFiles(file)
                }
            }
            
        }
        return nil
    }
}
