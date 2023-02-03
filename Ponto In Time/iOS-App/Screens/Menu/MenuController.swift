/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.NSCoder
import struct Foundation.Date

import class UIKit.UIBarButtonItem
import class UIKit.UIImage
import class UIKit.UINavigationController
import class UIKit.UIViewController


/// Controller responsável pela primeira tela da aplicação
class MenuController: UIViewController, ControllerActions, ViewWithDayWorkInfoDelegate {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = MenuView()
    
    
    /* Handlers */
    
    /// Handler da tabela
    private let tableInfosHandler = InfoMenuTableHandler()
    
    
    /* Outros */
    
    /// Lida com as datas
    private let dateManager = DateManager()
    
    /// Diz se já possui dados na tabela
    private var hasData: Bool?
    
    
    
    /* MARK: - Ciclo de Vida */
    
    override func loadView() {
        self.view = self.myView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupController()
        self.checkForTodayData()
    }
    


    /* MARK: - Protocolo */
    
    /* Controller Actions */
    
    internal func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(.settings), style: .plain,
            target: self, action: #selector(self.openSettingsPage)
        )
    }

    
    internal func setupButtonsAction() {
        self.myView.setNewDayAction(target: self, action: #selector(self.createNewWorkPage))
        self.dateManager.setTimerAction(target: self, action: #selector(self.updateTimer))
    }
    
    
    internal func setupDelegates() {
        self.tableInfosHandler.alertHandler = self
        self.tableInfosHandler.dayWorkInfoDelegate = self
        self.tableInfosHandler.link(with: self.myView)
    }
    
    
    /* MenuControllerProcotocol */
    
    internal func setupInitalData(with data: ManagedPoint) {
        self.createDay(with: data)
    }
    
    
    internal func addNewPoint(with data: ManagedPoint) {
        self.updateTableData(with: data)
        self.saveIntoCoreData(data: data)
    }
    
    
    internal func showPointInfos(for data: ManagedPoint?) {
        let isNewData = data == nil
        self.openPointInfoPage(with: data, isNewData: isNewData)
    }
    
    
    internal func updatePointChanged(newPoint: ManagedPoint) {
        self.tableInfosHandler.updatePoint(with: newPoint)
        self.myView.reloadTableData()
    }
    
    
    internal func deletePointSelected() {
        guard let point = self.tableInfosHandler.deleteLastPointSelected() else { return }
        self.myView.reloadTableData()
        
        let error = CDManager.shared.deletePoint(point)
        self.showWarningPopUp(with: error)
    }
    
    

    /* MARK: - Ações de botões */
    
    /// Ação do botão de abrir a tela de ajustes
    @objc private func openSettingsPage() {
        let vc = SettingsController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// Ação do botão de abrir a tela de criação de um ponto
    @objc private func createNewWorkPage() {
        self.openPointInfoPage(with: nil)
    }
    
    
    /// Ação do botão de atualizar o timer
    @objc private func updateTimer() {
        self.dateManager.updateTimerValue()
        
        let actualTime = self.dateManager.getActualCountdown()
        self.myView.updateTimerText(for: actualTime)
        
        if actualTime == "00:00:00" {
            self.dateManager.stopTimer()
        }
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Abre a tela de informações de um ponto
    /// - Parameters:
    ///   - data: dado que a tela vai receber
    ///   - isNewData: caso seja para adicionar um novo dado
    private func openPointInfoPage(with data: ManagedPoint?, isNewData: Bool = false) {
        var vc = PointInfoController(with: data)
        if isNewData { vc = PointInfoController(isNewData: true) }
        
        vc.menuControllerProtocol = self
        
        if data == nil {
            let navBar = UINavigationController(rootViewController: vc)
            self.navigationController?.present(navBar, animated: true)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    /* MARK: Dados */
    
    /// Define os dados da tabela
    /// - Parameter data: dados que a tabela vai receber
    private func setupTableData(with data: ManagedDayWork) {
        self.tableInfosHandler.mainData = data
        self.myView.reloadTableData()
    }
    
    
    /// Atualiza o dado de pontos da tabela
    /// - Parameter data: pontos que vão ser adicionados
    private func updateTableData(with data: ManagedPoint) {
        var existData = self.tableInfosHandler.mainData?.points ?? []
        existData.append(data)
        
        self.tableInfosHandler.updatePointsData(with: existData)
        self.myView.reloadTableData()
    }
    
    
    /// Verifica se possui já possui dado do dia
    private func checkForTodayData() {
        let (data, _) = CDManager.shared.getTodayDayWorkData()
        
        if let data {
            self.setupDayWork(with: data)
            self.hasData = true
            return
        }
        
        self.hasData = false
        // self.showWarningPopUp(with: error)
    }
    
    
    /// Pega as informações necessárias para criar um novo dia
    /// - Parameter point: ponto inicial
    private func createDay(with point: ManagedPoint) {
        let (data, error) = CDManager.shared.getSettingsData()
        
        guard let data else { return self.showWarningPopUp(with: error) }
        
        guard let timeWork = Int(data.settingsData?.timeWork ?? "") else { return }
        self.createDayWork(point: point, timeWork: timeWork)
    }
    
    
    /// Cria os dados do dia
    /// - Parameter point: ponto inicial
    /// - Parameter timeWork: tempo de trabalho
    private func createDayWork(point: ManagedPoint, timeWork: Int) {
        guard
            let today = Date.getDate(with: point.time, formatType: .complete),
            let endDate = self.dateManager.sumTime(in: today, at: .hour, with: timeWork)
        else { return }
        
        let dayWork = ManagedDayWork(
            date: today.getDateFormatted(with: .dma),
            startTime: today.getDateFormatted(with: .hms),
            endTime: endDate.getDateFormatted(with: .hms),
            points: [point]
        )
        
        self.setupDayWork(with: dayWork)
        self.saveIntoCoreData(data: dayWork)
    }
    
    
    /// Configura a view para os dados do dia
    /// - Parameter data: dados do dia
    private func setupDayWork(with data: ManagedDayWork) {
        self.myView.hasData = true
        self.setupTableData(with: data)
        self.setupDataManager(with: data)
    }
    
    
    /// Configura as datas
    /// - Parameter data: dados do dia
    private func setupDataManager(with data: ManagedDayWork) {
        let nowStr = Date().getDateFormatted(with: .hms)
        guard
            let nowDate = Date.getDate(with: nowStr, formatType: .hms),
            let endData = Date.getDate(with: data.endTime, formatType: .hms)
        else { return }
        
        self.dateManager.startDate = nowDate
        self.dateManager.endDate = endData
        
        self.dateManager.startTimer()
    }
    
    
    /// Salva um dado no core data
    /// - Parameter data: dado que vai ser salvo
    private func saveIntoCoreData(data: Any) {
//        return
        if let point = data as? ManagedPoint, let id = self.tableInfosHandler.mainData?.id {
            CDManager.shared.addNewPoint(in: id, point: point) { error in
                self.showWarningPopUp(with: error)
            }
        } else
            
        if let dayWork = data as? ManagedDayWork {
            CDManager.shared.createNewDayWork(with: dayWork) { error in
                self.showWarningPopUp(with: error)
            }
        }
    }
}
