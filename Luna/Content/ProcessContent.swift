import Foundation

struct ProcessTopic: Identifiable {
    let id: String
    let title: String
    let icon: String
    let content: String
}

struct ProcessContent {
    static let topics: [ProcessTopic] = [
        ProcessTopic(
            id: "patron",
            title: "Mi patron emocional",
            icon: "arrow.triangle.2.circlepath",
            content: """
            ## Como funciona mi gatillo

            Mi patron tiene 5 pasos que se repiten:

            **1.** Ella se distancia, esta en su mundo, o sale con otras personas
            **2.** Yo lo interpreto como perdida: "me esta dejando", "ya no le importo"
            **3.** Se activa la ansiedad y el miedo
            **4.** Mi mente crea historias que no son reales
            **5.** Reacciono: escribo, presiono, muestro energia desesperada

            **Resultado:** Eso la aleja mas. Profecia autocumplida.

            ---

            ## La raiz

            El problema no es lo que ella hace.
            Es como yo lo interpreto y como reacciono.

            Mi mente en estado emocional:
            - Confunde emocion con realidad (La Luna)
            - Crea historias sin evidencia
            - Me empuja a actuar YA

            Pero la mayoria de esas historias no son verdad.

            ---

            ## La clave

            > "Lo que siento es valido, pero no siempre es verdad."

            Sentir ansiedad no significa que algo malo esta pasando.
            Sentir miedo no significa que la estoy perdiendo.
            """
        ),

        ProcessTopic(
            id: "rompio",
            title: "Lo que se rompio",
            icon: "bolt.fill",
            content: """
            ## No solo se rompio el vinculo

            Se rompio mi forma de sostenerlo.

            Lo que realmente se quebro fue:
            - Mi regulacion emocional
            - Mi tranquilidad mental
            - Mi forma de manejar la incertidumbre

            ---

            ## Que aparecio

            - Ansiedad constante
            - Pensamientos repetitivos
            - Miedo a perder
            - Necesidad de control
            - Sobrepensamiento (analizar todo, todo el tiempo)

            ---

            ## La verdad importante

            > "No se rompio solo el vinculo... se rompio como lo sostengo."

            Antes:
            - Sentia → pensaba → reaccionaba
            - Sin filtro, sin regulacion

            Y eso llevo al quiebre.

            ---

            ## Que necesito construir

            - Confianza (en mi y en el proceso)
            - Regulacion emocional
            - Tolerancia a la incertidumbre
            - Dejar de intentar reconstruir lo mismo
            """
        ),

        ProcessTopic(
            id: "cambiar",
            title: "Lo que debo cambiar",
            icon: "arrow.uturn.up",
            content: """
            ## Dejar de creer todo lo que pienso

            Cuando estoy emocional, mi mente:
            - Justifica (para no sentir culpa)
            - Controla (para no sentir incertidumbre)
            - Sobreanaliza (para sentir seguridad)

            Pero eso me desconecta de la realidad.

            ---

            ## Lo que necesito en su lugar

            **Claridad real** — usar la mente para entenderme, no para defenderme
            **Control emocional** — sentir sin actuar impulsivamente
            **Paciencia** — darle tiempo a los procesos internos
            **Estabilidad** — que venga de rutina y estructura, no de ella

            ---

            ## En practica

            1. No tomar decisiones cuando estoy alterado
            2. Separar hecho de historia SIEMPRE
            3. Regular mi estado ANTES de pensar
            4. Esperar claridad, no buscarla forzadamente
            5. Actuar solo desde la calma

            ---

            > "Mi patron: reaccion automatica desde el miedo."
            > "Mi objetivo: respuesta consciente desde la claridad."
            """
        ),

        ProcessTopic(
            id: "aleja_acerca",
            title: "Lo que la aleja vs lo que la acerca",
            icon: "arrow.left.arrow.right",
            content: """
            ## Lo que la ALEJA

            - Intensidad emocional
            - Presion
            - Ansiedad visible
            - Necesidad
            - Mensajes desde el miedo
            - Insistencia
            - Demostrar desesperacion
            - Hacerla sentir atrapada

            ---

            ## Lo que la ACERCA

            - Calma
            - Seguridad
            - Independencia
            - Energia liviana
            - Estabilidad visible
            - Espacio
            - Cambio real (no discurso)
            - Que se sienta libre

            ---

            ## Lo que ella necesita sentir

            - Seguridad emocional
            - Consistencia
            - Que no va a haber caos
            - Que puede estar en paz contigo sin perder la emocion

            ---

            ## La frase que lo resume todo

            > "No es ir a recuperarla. Es convertirte en alguien al que valga la pena volver."
            """
        ),

        ProcessTopic(
            id: "protocolo",
            title: "Protocolo Rey de Espadas",
            icon: "shield.fill",
            content: """
            ## Cuando se active algo fuerte

            ### Paso 1: PAUSA
            No actues. No escribas. Minimo 30-60 minutos.

            ### Paso 2: HECHO vs HISTORIA
            Preguntate:
            - Que paso REALMENTE?
            - Que estoy INTERPRETANDO?

            Ejemplo:
            - Hecho: no respondio en 2 horas
            - Historia: "ya no le importo"

            Elimina la historia.

            ### Paso 3: REGULAR
            Haz algo fisico ANTES de pensar:
            - Caminar
            - Ejercicio
            - Respirar profundo
            - Cualquier cosa que te mueva

            Primero cuerpo, despues mente.

            ### Paso 4: TIEMPO
            No tomes decisiones en estados emocionales.
            Lo que sientes ahora es temporal. Va a cambiar.

            ### Paso 5: ACCION CONSCIENTE
            Recien ahi decides:
            - Vale la pena actuar?
            - Desde que energia lo haria? Miedo o claridad?

            Si es desde el miedo → no actues.
            Si es desde la claridad → adelante.

            ---

            > "No todo lo que pienso cuando estoy alterado es verdad."
            """
        ),
    ]
}
