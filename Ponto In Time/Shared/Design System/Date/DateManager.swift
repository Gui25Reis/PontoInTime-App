/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import Foundation


class DateManager {
    
    /* MARK: - Atributos */
    
    /* Datas */
    
    /// Data inicial
    public var startDate = Date()
    
    /// Data final
    public var endDate = Date()
    
    /// Data entre a data inciial e final
    private var diferenceBetweenDates: Date?
    
    
    /* Timer */
    
    /// Timer
    private var timer: Timer?
    
    /// Valor do timer
    private var timerCount = 0
    
    /// Ação do timer
    private var timerAction: ActionSetup?
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Adiciona um tempo na data
    /// - Parameters:
    ///   - date: data que vai ser modificada
    ///   - component: componente da data que vai ser modificado
    ///   - time: tempo que vai ser somado
    /// - Returns: data alterada
    public func sumTime(in date: Date, at component: Calendar.Component, with time: Int) -> Date? {
        var components = DateComponents()
        
        switch component {
        case .second: components.second = time
        case .hour: components.hour = time
            
        default:
            return nil
        }
        
        return Calendar.current.date(byAdding: components, to: date)
    }
    
    
    /// Tempo que falta do timer
    /// - Returns: tempo em hora
    public func getActualCountdown() -> String {
        return self.getCountdown()
    }
    
    
    /* Timer */
    
    /// Define a ação do timer
    public func setTimerAction(target: Any, action: Selector) -> Void {
        self.timerAction = ActionSetup(target: target, action: action)
    }
    
    
    /// Atualiza o valor do timer
    public func updateTimerValue() {
        self.timerCount -= 1
    }
    
    
    /// Inicia o timer
    public func startTimer() {
        if let timerAction {
            self.timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: timerAction.target, selector: timerAction.action,
                userInfo: nil, repeats: true
            )
        }
    }
    
    
    /// Encerra o timer
    public func stopTimer() {
        self.timer?.invalidate()
    }
    
    

    /* MARK: - Configurações */
    
    /// Pega o tempo que falta entre as duas datas
    /// - Parameter recursion: caso de resursão
    /// - Returns: tempo em horas
    private func getCountdown(recursion: Bool = false) -> String {
        if let date = self.diferenceBetweenDates {
            let timeLeft = self.sumTime(in: date, at: .second, with: self.timerCount)
            return timeLeft?.getDateFormatted(with: .hms) ?? "00:00:00"
        }
        
        if recursion {
            return "00:00:00"
        }
        
        let difference = self.endDate.timeIntervalSinceReferenceDate - self.startDate.timeIntervalSinceReferenceDate
        let dateUTC = Date(timeIntervalSinceReferenceDate: difference)
        let dateGMT = self.sumTime(in: dateUTC, at: .hour, with: 3)     // Add 3 horas por causa da time zone
        
        self.diferenceBetweenDates = dateGMT
        return self.getCountdown(recursion: true)
    }
}
