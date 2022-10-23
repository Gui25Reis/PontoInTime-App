/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


protocol MenuControllerProtocol: NSObject {
    
    func setupInitalData(with data: ManagedPoint)
    
    func addNewPoint(with data: ManagedPoint)
    
    func cellClicked(at indexPath: IndexPath)
}


/// Controller responsável pela primeira tela da aplicação
class MenuController: UIViewController, MenuControllerProtocol {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = MenuView()
    
    
    /* Delegate & Data Sources */
    
    private let infoDataSource = InfoMenuDataSource()
    
    private let infoDelegate = InfoMenuDelegate()
    
    
    /* Outros */
    
    private let dateManager = DateManager()
    
    
    private var hasData: Bool?
    
    
    
    /* MARK: - Construtor */
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.checkForTodayData()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    

		
    /* MARK: - Ciclo de Vida */
    
    override func loadView() {
        self.view = self.myView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.setupDelegates()
        self.setupButtonsAction()
    }
    


    /* MARK: - Protocolo */
    
    internal func setupInitalData(with data: ManagedPoint) {
        self.createDayWork(with: data)
    }
    
    
    internal func addNewPoint(with data: ManagedPoint) {
        self.updateTableData(with: data)
        
        if let id = self.infoDataSource.mainData?.id {
            CDManager.shared.addNewPoint(in: id, point: data) { result in
                switch result {
                case .success(_):
                    print("Deu bom")
                case .failure(let error):
                    print("Erros:\n\(error)")
                }
            }
        }
        
    }
    
    
    internal func cellClicked(at indePath: IndexPath) {
        let row = indePath.row
        
        switch indePath.section {
        case 0: // Info
            return
            
        case 1: // Pontos
            if row < self.infoDataSource.actionIndex {
                let data = self.infoDataSource.mainData?.points[row]
                self.openPointInfoPage(with: data)
                return
            }
            
            if row == self.infoDataSource.actionIndex {
                self.openPointInfoPage(with: nil, isNewData: true)
            } else {
                print("Quer finalizar o dia")
            }
            
            return
            
        default:
            break
        }
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
    
    
    private func openPointInfoPage(with data: ManagedPoint?, isNewData: Bool = false) {
        var vc: PointInfoController
        
        if isNewData {
            vc = PointInfoController(isNewData: true)
        } else {
            vc = PointInfoController(with: data)
        }
        
        if data == nil {
            vc.menuControllerProtocol = self
            let navBar = UINavigationController(rootViewController: vc)
            self.navigationController?.present(navBar, animated: true)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    /* MARK: - Configurações */

    /// Configurções da navigation controller
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(.settings), style: .plain,
            target: self, action: #selector(self.openSettingsPage)
        )
    }

    
    /// Definindo as ações dos botões
    private func setupButtonsAction() {
        self.myView.setNewDayAction(target: self, action: #selector(self.createNewWorkPage))
        self.dateManager.setTimerAction(target: self, action: #selector(self.updateTimer))
    }
    
    
    /// Definindo os delegates, data sources e protocolos
    private func setupDelegates() {
        self.infoDelegate.menuControllerProtocol = self
        
        self.myView.setDataSource(with: self.infoDataSource)
        self.myView.setDelegate(with: self.infoDelegate)
    }
    
    
    private func setupTableData(with data: ManagedDayWork) {
        self.infoDataSource.mainData = data
        self.myView.reloadTableData()
    }
    
    
    private func updateTableData(with data: ManagedPoint) {
        var existData = self.infoDataSource.mainData?.points ?? []
        existData.append(data)
        self.infoDataSource.updatePointsData(with: existData)
        self.myView.reloadTableData()
    }
    
    
    private func checkForTodayData() {
        CDManager.shared.getTodayDayWorkData() { result in
            switch result {
            case .success(let data):
                self.setupDayWork(with: data)
                self.hasData = true
            case .failure(let error):
                self.hasData = false
                
                print(error.description)
                CDManager.shared.getAllDayWorkData() { result in
                    switch result {
                    case .success(let data):
                        print("Dados no core data:", data)
                    case .failure(let error):
                        print(error.description)
                    }
                }
            }
        }
    }
    
    ///
    private func createDayWork(with point: ManagedPoint) {
        let today = Date.getDate(with: point.time, formatType: .hms) ?? Date()
        let endDate = self.dateManager.sumTime(in: today, at: .hour, with: 8)
        
        let dayWork = ManagedDayWork(
            date: today.getDateFormatted(with: .dma),
            startTime: today.getDateFormatted(with: .hms),
            endTime: endDate?.getDateFormatted(with: .hms) ?? "",
            points: [point]
        )
        
        self.setupDayWork(with: dayWork)
        
        // Salva no core data
        CDManager.shared.createNewDayWork(with: dayWork) { result in
            switch result {
            case .success(_):
                print("Salvou")
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    
    private func setupDayWork(with data: ManagedDayWork) {
        self.myView.hasData = true
        self.setupTableData(with: data)
        self.setupDataManager(with: data)
    }
    
    
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
}
