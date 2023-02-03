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
    
    /// Lida com os dados dos tipos de pontos
    private lazy var pointManager = PointCDManager()
    
    /// Lida com os arquivos
    private lazy var fileManager = FilesCDManager()
    
    
    
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
        guard self.mainContext.hasChanges else { print("Não teve mudanças"); return nil }
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
        
        return (data: data, error: nil)
    }
    
    
    /// Atualiza o valor da horas de trabalho
    /// - Parameter data: novo dado
    /// - Returns: possível erro
    public func updateWorkHour(with data: String) -> ErrorCDHandler? {
        guard var settings = self.settingsManager.cache else { return .dataNotFound }
        settings.timeWork = data
        
        let update = self.settingsManager.updateSettings(with: settings)
        return update
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
    public func getAllDayWorkData(_ handler: @escaping (Result<[ManagedDayWork], ErrorCDHandler>) -> Void) {
        self.mainContext.perform {
            self.dayWorkManager.getAllData() { result in
                switch result {
                case .success(let success):
                    handler(.success(success))
                case .failure(let failure):
                    handler(.failure(failure))
                }
            }
        }
    }
    
    
    /// Cria um novo dia
    /// - Parameters:
    ///   - data: dados do dia
    ///   - completionHandler: gera um erro caso tenha algum problema no processo
    public func createNewDayWork(with data: ManagedDayWork, _ handler: @escaping (_ error: ErrorCDHandler?) -> Void) {
        self.mainContext.perform {
            self.dayWorkManager.createData(with: data) { error in
                return handler(error)
            }
        }
    }
    
    
    /// Adiciona um novo ponto no dia
    /// - Parameters:
    ///   - dataID: id do dia (que vai ser adicionado)
    ///   - point: ponto que vai ser adicionado
    ///   - completionHandler: gera um erro caso tenha algum problema no processo
    public func addNewPoint(in dataID: UUID, point: ManagedPoint, _ handler: @escaping (_ error: ErrorCDHandler?) -> Void) {
        self.mainContext.perform {
            self.dayWorkManager.addNewPoint(in: dataID, point: point) { error in
                return handler(error)
            }
        }
    }
    
    
    
    public func updatePoint(id: UUID, newData: ManagedPoint, filesToAdd: [ManagedFiles]) -> ErrorCDHandler? {
        var files: [ManagedFiles]? = filesToAdd
        if filesToAdd.isEmpty { files = nil }
        
        let update = self.pointManager.updateData(at: id, newData: newData, files: files)
        return update
    }
    
    
    
    public func deletePoint(_ point: ManagedPoint) -> ErrorCDHandler? {
        let error = self.pointManager.deletePoint(id: point.uuid)
        return error
    }
    
    
    
    /* MARK: Tipos de pontos */
    
    /// Retorna todos os tipos de pontos que existem
    /// - Parameter completionHandler: em caso de sucesso retorna o dado do dia
    public func getAllPointType() -> [ManagedPointType]? {
        let (data, _) = self.pointTypeManager.getAllData()
        
        return data
    }
    
    
    /// Adiciona um novo tipo de ponto
    /// - Parameter name: nome do ponto
    /// - Returns: um eror caso tenha
    public func addNewPointType(name: String) -> ErrorCDHandler? {
        let data = ManagedPointType(title: name)
        
        let (_, error) = self.pointTypeManager.createIfNeeded(with: data)
        if let error { return error }
        
        let save = try? self.saveContext()
        return save
    }
    
    
    /// Atualiza um tipo de ponto
    /// - Parameter data: dados
    /// - Returns: um error caso tenha
    public func updatePointType(with data: DataEdited) -> ErrorCDHandler? {
        guard let oldData = data.oldData, let newData = data.newData
        else { return .dataNotFound }
        
        let old = ManagedPointType(title: oldData)
        let new = ManagedPointType(title: newData)
        
        let update = self.pointTypeManager.update(oldData: old, newData: new)
        return update
    }
    
    
    /// Deleta um tipo de ponto
    /// - Parameter name: nome do ponto
    /// - Returns: um error caso tenha
    public func deletePointType(at data: String) -> ErrorCDHandler? {
        let managed = ManagedPointType(title: data)
        
        let delete = self.pointTypeManager.delete(with: managed)
        return delete
    }
    
    
    
    /* MARK: Arquivos */
    
    /// Deleta uma arquivo co dore data e do dispositivo
    /// - Parameter file: dados do arquivo
    /// - Returns: um error caso tenha
    public func deleteFiles(_ files: [ManagedFiles]) -> ErrorCDHandler? {
        let delete = self.fileManager.deleteFiles(with: files)
        
        var error: ErrorCDHandler? = nil
        files.forEach() {
            let deleteFromDisk = UIImage.deleteFromDisk(imageName: $0.link)
            if !deleteFromDisk { error = .deleteError }
        }
        
        guard let error else { return delete }
        return error
    }

    
    
    /* MARK: - Configurações */
    
    /// Configura os protocolos dos atributos
    private func setupProtocols() {
        self.settingsManager.coreDataProperties = self
        self.dayWorkManager.coreDataProperties = self
        self.pointTypeManager.coreDataProperties = self
        self.fileManager.coreDataProperties = self
        self.pointManager.coreDataProperties = self
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
