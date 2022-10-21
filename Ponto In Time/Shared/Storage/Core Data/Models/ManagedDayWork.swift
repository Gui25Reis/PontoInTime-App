/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreData.UUID


/// Informações de um dia
struct ManagedDayWork {
    let id: UUID
    let date: String
    let startTime: String
    let endTime: String
    let points: [ManagedPoint]
}
