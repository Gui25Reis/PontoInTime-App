/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


protocol MenuControllerProtocol: NSObject {
    
    func setupInitalData(with data: ManagedPoint)
}


/// Controller responsável pela primeira tela da aplicação
class MenuController: UIViewController, MenuControllerProtocol {
    
    /* MARK: - Atributos */

    /* View */

    /// View principal que a classe vai controlar
    private let myView = MenuView()
    
    
    /* Delegate & Data Sources */
    
    private let infoDataSource = InfoMenuDataSource()
    
    
    /* Outros */
    
    private let dateManager = DateManager()
    
    
    
    /* MARK: - Construtor */
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
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
    
    

    /* MARK: - Ações de botões */
    
    /// Ação do botão de abrir a tela de ajustes
    @objc private func openSettingsPage() {
        let vc = SettingsController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// Ação do botão de abrir a tela de criação de um ponto
    @objc private func createNewWorkPage() {
        let vc = PointInfoController()
        vc.menuControllerProtocol = self
        
        let navBar = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navBar, animated: true)
    }
    
    
    /// Ação do botão de atualizar o timer
    @objc func updateTimer() {
        self.dateManager.updateTimerValue()
        
        let actualTime = self.dateManager.getActualCountdown()
        
        self.myView.updateTimerText(for: actualTime)
        
        if actualTime == "00:00:00" {
            self.dateManager.stopTimer()
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
        self.myView.setDataSource(with: self.infoDataSource)
    }
    
    
   
    private func setupTableData(with data: ManagedDayWork) {
        self.infoDataSource.mainData = data
        self.myView.reloadTableData()
    }
    
    
    private func checkForTodayData() {
        let today = Date().getDateFormatted(with: .hms)
        
        CDManager.shared.getTodayDayWorkData() { result in
            switch result {
            case .success(let data):
                self.setupDayWork(with: data)
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    ///
    private func createDayWork(with point: ManagedPoint) {
        let today = Date()
        let endDate = self.dateManager.sumTime(in: today, at: .hour, with: 8)
        
        let dayWork = ManagedDayWork(
            id: UUID(),
            date: today.getDateFormatted(with: .dma),
            startTime: today.getDateFormatted(with: .hm),
            endTime: endDate?.getDateFormatted(with: .hm) ?? "",
            points: [point]
        )
        
        self.setupDayWork(with: dayWork)
    }
    
    
    private func setupDayWork(with data: ManagedDayWork) {
        self.myView.hasData = true
        self.setupTableData(with: data)
        self.setupDataManager(with: data)
    }
    
    
    private func setupDataManager(with data: ManagedDayWork) {
        guard
            let startDate = Date.getDate(with: data.startTime, formatType: .hm),
            let endData = Date.getDate(with: data.endTime, formatType: .hm)
        else { return }
        
        self.dateManager.startDate = startDate
        self.dateManager.endDate = endData
        
        self.dateManager.startTimer()
    }
}
