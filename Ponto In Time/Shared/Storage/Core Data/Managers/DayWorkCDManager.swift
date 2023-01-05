/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.NSPredicate
import struct Foundation.UUID


/// Lida com os dados de um dia salvos no core data
internal class DayWorkCDManager {
    
    /* MARK: - Atributos */
    
    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    /// Pega os dados de configuração
    /// - Parameter completionHandler: em caso de sucesso retorna as configurações
    public func getAllData(_ completionHandler: @escaping (Result<[ManagedDayWork], ErrorCDHandler>) -> Void) {
        guard let coreDataProperties else { return completionHandler(.failure(.protocolNotSetted)) }
                
        let fetch = DBDayWork.fetchRequest()

        if let data = try? coreDataProperties.mainContext.fetch(fetch) {
            let allData = data.map { item in
                self.transformToModel(entity: item)
            }
            return completionHandler(.success(allData))
        }
        return completionHandler(.failure(.fetchError))
    }
    
    
    
    /// Pega dados de um dia específico
    /// - Parameters:
    ///   - date: dia
    ///   - completionHandler: em caso de sucesso retorna as informações
    public func getData(for date: String, _ completionHandler: @escaping (Result<ManagedDayWork, ErrorCDHandler>) -> Void) {
        guard let coreDataProperties else { return completionHandler(.failure(.protocolNotSetted)) }
        
        let fetch = DBDayWork.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K == '\(date)'", #keyPath(DBDayWork.date))
        fetch.fetchLimit = 1
        
        if let data = try? coreDataProperties.mainContext.fetch(fetch) {
            if data.isEmpty {
                return completionHandler(.failure(.dataNotFound))
            }
            
            let managedData = self.transformToModel(entity: data[0])
            return completionHandler(.success(managedData))
        }
        return completionHandler(.failure(.fetchError))
    }
    
    
    /// Adiciona um novo dado
    /// - Parameters:
    ///   - data: dado que vai ser adionado
    ///   - completionHandler: gera um erro caso tenha algum problema no processo
    public func createData(with data: ManagedDayWork, _ completionHandler: @escaping (_ error: ErrorCDHandler?) -> Void) {
        guard let coreDataProperties else { return completionHandler(.protocolNotSetted) }
        
        let newData = DBDayWork(context: coreDataProperties.mainContext)
        newData.id = UUID()
        newData.date = data.date
        newData.startTime = data.startTime
        newData.endTime = data.endTime
        
        let pointManager = PointCDManager()
        pointManager.coreDataProperties = self.coreDataProperties
        
        for item in data.points {
            if let point = pointManager.createIfNeeded(with: item) {
                newData.addToPoints(point)
            }
        }
        
        // Tenta salvar
        if let error = try? coreDataProperties.saveContext() {
            return completionHandler(error)
        }
        return completionHandler(nil)
    }
    
    
    /// Adiciona um novo ponto no dia
    /// - Parameters:
    ///   - dataID: id do dia (que vai ser adicionado)
    ///   - point: ponto que vai ser adicionado
    ///   - completionHandler: gera um erro caso tenha algum problema no processo
    public func addNewPoint(in dataID: UUID, point: ManagedPoint, _ completionHandler: @escaping (_ error: ErrorCDHandler?) -> Void) {
        guard let coreDataProperties else { return completionHandler(.protocolNotSetted) }
        
        let fetch = DBDayWork.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K == '\(dataID)'", #keyPath(DBDayWork.id))
        fetch.fetchLimit = 1
        
        if let data = try? coreDataProperties.mainContext.fetch(fetch) {
            if let firstData = data.first {
                let pointManager = PointCDManager()
                pointManager.coreDataProperties = self.coreDataProperties
                
                if let pointCreated = pointManager.createIfNeeded(with: point) {
                    firstData.addToPoints(pointCreated)
                }
                
                if let error = try? coreDataProperties.saveContext() {
                    return completionHandler(error)
                }
                return completionHandler(nil)
            }
            return completionHandler(.dataNotFound)
        }
        return completionHandler(.fetchError)
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Transforma a entidade do core date para o modelo (struct)
    /// - Parameter entity: a entidade
    /// - Returns: modelo
    private func transformToModel(entity: DBDayWork) -> ManagedDayWork {
        return ManagedDayWork(
            id: entity.id,
            date: entity.date,
            startTime: entity.startTime,
            endTime: entity.endTime,
            points: entity.getPoints.map() {
                PointCDManager.transformToModel(entity: $0)
            }
        )
    }
}
