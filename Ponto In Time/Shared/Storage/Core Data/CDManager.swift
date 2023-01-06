/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class CoreData.NSManagedObjectContext
import class CoreData.NSPersistentContainer

import class Foundation.NSError
import class Foundation.NSObject
import struct Foundation.Date
import struct Foundation.UUID

import class UIKit.UIAlertAction
import class UIKit.UIAlertController


/// Core Data Manager: classe principal que lida com o core data
class CDManager: NSObject, CoreDataProperties {
    
    /* MARK: - Atributos */
    
    /// Singleton para uso
    static let shared = CDManager()
    
    
    /* Managers */
    
    /// Lida com os dados de configurações/ajustes
    private lazy var settingsManager = SettingsCDManager()
    
    /// Lida com os dados dos dias trabalhados
    private lazy var dayWorkManager = DayWorkCDManager()
    
    /// Lida com os dados dos tipos de pontos
    private lazy var pointTypeManager = PointTypeCDManager()
    
    
    
    /* MARK: - Construtor */
    
    // Restringe o uso da classe para o singleton
    private override init() {
        super.init()
        self.setupProtocols()
    }
    
    
    
    /* MARK: - Protocol */
    
    internal var mainContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    
    internal lazy var container: NSPersistentContainer = {
        let coreDataFileName = "mainDataBase"
        let container = NSPersistentContainer(name: coreDataFileName)
        container.loadPersistentStores() {_, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    
    internal func saveContext() throws -> ErrorCDHandler? {
        guard self.mainContext.hasChanges else { return nil }
        do {
            try self.mainContext.save()
            return nil
        } catch {
            throw ErrorCDHandler.saveError
        }
    }
    
    
    /* MARK: - Encapsulamento */
    
    /* MARK: Ajustes */
    
    /// Retorna os dados de ajustes
    /// - Parameter completionHandler: em caso de sucesso retorna os dados
    public func getSettingsData() -> (data: SettingsData?, error: ErrorCDHandler?) {
        if let cache = self.settingsManager.cache { return (data: cache, error: nil) }
        
        // Pegando os dados
        let (pointsData, pointsError) = self.pointTypeManager.getAllData()
        guard let pointsData else { return (data: nil, error: pointsError) }
        
        let (settingsData, settingsError) = self.settingsManager.getSettingsData()
        guard let settingsData else { return (data: nil, error: settingsError) }
        
        // Criando resultado
        let data = SettingsData(
            settingsData: settingsData,
            pointTypeData: pointsData
        )
        
        self.settingsManager.cache = data
        return (data: data, error: nil)
        
    }
    
    
    /* MARK: Dias trabalhados */
    
    /// Retorna os dados do dia
    /// - Parameter completionHandler: em caso de sucesso retorna o dado do dia
    ///
    /// Caso não encontre o dado do dia vai ser gerado um erro de `dataNotFound`.
    public func getTodayDayWorkData() -> (data: ManagedDayWork?, error: ErrorCDHandler?) {
        let today = Date().getDateFormatted(with: .dma)
        
        let (data, error) = self.dayWorkManager.getData(for: today)
        return (data: data, error: error)
    }
    
    
    /// Retorna todos os dias criados
    /// - Parameter completionHandler: em caso de sucesso retorna os dados
    public func getAllDayWorkData(_ completionHandler: @escaping (Result<[ManagedDayWork], ErrorCDHandler>) -> Void) {
        self.mainContext.perform {
            self.dayWorkManager.getAllData() { result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let failure):
                    completionHandler(.failure(failure))
                }
            }
        }
    }
    
    
    /// Cria um novo dia
    /// - Parameters:
    ///   - data: dados do dia
    ///   - completionHandler: gera um erro caso tenha algum problema no processo
    public func createNewDayWork(with data: ManagedDayWork, _ completionHandler: @escaping (_ error: ErrorCDHandler?) -> Void) {
        self.mainContext.perform {
            self.dayWorkManager.createData(with: data) { error in
                return completionHandler(error)
            }
        }
    }
    
    
    /// Adiciona um novo ponto no dia
    /// - Parameters:
    ///   - dataID: id do dia (que vai ser adicionado)
    ///   - point: ponto que vai ser adicionado
    ///   - completionHandler: gera um erro caso tenha algum problema no processo
    public func addNewPoint(in dataID: UUID, point: ManagedPoint, _ completionHandler: @escaping (_ error: ErrorCDHandler?) -> Void) {
        self.mainContext.perform {
            self.dayWorkManager.addNewPoint(in: dataID, point: point) { error in
                return completionHandler(error)
            }
        }
    }
    
    
    
    /* MARK: Tipos de pontos */
    
    /// Retorna todos os tipos de pontos que existem
    /// - Parameter completionHandler: em caso de sucesso retorna o dado do dia
    public func getAllPointType() -> [ManagedPointType]? {
        if let cache = self.settingsManager.cache?.pointTypeData { return cache }
        
        let (data, _) = self.pointTypeManager.getAllData()
        self.settingsManager.cache?.pointTypeData = data
        
        return data
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configura os protocolos dos atributos
    private func setupProtocols() {
        self.settingsManager.coreDataProperties = self
        self.dayWorkManager.coreDataProperties = self
        self.pointTypeManager.coreDataProperties = self
    }
    
    
    
    /* MARK: - Errors */
    
    /// Cria um popup de aviso com o erro que aconteceu
    /// - Parameter error: erro
    /// - Returns: pop up com a mensagem do erro
    ///
    /// O pop up não é apresentado, apenas criado.
    static func createPopUpError(error: ErrorCDHandler) -> UIAlertController {
        let alert = UIAlertController(
            title: "Eita!",
            message: error.userWarning,
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        print(error.developerWarning)
        return alert
    }
}
