import Foundation
import SwiftData

@Model
class Anchor {
    var text: String
    var category: String
    var linkedProcess: String?
    var isDefault: Bool
    var createdAt: Date

    init(text: String, category: String, linkedProcess: String? = nil, isDefault: Bool = false, createdAt: Date = .now) {
        self.text = text
        self.category = category
        self.linkedProcess = linkedProcess
        self.isDefault = isDefault
        self.createdAt = createdAt
    }

    static let defaults: [Anchor] = [
        // Patron emocional
        Anchor(text: "Lo que siento es valido, pero no siempre es verdad", category: "Patron emocional", linkedProcess: "patron", isDefault: true),
        Anchor(text: "No todo lo que pienso cuando estoy alterado es real", category: "Patron emocional", linkedProcess: "patron", isDefault: true),
        Anchor(text: "Estoy sintiendo miedo, no realidad", category: "Patron emocional", linkedProcess: "patron", isDefault: true),
        Anchor(text: "Mi mente esta interpretando, no informando", category: "Patron emocional", linkedProcess: "patron", isDefault: true),
        Anchor(text: "La emocion pasara, no tomes decisiones ahora", category: "Patron emocional", linkedProcess: "patron", isDefault: true),
        Anchor(text: "Nombra lo que sientes: eso le quita poder", category: "Patron emocional", linkedProcess: "patron", isDefault: true),

        // Control y soltar
        Anchor(text: "No necesito controlar para que funcione", category: "Control y soltar", linkedProcess: "cambiar", isDefault: true),
        Anchor(text: "Soltar no es perder, es dejar fluir", category: "Control y soltar", linkedProcess: "cambiar", isDefault: true),
        Anchor(text: "No necesito actuar ahora", category: "Control y soltar", linkedProcess: "protocolo", isDefault: true),
        Anchor(text: "Puedo sentir sin reaccionar", category: "Control y soltar", linkedProcess: "protocolo", isDefault: true),
        Anchor(text: "La urgencia es una ilusion de la ansiedad", category: "Control y soltar", linkedProcess: "cambiar", isDefault: true),
        Anchor(text: "Esperar no es debilidad, es estrategia", category: "Control y soltar", linkedProcess: "protocolo", isDefault: true),

        // Sobre la relacion
        Anchor(text: "Que ella este bien sin mi no significa que me pierde", category: "Relacion", linkedProcess: "aleja_acerca", isDefault: true),
        Anchor(text: "Presionar la aleja, la calma la acerca", category: "Relacion", linkedProcess: "aleja_acerca", isDefault: true),
        Anchor(text: "No se rompio solo el vinculo, se rompio como lo sostengo", category: "Relacion", linkedProcess: "rompio", isDefault: true),
        Anchor(text: "No necesito recuperarla, necesito no perderme a mi", category: "Relacion", linkedProcess: "cambiar", isDefault: true),
        Anchor(text: "Ella vuelve si siente estabilidad, no si siente presion", category: "Relacion", linkedProcess: "aleja_acerca", isDefault: true),
        Anchor(text: "Mi amor no se demuestra con intensidad, sino con calma", category: "Relacion", linkedProcess: "aleja_acerca", isDefault: true),

        // Crecimiento
        Anchor(text: "No necesito correr, necesito sostener", category: "Crecimiento", linkedProcess: "cambiar", isDefault: true),
        Anchor(text: "Mi sanacion no pasa por acercarme a ella, sino a mi", category: "Crecimiento", linkedProcess: "rompio", isDefault: true),
        Anchor(text: "Volver sin transformarme es repetir el mismo final", category: "Crecimiento", linkedProcess: "rompio", isDefault: true),
        Anchor(text: "Mi valor no depende de si ella esta o no", category: "Crecimiento", linkedProcess: "cambiar", isDefault: true),
        Anchor(text: "Hoy elijo claridad, no reaccion", category: "Crecimiento", linkedProcess: "protocolo", isDefault: true),
        Anchor(text: "Estabilidad es mi superpoder", category: "Crecimiento", linkedProcess: "cambiar", isDefault: true),
        Anchor(text: "Cada vez que no reacciono, me hago mas fuerte", category: "Crecimiento", linkedProcess: "protocolo", isDefault: true),
        Anchor(text: "El cambio real es silencioso y constante", category: "Crecimiento", linkedProcess: "cambiar", isDefault: true),
    ]
}
