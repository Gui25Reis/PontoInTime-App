/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import struct Foundation.Selector


/// Salva o alvo e a função de uma ação
struct ActionSetup {
    let target: Any
    let action: Selector
}
