/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import struct Foundation.Selector


/// Salva o alvo e a função de uma ação
struct ActionSetup {
    let target: Any
    let action: Selector
}
