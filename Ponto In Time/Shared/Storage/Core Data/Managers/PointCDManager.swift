/* Gui Reis    -    gui.sreis25@gmail.com */


/// Lida com os pontos salvos no core data
class PointCDManager {
    
    /* MARK: - Atributos */
    
    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    /// Cria um dado (caso não exista) a partir das informações passadas
    /// - Parameter data: informações do novo dado
    /// - Returns: modelo do dado
    public func createIfNeeded(with data: ManagedPoint) -> DBPoint? {
        guard let coreDataProperties else { return nil }
        
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
        
        return newData
    }
    
    
    /// Transforma a entidade do core date para o modelo (struct)
    /// - Parameter entity: a entidade
    /// - Returns: modelo
    static func transformToModel(entity: DBPoint) -> ManagedPoint {
        return ManagedPoint(
            status: entity.status,
            time: entity.time,
            files: entity.getFiles.map() {
                FilesCDManager.transformToModel(entity: $0)
            },
            pointType: PointTypeCDManager.transformToModel(entity: entity.pointType)
        )
    }
}
