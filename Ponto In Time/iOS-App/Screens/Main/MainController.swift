/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIColor
import class UIKit.UINavigationController
import class UIKit.UITabBarController
import class UIKit.UIViewController


/// Controller principal usada para a criação da tab bar
class MainController: UITabBarController {

    /* MARK: - Ciclo de Vida */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTab()
        self.setupControllers()
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configurações iniciais da Tab Bar
    private func setupTab() {
        self.tabBar.backgroundColor = UIColor(.safeAreaColor)?.withAlphaComponent(0.95)
    }
    
    
    /// Define as controllers que vão aparecer na Tab Bar
    private func setupControllers() {
        self.viewControllers = [
            self.getMenuNavigation(),
            self.getHistoricNavigation()
        ]
    }

    
    /// Cria uma navigation controller para a tela 01 (Menu)
    /// - Returns: nav controller
    private func getMenuNavigation() -> UINavigationController {
        let vc = MenuController()
        vc.setupTab(text: "Seu dia", icon: .menuPage)
        
        return self.getNavigation(for: vc)
    }
    
    
    /// Cria uma navigation controller para a tela 02 (Histórico)
    /// - Returns: nav controller
    private func getHistoricNavigation() -> UINavigationController {
        let vc = HistoricController()
        vc.setupTab(text: "Histórico", icon: .historicPage)
        
        return self.getNavigation(for: vc)
    }
    
    
    /// Cria uma navigation controller para uma view controller
    /// - Parameter vc: controller que vai receber a navigation contgroller
    /// - Returns: nav controller
    private func getNavigation(for vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        nav.pushViewController(vc, animated: true)
        
        return nav
    }
}
