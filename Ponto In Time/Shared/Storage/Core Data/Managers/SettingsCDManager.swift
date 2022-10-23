/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import CoreData


internal class SettingsCDManager {
    
    /* MARK: - Atributos */
    
    public var cache: SettingsData?
    
    /* Protocolo */

    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    /// Pega os dados de configuração
    /// - Parameter completionHandler: em caso de sucesso retorna as configurações
    public func getSettingsData(_ completionHandler: @escaping (Result<ManagedSettings, ErrorCDHandler>) -> Void) {
        if let coreDataProperties {
            
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
                    
                    // Tenta salvar
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
        return completionHandler(.failure(.protocolNotSetted))
    }
    
    
    public func updateSettings(with data: ManagedSettings, _ completionHandler: @escaping (Result<Bool, ErrorCDHandler>) -> Void) {
        
        if let coreDataProperties {
            
            // Pega os dados do core data
            let fetch = DBSettings.fetchRequest()
            fetch.fetchLimit = 1

            if let settings = try? coreDataProperties.mainContext.fetch(fetch).first {
                settings.isSharing = data.isSharing
                settings.sharingID = data.sharingID
                settings.timeWork = data.timeWork
                
                // Tenta salvar
                if let error = try? coreDataProperties.saveContext() {
                    return completionHandler(.failure(error))
                }
                return completionHandler(.success(true))
            }
            return completionHandler(.failure(.fetchError))
        }
        return completionHandler(.failure(.protocolNotSetted))
        
    }
    
    
    
    /* MARK: - Configurações */

    private func setupInitialData() -> ManagedSettings? {
        let initialData = ManagedSettings(
            timeWork: "8",
            sharingID: "customID",
            isSharing: false
        )
        
        if let coreDataProperties {
            let newData = DBSettings(context: coreDataProperties.mainContext)
            newData.timeWork = initialData.timeWork
            newData.isSharing = initialData.isSharing
            newData.sharingID = initialData.sharingID
        } else {
            return nil
        }
        
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
