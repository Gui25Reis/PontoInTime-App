/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreData.UUID


/// Informações de um dia
struct ManagedDayWork {
    
    /* MARK: - Atributos */
    
    let id: UUID
    let date: String
    var startTime: String
    var endTime: String
    var points: [ManagedPoint]
    
    
    
    /* MARK: - Construtor */
    
    // Cria para mandar para o Core Data
    init(date: String, startTime: String, endTime: String, points: [ManagedPoint]) {
        self.id = UUID()
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.points = points
    }
    
    
    // Vem do Core Data
    init(id: UUID, date: String, startTime: String, endTime: String, points: [ManagedPoint]) {
        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.points = points
    }
}
