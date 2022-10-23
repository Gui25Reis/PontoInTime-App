/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import class CoreData.NSPredicate


class PointTypeCDManager {
    
    /* MARK: - Atributos */
    
    /* Protocolo */

    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    /// Pega os dados de configuração
    /// - Parameter completionHandler: em caso de sucesso retorna as configurações
    public func getAllData(_ completionHandler: @escaping (Result<[ManagedPointType], ErrorCDHandler>) -> Void) {
        if let coreDataProperties {
            
            let fetch = DBPointType.fetchRequest()

            if let data = try? coreDataProperties.mainContext.fetch(fetch) {
                if data.isEmpty {
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
                
                var allData = data.map { item in
                    Self.transformToModel(entity: item)
                }
            
                allData.sort {
                    $0.isDefault && !$1.isDefault
                }
                
                return completionHandler(.success(allData))
            }
            return completionHandler(.failure(.fetchError))
        }
        return completionHandler(.failure(.protocolNotSetted))
    }
    
    
    public func createIfNeeded(with data: ManagedPointType) -> DBPointType? {
        if let coreDataProperties {
            let fetch = DBPointType.fetchRequest()
            fetch.predicate = NSPredicate(format: "%K == '\(data.title)'", #keyPath(DBPointType.title))
            fetch.fetchLimit = 1
            
            if let data = try? coreDataProperties.mainContext.fetch(fetch).first {
                return data
            }
            
            let newData = DBPointType(context: coreDataProperties.mainContext)
            newData.title = data.title
            newData.isDefault = data.isDefault
            
            return newData
        }
        return nil
    }

    
    
    /* MARK: - Configurações */

    private func setupInitialData() -> [ManagedPointType]? {
        let initialData = [
            ManagedPointType(title: "Trabalho", isDefault: true),
            ManagedPointType(title: "Almoço", isDefault: true),
            ManagedPointType(title: "Test", isDefault: false)
        ]
        
        if let coreDataProperties {
            for data in initialData {
                let newData = DBPointType(context: coreDataProperties.mainContext)
                newData.title = data.title
                newData.isDefault = data.isDefault
            }
            
            return initialData
        }
        return nil
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
