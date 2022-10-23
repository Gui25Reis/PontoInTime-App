/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreData.UUID


/// Informações de um dia
struct ManagedDayWork {
    let id: UUID?
    let date: String
    let startTime: String
    let endTime: String
    let points: [ManagedPoint]
    
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
