/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreData.UUID


/// Informações de um dia
struct ManagedDayWork {
    
    /* MARK: - Atributos */
    
    let id: UUID?
    let date: String
    var startTime: String
    var endTime: String
    var points: [ManagedPoint]
    
    
    
    /* MARK: - Construtor */
    
    init(date: String, startTime: String, endTime: String, points: [ManagedPoint]) {
        self.id = nil
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.points = points
    }
    
    
    init(id: UUID, date: String, startTime: String, endTime: String, points: [ManagedPoint]) {
        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.points = points
    }
}
