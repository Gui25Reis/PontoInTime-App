/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import CoreData
import UIKit


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
    
    /// Restringe o uso da classe para o singleton
    override private init() {
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
        if self.mainContext.hasChanges {
            do {
                try self.mainContext.save()
            } catch {
                throw ErrorCDHandler.saveError
            }
        }
        return nil
    }
    
    
    /* MARK: - Encapsulamento */
    
    /* MARK: Ajustes */
    
    /// Retorna os dados de ajustes
    /// - Parameter completionHandler: em caso de sucesso retorna os dados
    public func getSettingsData(_ completionHandler: @escaping (Result<SettingsData, ErrorCDHandler>) -> Void) {
        if let cache = self.settingsManager.cache {
            return completionHandler(.success(cache))
        }
        
        self.mainContext.perform {
            var settingsData = SettingsData()
            
            // Tipos de pontos
            self.pointTypeManager.getAllData() { result in
                switch result {
                case .success(let data):
                    settingsData.pointTypeData = data
                case .failure(let failure):
                    completionHandler(.failure(failure))
                }
            }
            
            // Dados de configuração
            self.settingsManager.getSettingsData() { result in
                switch result {
                case .success(let data):
                    settingsData.settingsData = data
                case .failure(let failure):
                    completionHandler(.failure(failure))
                }
            }
            
            completionHandler(.success(settingsData))
            self.settingsManager.cache = settingsData
            return
        }
    }
    
    
    /* MARK: Dias trabalhados */
    
    /// Retorna os dados do dia
    /// - Parameter completionHandler: em caso de sucesso retorna o dado do dia
    ///
    /// Caso não encontre o dado do dia vai ser gerado um erro de `dataNotFound`.
    public func getTodayDayWorkData(_ completionHandler: @escaping (Result<ManagedDayWork, ErrorCDHandler>) -> Void) {
        self.mainContext.perform {
            let today = Date().getDateFormatted(with: .dma)
            self.dayWorkManager.getData(for: today) { result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let failure):
                    completionHandler(.failure(failure))
                }
            }
        }
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
            self.dayWorkManager.addNewPoint(in: dataID, point: point){ error in
                return completionHandler(error)
            }
        }
    }
    
    
    
    /* MARK: Tipos de pontos */
    
    /// Retorna todos os tipos de pontos que existem
    /// - Parameter completionHandler: em caso de sucesso retorna o dado do dia
    public func getAllPointType(_ completionHandler: @escaping (Result<[ManagedPointType], ErrorCDHandler>) -> Void) -> [ManagedPointType]? {
        
        if let cache = self.settingsManager.cache?.pointTypeData {
            return cache
        }
        
        self.mainContext.perform {
            self.pointTypeManager.getAllData() { result in
                switch result {
                case .success(let data):
                    self.settingsManager.cache?.pointTypeData = data
                    completionHandler(.success(data))

                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
        
        return nil
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
        
        return alert
    }
}
