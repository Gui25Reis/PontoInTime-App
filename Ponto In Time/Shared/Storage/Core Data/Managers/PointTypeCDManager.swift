/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.NSPredicate


/// Lida com os tipos de pontos salvos no core data
class PointTypeCDManager {
    
    /* MARK: - Atributos */
    
    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    /// Pega os dados de configuração
    /// - Parameter completionHandler: em caso de sucesso retorna as configurações
    public func getAllData() -> (data: [ManagedPointType]?, error: ErrorCDHandler?) {
        guard let coreDataProperties else { return (data: nil, error: .protocolNotSetted) }
            
        let fetch = DBPointType.fetchRequest()

        guard let data = try? coreDataProperties.mainContext.fetch(fetch)
        else { return (data: nil, error: .fetchError) }
        
        guard data.isEmpty else {
            var allData = data.map { Self.transformToModel(entity: $0) }
            allData.sort { $0.isDefault && !$1.isDefault }
                
            return (data: allData, error: nil)
        }
        
        guard let initialData = self.setupInitialData()
        else { return (data: nil, error: .protocolNotSetted) }
        
        if let error = try? coreDataProperties.saveContext() {
            return (data: nil, error: error)
        }
        return (data: initialData, error: nil)
    }
    
    
    /// Cria um dado (caso não exista) a partir das informações passadas
    /// - Parameter data: informações do novo dado
    /// - Returns: modelo do dado
    public func createIfNeeded(with data: ManagedPointType?) -> (data: DBPointType?, error: ErrorCDHandler?) {
        guard let data else { return (data: nil, error: .dataNotFound) }
        
        if let oldData = self.check(data: data) {
            return (data: oldData, error: .dataAlreadyExists)
        }
        
        guard let coreDataProperties else { return (data: nil, error: .protocolNotSetted) }
        
        let newData = DBPointType(context: coreDataProperties.mainContext)
        newData.title = data.title
        newData.isDefault = data.isDefault
        
        return (data: newData, error: nil)
    }
    
    
    /// Atualiza um dado
    /// - Parameter data: dado que vai ser atualizado
    /// - Returns: possível erro
    public func update(oldData: ManagedPointType, newData: ManagedPointType) -> ErrorCDHandler? {
        guard let point = self.check(data: oldData) else { return .dataNotFound }
        
        point.title = newData.title
        // point.isDefault = newData.isDefault
        
        guard let coreDataProperties else { return .protocolNotSetted }
        return try? coreDataProperties.saveContext()
    }
    
    
    /// Deleta um ponto
    /// - Parameter data: dado que vai ser deletado
    /// - Returns: possível erro
    public func delete(with data: ManagedPointType) -> ErrorCDHandler? {
        guard let point = self.check(data: data) else { return .dataNotFound }
        
        guard let coreDataProperties else { return .protocolNotSetted }
        coreDataProperties.mainContext.delete(point)
        
        return try? coreDataProperties.saveContext()
    }

    
    
    /* MARK: - Configurações */
    
    /// Cria um dado (caso não exista) a partir das informações passadas
    /// - Parameter data: informações do novo dado
    /// - Returns: modelo do dado
    public func check(data: ManagedPointType) -> DBPointType? {
        guard let coreDataProperties else { return nil }
        
        let fetch = DBPointType.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K == '\(data.title)'", #keyPath(DBPointType.title))
        fetch.fetchLimit = 1
        
        return try? coreDataProperties.mainContext.fetch(fetch).first
    }
    
    
    /// Configura os dados iniciais
    /// - Returns: dados iniciais
    private func setupInitialData() -> [ManagedPointType]? {
        let initialData = [
            ManagedPointType(title: "Trabalho", isDefault: true),
            ManagedPointType(title: "Almoço", isDefault: true)
        ]
        
        guard let coreDataProperties else { return nil }
        for data in initialData {
            let newData = DBPointType(context: coreDataProperties.mainContext)
            newData.title = data.title
            newData.isDefault = data.isDefault
        }
        return initialData
    }
    
    
    /// Transforma a entidade do core date para o modelo (struct)
    /// - Parameter entity: a entidade
    /// - Returns: modelo
    static func transformToModel(entity: DBPointType) -> ManagedPointType {
        return ManagedPointType(
            title: entity.title,
            isDefault: entity.isDefault
        )
    }
}
