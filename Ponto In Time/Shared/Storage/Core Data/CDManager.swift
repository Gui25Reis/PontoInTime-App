/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import CoreData


class CDManager: NSObject, CoreDataProperties {
    
    /* MARK: - Atributos */
    
    static let shared = CDManager()
    
    
    /* Managers */
    
    private let settingsManager = SettingsCDManager()
    
    private let dayWorkManager = DayWorkCDManager()
    
    private let pointTypeManager = PointTypeCDManager()
    
    
    
    /* MARK: - Construtor */
    
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
    
    public func getSettingsData(_ completionHandler: @escaping (Result<SettingsData, ErrorCDHandler>) -> Void) {
        self.mainContext.perform {
            var settingsData = SettingsData()
            
            // Dados de configuração
            self.settingsManager.getSettingsData() { result in
                switch result {
                case .success(let data):
                    settingsData.settingsData = data
                case .failure(let failure):
                    completionHandler(.failure(failure))
                }
            }
            
            // Tipos de pontos
            self.pointTypeManager.getAllData() { result in
                switch result {
                case .success(let data):
                    settingsData.pointTypeData = data
                case .failure(let failure):
                    completionHandler(.failure(failure))
                }
            }
            
            completionHandler(.success(settingsData))
        }
    }
    
    
    /* Dias trabalhos */
    
    public func getTodayDayWorkData(_ completionHandler: @escaping (Result<ManagedDayWork, ErrorCDHandler>) -> Void) {
        self.mainContext.perform {
            self.dayWorkManager.getData(for: "") { result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let failure):
                    completionHandler(.failure(failure))
                }
            }
        }
    }
    
    
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
    
    
    /* Tipos de ponto */
    
    
    /* MARK: - Configurações */
    
    private func setupProtocols() {
        self.settingsManager.coreDataProperties = self
        self.dayWorkManager.coreDataProperties = self
        self.pointTypeManager.coreDataProperties = self
    }
}
