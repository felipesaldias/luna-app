import Foundation
import SwiftData

@Model
class Promise {
    var text: String
    var category: String
    var isDefault: Bool
    var createdAt: Date
    var brokenCount: Int

    init(text: String, category: String, isDefault: Bool = false, createdAt: Date = .now, brokenCount: Int = 0) {
        self.text = text
        self.category = category
        self.isDefault = isDefault
        self.createdAt = createdAt
        self.brokenCount = brokenCount
    }

    static let defaults: [Promise] = [
        Promise(text: "No cuestionar sus amistades ni salidas", category: "Relacion", isDefault: true),
        Promise(text: "No preguntar si la han joteado", category: "Relacion", isDefault: true),
        Promise(text: "No hacer comentarios sobre su independencia", category: "Relacion", isDefault: true),
        Promise(text: "Respetar su tiempo con amigas sin hacerla sentir culpable", category: "Relacion", isDefault: true),
        Promise(text: "No tratar de controlar situaciones sociales", category: "Relacion", isDefault: true),

        Promise(text: "No asumir lo peor cuando no responde", category: "Mi cabeza", isDefault: true),
        Promise(text: "No crear historias sobre lo que esta haciendo", category: "Mi cabeza", isDefault: true),
        Promise(text: "No interpretar la distancia como abandono", category: "Mi cabeza", isDefault: true),
        Promise(text: "No actuar desde el miedo a perderla", category: "Mi cabeza", isDefault: true),
        Promise(text: "No prometer cambios por texto, demostrarlos con acciones", category: "Mi cabeza", isDefault: true),

        // Lo que voy a cambiar
        Promise(text: "Usar el protocolo cuando sienta ansiedad antes de actuar", category: "Cambios", isDefault: true),
        Promise(text: "Separar hecho de historia SIEMPRE", category: "Cambios", isDefault: true),
        Promise(text: "Darle espacio sin que tenga que pedirlo", category: "Cambios", isDefault: true),
        Promise(text: "Tiempo de calidad sin telefonos cuando estemos juntos", category: "Cambios", isDefault: true),
        Promise(text: "Trabajar mi ansiedad con terapeuta y con Luna", category: "Cambios", isDefault: true),
    ]
}
