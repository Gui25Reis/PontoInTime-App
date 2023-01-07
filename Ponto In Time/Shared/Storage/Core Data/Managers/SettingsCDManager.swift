/* Gui Reis    -    gui.sreis25@gmail.com */


/// Lida com os dados de ajustes salvos no core data
internal class SettingsCDManager {
    
    /* MARK: - Atributos */
    
    /// Valores que já foram pedidos
    public var cache: SettingsData?
    
    
    /* Protocolo */

    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    /// Pega os dados de configuração
    /// - Returns:
    public func getSettingsData() -> (data: ManagedSettings?, error: ErrorCDHandler?) {
        guard let coreDataProperties else { return (data: nil, error: .protocolNotSetted) }
            
        let fetch = DBSettings.fetchRequest()
        fetch.fetchLimit = 1
        
        guard let dataFiltered = try? coreDataProperties.mainContext.fetch(fetch) else {
            return (data: nil, error: .fetchError)
        }
        
        guard dataFiltered.isEmpty else {
            let data = self.transformToModel(entity: dataFiltered[0])
            return (data: data, error: nil)
        }
        
        var data: ManagedSettings? = nil
        if let initialData = self.setupInitialData() {
            data = initialData
        } else {
            return (data: nil, error: .protocolNotSetted)
        }
        
        if let error = try? coreDataProperties.saveContext() {
            return (data: nil, error: error)
        }
        return (data: data, error: nil)
    }
    
    
    /// Atualiza um dado de ajustes
    /// - Parameters:
    ///   - data: novo conjunto de dados
    ///   - completionHandler: gera um erro caso tenha algum problema no processo
    public func updateSettings(with data: ManagedSettings, _ completionHandler: @escaping (_ error: ErrorCDHandler?) -> Void) {
        guard let coreDataProperties else { return completionHandler(.protocolNotSetted) }
        
        let fetch = DBSettings.fetchRequest()
        fetch.fetchLimit = 1

        guard let settings = try? coreDataProperties.mainContext.fetch(fetch).first
        else { return completionHandler(.fetchError) }
        
        self.populate(entity: settings, data: data)
        
        let result = try? coreDataProperties.saveContext()
        self.cache?.settingsData = data
        return completionHandler(result)
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
