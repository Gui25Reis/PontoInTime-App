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
    /// - Parameter handler: em caso de sucesso retorna as configurações
    public func getAllData(_ handler: @escaping (Result<[ManagedDayWork], ErrorCDHandler>) -> Void) {
        let fetch = DBDayWork.fetchRequest()

        guard let data = try? self.coreDataProperties?.mainContext.fetch(fetch)
        else { return handler(.failure(.fetchError)) }
        
        let allData = data.map { self.transformToModel(entity: $0) }
        return handler(.success(allData))
    }
    
    
    /// Pega dados de um dia específico
    /// - Parameters:
    ///   - date: dia
    ///   - handler: em caso de sucesso retorna as informações
    public func getData(for date: String) -> (data: ManagedDayWork?, error: ErrorCDHandler?) {
        guard let coreDataProperties else { return (data: nil, error: .protocolNotSetted) }
        
        let fetch = DBDayWork.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K == '\(date)'", #keyPath(DBDayWork.date))
        fetch.fetchLimit = 1
        
        guard let data = try? coreDataProperties.mainContext.fetch(fetch)
        else { return (data: nil, error: .fetchError) }
        
        if data.isEmpty { return (data: nil, error: .dataNotFound) }
        
        let managedData = self.transformToModel(entity: data[0])
        return (data: managedData, error: nil)
    }
    
    
    /// Adiciona um novo dado
    /// - Parameters:
    ///   - data: dado que vai ser adionado
    ///   - handler: gera um erro caso tenha algum problema no processo
    public func createData(with data: ManagedDayWork, _ handler: @escaping (_ error: ErrorCDHandler?) -> Void) {
        guard let coreDataProperties else { return handler(.protocolNotSetted) }
        
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
        let result = try? coreDataProperties.saveContext()
        return handler(result)
    }
    
    
    /// Adiciona um novo ponto no dia
    /// - Parameters:
    ///   - dataID: id do dia (que vai ser adicionado)
    ///   - point: ponto que vai ser adicionado
    ///   - handler: gera um erro caso tenha algum problema no processo
    public func addNewPoint(in dataID: UUID, point: ManagedPoint, _ handler: @escaping (_ error: ErrorCDHandler?) -> Void) {
        guard let coreDataProperties else { return handler(.protocolNotSetted) }
        
        let fetch = DBDayWork.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K == '\(dataID)'", #keyPath(DBDayWork.id))
        fetch.fetchLimit = 1
        
        guard let data = try? coreDataProperties.mainContext.fetch(fetch)
        else { return handler(.fetchError) }
        
        guard let firstData = data.first else { return handler(.dataNotFound) }
        
        let pointManager = PointCDManager()
        pointManager.coreDataProperties = self.coreDataProperties
        
        if let pointCreated = pointManager.createIfNeeded(with: point) {
            firstData.addToPoints(pointCreated)
        }
        
        let save = try? coreDataProperties.saveContext()
        handler(save)
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
