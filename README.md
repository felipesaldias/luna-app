# Luna

App iOS personal para manejar la ansiedad, evitar reaccionar impulsivamente, y hacer seguimiento del proceso emocional.

El nombre viene de la carta de La Luna del tarot: confundir emocion con realidad.

## Funcionalidades

### Protocolo de emergencia
Flujo guiado de 5 pasos para cuando sientes algo fuerte:

1. **Pausa** — timer de 30 segundos, no hagas nada, respira
2. **Hecho vs Historia** — separa lo que paso realmente de lo que estas interpretando
3. **Regulacion** — haz algo fisico antes de pensar en actuar (caminar, respirar, ejercicio)
4. **Evaluacion** — ahora que estas mas tranquilo, lo que sentiste sigue siendo real?
5. **Decision** — vale la pena actuar? si es desde el miedo, no actues

Al terminar se guarda automaticamente en el diario.

### Diario emocional
Formulario estructurado para registrar cada episodio:

- Gatillo (que lo disparo)
- Emocion y su intensidad (1-5)
- Hecho vs historia mental
- Si actuaste o no, y desde donde (miedo o claridad)
- Como termino
- Que aprendiste

Incluye estadisticas: frecuencia de gatillos, ratio de control, patrones por emocion.

### Mi Proceso
Todo lo aprendido organizado por temas:

- **Mi patron emocional** — como funciona el gatillo y el ciclo de autosabotaje
- **Lo que se rompio** — no solo el vinculo, sino la forma de sostenerlo
- **Lo que debo cambiar** — dejar de creer todo lo que pienso cuando estoy emocional
- **Lo que aleja vs lo que acerca** — presion vs calma, intensidad vs estabilidad
- **Protocolo Rey de Espadas** — pausa, hecho vs historia, regular, esperar, actuar consciente

### Anclas
25+ frases organizadas por categoria:

- Patron emocional
- Control y soltar
- Relacion
- Crecimiento

Cada frase esta linkeada a su tema en Mi Proceso. Puedes agregar tus propias frases.

**Notificaciones locales** configurables:
- Modo automatico: elige cuantas al dia y el rango de horas
- Modo exacto: configura cada horario con hora y minuto especifico
- Hasta 10 notificaciones diarias

### Widget
Widget para la home screen que abre directamente el protocolo de emergencia. Un toque y estas en el flujo guiado.

## Stack

- **SwiftUI** — iOS 26+
- **SwiftData** — datos locales en el telefono
- **WidgetKit** — widget de home screen
- **UNUserNotificationCenter** — notificaciones locales (sin servidor)

100% local. Sin backend, sin login, sin internet.

## Estructura

```
Luna/
  App/LunaApp.swift                    # Entry point con deep link support
  Models/
    JournalEntry.swift                 # Modelo del diario (SwiftData)
    Anchor.swift                       # Modelo de frases ancla (SwiftData)
  Content/
    ProcessContent.swift               # Textos de Mi Proceso
  Views/
    MainTabView.swift                  # 4 tabs
    Protocol/
      ProtocolView.swift               # Pantalla principal del protocolo
      ProtocolFlowView.swift           # Flujo guiado paso a paso
      PauseStepView.swift              # Timer de pausa
    Journal/
      JournalView.swift                # Lista de entradas
      JournalFormView.swift            # Formulario estructurado
      JournalDetailView.swift          # Detalle de entrada
      JournalStatsView.swift           # Estadisticas y patrones
    Process/
      ProcessView.swift                # Lista de temas
      ProcessDetailView.swift          # Contenido de cada tema
    Anchors/
      AnchorsView.swift                # Lista de frases por categoria
      AddAnchorView.swift              # Agregar frase nueva
      NotificationSettingsView.swift   # Config de notificaciones
LunaWidget/
  LunaWidget.swift                     # Widget de home screen
```

## Setup

1. `brew install xcodegen` (si no lo tienes)
2. `xcodegen generate`
3. Abrir `Luna.xcodeproj` en Xcode
4. Signing & Capabilities → seleccionar tu Team
5. Conectar iPhone → Cmd+R

## Widget

Despues de instalar la app:

1. Manten presionado el fondo del home screen
2. Toca "+" arriba a la izquierda
3. Busca "Luna"
4. Agrega el widget pequeno
5. Toca el widget → abre el protocolo directo

## Filosofia

> "Lo que siento es valido, pero no siempre es verdad."

Esta app no es para eliminar emociones. Es para no actuar desde ellas sin filtro. Es un entrenamiento: sentir sin reaccionar, pensar sin sobreanalizar, actuar desde la claridad.
