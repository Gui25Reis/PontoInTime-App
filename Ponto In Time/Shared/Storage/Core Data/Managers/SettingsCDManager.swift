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
    /// - Parameter completionHandler: em caso de sucesso retorna as configurações
    public func getSettingsData(_ completionHandler: @escaping (Result<ManagedSettings, ErrorCDHandler>) -> Void) {
        guard let coreDataProperties else { return completionHandler(.failure(.protocolNotSetted)) }
            
        // Pega os dados do core data
        let fetch = DBSettings.fetchRequest()
        fetch.fetchLimit = 1

        if let dataFiltered = try? coreDataProperties.mainContext.fetch(fetch) {
            if dataFiltered.isEmpty {
                if let initialData = self.setupInitialData() {
                    completionHandler(.success(initialData))
                } else {
                    return completionHandler(.failure(.protocolNotSetted))
                }
                
                if let error = try? coreDataProperties.saveContext() {
                    return completionHandler(.failure(error))
                }
                return
            }
            
            let data = self.transformToModel(entity: dataFiltered[0])
            return completionHandler(.success(data))
        }
        return completionHandler(.failure(.fetchError))
    }
    
    
    /// Atualiza um dado de ajustes
    /// - Parameters:
    ///   - data: novo conjunto de dados
    ///   - completionHandler: gera um erro caso tenha algum problema no processo
    public func updateSettings(with data: ManagedSettings, _ completionHandler: @escaping (_ error: ErrorCDHandler?) -> Void) {
        guard let coreDataProperties else { return completionHandler(.protocolNotSetted) }
        
        let fetch = DBSettings.fetchRequest()
        fetch.fetchLimit = 1

        if let settings = try? coreDataProperties.mainContext.fetch(fetch).first {
            settings.isSharing = data.isSharing
            settings.sharingID = data.sharingID
            settings.timeWork = data.timeWork
            
            if let error = try? coreDataProperties.saveContext() {
                return completionHandler(error)
            }
            return completionHandler(nil)
        }
        return completionHandler(.fetchError)
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
        newData.timeWork = initialData.timeWork
        newData.isSharing = initialData.isSharing
        newData.sharingID = initialData.sharingID
        
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
}
