/* Gui Reis    -    gui.sreis25@gmail.com */


/// Lida com os dados de ajustes salvos no core data
internal class SettingsCDManager {
    
    /* MARK: - Atributos */
    
    /// Todos os dados
    private var allData: [DBSettings]? {
        let fetch = DBSettings.fetchRequest()
        fetch.fetchLimit = 1

        return try? self.coreDataProperties?.mainContext.fetch(fetch)
    }
    
    /// Dados de configuração
    public var cache: ManagedSettings? = nil
    
    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    /// Pega os dados de configuração
    /// - Returns:
    public func getSettingsData() -> (data: ManagedSettings?, error: ErrorCDHandler?) {
        if let cache { return (data: cache, error: nil) }
        
        guard let allData else { return (data: nil, error: .fetchError) }
        
        guard allData.isEmpty else {
            let data = self.transformToModel(entity: allData[0])
            self.cache = data
            return (data: data, error: nil)
        }
        
        guard let initialData = self.setupInitialData()
        else { return (data: nil, error: .protocolNotSetted) }
        
        let save = try? self.coreDataProperties?.saveContext()
        
        guard save == nil else { return (data: nil, error: save) }
        self.cache = initialData
        
        return (data: initialData, error: nil)
    }
    
    
    /// Atualiza um dado de ajustes
    /// - Parameters:
    ///   - data: novo conjunto de dados
    ///   - completionHandler: gera um erro caso tenha algum problema no processo
    public func updateSettings(with data: ManagedSettings) -> ErrorCDHandler? {
        guard let settings = self.allData?.first else { return .fetchError }
        
        self.populate(entity: settings, data: data)
        
        let save = try? self.coreDataProperties?.saveContext()
        guard save == nil else { return save }
        
        self.cache = data
        return nil
    }
    
    
    /* MARK: - Configurações */
    
    /// Configura os dados inciais do app
    /// - Returns: dados iniciais
    private func setupInitialData() -> ManagedSettings? {
        guard let coreDataProperties else { return nil }
        
        let initialData = ManagedSettings(
            timeWork: "8", sharingID: "customID", isSharing: false
        )
        
        let newData = DBSettings(context: coreDataProperties.mainContext)
        self.populate(entity: newData, data: initialData)
        
        return initialData
    }
    
    
    /// Transforma a entidade do core date para o modelo (struct)
    /// - Parameter entity: a entidade
    /// - Returns: modelo
    private func transformToModel(entity: DBSettings) -> ManagedSettings {
        return ManagedSettings(
            timeWork: entity.timeWork,
            sharingID: entity.sharingID,
            isSharing: entity.isSharing
        )
    }
    
    
    /// Popla a entidade do core data com os dados do modelo
    /// - Parameters:
    ///   - entity: entidade do core data
    ///   - data: modelo de dados da entidade
    private func populate(entity: DBSettings, data: ManagedSettings) {
        entity.timeWork = data.timeWork
        entity.isSharing = data.isSharing
        entity.sharingID = data.sharingID
    }
}
