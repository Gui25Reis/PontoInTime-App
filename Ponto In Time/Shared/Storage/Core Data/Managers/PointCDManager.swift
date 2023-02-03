/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias */
import class Foundation.NSPredicate
import struct Foundation.UUID


/// Lida com os pontos salvos no core data
class PointCDManager {
    
    /* MARK: - Atributos */
    
    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    public func updateData(at id: UUID, newData: ManagedPoint, files: [ManagedFiles]?) -> ErrorCDHandler? {
        guard let oldData = self.check(id) else { return .dataNotFound }
        
        self.populate(data: oldData, newData: newData, files: files)
        
        let save = try? self.coreDataProperties?.saveContext()
        return save
    }
    
    
    /// Cria um dado (caso não exista) a partir das informações passadas
    /// - Parameter data: informações do novo dado
    /// - Returns: modelo do dado
    public func createIfNeeded(with data: ManagedPoint) -> DBPoint? {
        guard let coreDataProperties else { return nil }
        
        // Dados da entidade
        let newData = DBPoint(context: coreDataProperties.mainContext)
        self.populate(data: newData, newData: data)
        
        return newData
    }
    
    
    /// Cria um dado (caso não exista) a partir das informações passadas
    /// - Parameter data: informações do novo dado
    /// - Returns: modelo do dado
    public func check(_ id: UUID) -> DBPoint? {
        guard let coreDataProperties else { return nil }
        
        let fetch = DBPoint.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K == '\(id)'", #keyPath(DBPoint.uuid))
        fetch.fetchLimit = 1
        
        return try? coreDataProperties.mainContext.fetch(fetch).first
    }
    
    
    /// Transforma a entidade do core date para o modelo (struct)
    /// - Parameter entity: a entidade
    /// - Returns: modelo
    static func transformToModel(entity: DBPoint) -> ManagedPoint {
        return ManagedPoint(
            uuid: entity.uuid,
            status: entity.status,
            time: entity.time,
            files: entity.getFiles.map() {
                FilesCDManager.transformToModel(entity: $0)
            },
            pointType: PointTypeCDManager.transformToModel(entity: entity.pointType)
        )
    }
    
    
    private func populate(data: DBPoint, newData: ManagedPoint, files: [ManagedFiles]? = nil) {
        // Dados da entidade
        data.uuid = newData.uuid
        data.status = newData.status
        data.time = newData.time
        
        
        /* Relacionamentos */
        
        // Tipo do ponto
        let pointTypeManager = PointTypeCDManager()
        pointTypeManager.coreDataProperties = self.coreDataProperties
        
        let (point, _) = pointTypeManager.createIfNeeded(with: newData.pointType)
        if let point { data.pointType = point }
        
        
        // Arquivos
        let filesManager = FilesCDManager()
        filesManager.coreDataProperties = self.coreDataProperties
        
        var filesToAdd: [ManagedFiles] = newData.files
        if let files { filesToAdd = files }
        
        filesToAdd.forEach() {
            if let file = filesManager.createIfNeeded(with: $0) {
                data.addToFiles(file)
            }
        }
    }
}
