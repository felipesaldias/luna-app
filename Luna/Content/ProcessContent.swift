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

        ProcessTopic(
            id: "sanar",
            title: "Como sanar",
            icon: "heart.circle.fill",
            content: """
            ## La Torre — Romper lo que no sirve

            Sanar implica:
            - Aceptar que algo se rompio
            - Dejar caer ideas, expectativas o formas de amar que ya no funcionan
            - No es evitar el dolor. Es atravesarlo y entenderlo

            > "Deja de intentar reconstruir lo mismo."

            ---

            ## 9 de Oros — Volver a ti

            Tu base de sanacion:
            - Reconectar contigo mismo
            - Sentirte completo solo
            - Recuperar tu valor sin depender de ella

            Esto incluye: habitos, autoestima, independencia emocional.

            > "Estar bien contigo, incluso si ella no esta."

            ---

            ## As de Espadas — Claridad brutal

            Sanar requiere:
            - Honestidad contigo
            - Ver la verdad sin maquillarla
            - Entender que hiciste, que no, y que necesitas cambiar

            No es castigarte. Es ver claro para no repetir.

            ---

            ## Los 3 pasos

            1. Aceptar la caida — no niegues lo que paso, no lo romantices
            2. Reconstruirte a ti — rutina, disciplina, cosas que te hagan sentir orgulloso de ti
            3. Entenderte — que me gatilla? donde pierdo el control? que necesito cambiar si o si?

            ---

            > "Tu sanacion no pasa por acercarte a ella... pasa por acercarte a ti."
            """
        ),

        ProcessTopic(
            id: "luna",
            title: "La Luna — Lo que no estas viendo",
            icon: "moon.stars.fill",
            content: """
            ## Esta es la tirada que mas te marco

            Rey de Espadas + 10 de Espadas + La Luna

            ---

            ## Rey de Espadas — Tu forma de procesar

            Necesitas volverte:
            - Mas claro
            - Mas racional en momentos clave
            - Menos reactivo emocionalmente

            Pero ojo: puedes estar usando la mente para:
            - Justificar cosas
            - Controlar
            - Analizar demasiado

            > "Usar la claridad para entenderte, no para defenderte."

            ---

            ## 10 de Espadas — Aceptar el fondo del dolor

            Hay algo que tienes que aceptar:
            - Algo se rompio de verdad
            - Hubo un limite que se cruzo (interno o en la relacion)
            - No puedes seguir actuando como si "no fue tan grave"

            Lo que no estas queriendo ver:
            - El impacto real de lo que paso (en ti y en ella)

            ---

            ## La Luna — Autoengano y miedo

            Esta es LA clave de toda la tirada.

            Aqui hay:
            - Inseguridad
            - Miedo a perder
            - Pensamientos que te confunden
            - Historias mentales que no son 100% realidad

            Puede que estes:
            - Interpretando cosas
            - Imaginando escenarios
            - Dejandote llevar por ansiedad

            > "No todo lo que sientes es verdad... pero lo estas tratando como si lo fuera."

            ---

            ## Lo que debes cambiar

            Tu reaccion automatica desde la emocion y el miedo.

            ## Lo que debes aceptar

            Que hubo una ruptura real y que no puedes volver a lo mismo sin transformarte.

            ## Lo que no estas viendo

            Que tu mente te esta jugando en contra cuando estas ansioso.

            ---

            ## En simple

            - Necesitas claridad real (no sobrepensar)
            - Aceptar el dolor sin maquillarlo
            - Dejar de creer todo lo que piensas cuando estas emocional

            ---

            ## Ejercicio clave

            Cuando sientas algo fuerte (celos, ansiedad, miedo):

            1. Escribelo
            2. Pregunta: esto es un hecho o una interpretacion?
            3. No actues hasta tener claridad

            ---

            > "No estas perdiendo solo por lo que paso... estas perdiendo por como reaccionas a lo que paso."
            """
        ),
        ProcessTopic(
            id: "mensajes",
            title: "Antes de escribirle",
            icon: "message.fill",
            content: """
            ## Lo que haces cuando estas ansioso

            - Mandas muchos mensajes seguidos sin esperar respuesta
            - Cada mensaje sube la intensidad emocional
            - Prometes cosas desde la desesperacion, no desde la calma
            - Revisas si te respondio
            - Borras y editas mensajes (senal de que sabes que no deberias haberlos mandado)

            ---

            ## Que efecto tiene en ella

            - Se siente agobiada
            - Siente presion para responder
            - Refuerza su decision de alejarse
            - La carga emocionalmente con TU proceso

            > "Es tu proceso y yo no quiero estar ahi" — eso te dijo ella

            ---

            ## Reglas antes de escribir

            1. UN solo mensaje. No dos, no tres, no cinco. UNO.
            2. Si no responde, NO mandes otro. Espera.
            3. No pidas juntarse mas de una vez. Si dijo que no, respeta.
            4. No prometas cambios por texto. Los cambios se demuestran, no se anuncian.
            5. No mandes fotos, audios o memes emocionales buscando reaccion.

            ---

            ## Antes de apretar enviar, preguntate:

            - Estoy mandando esto por ella o por mi ansiedad?
            - Estoy buscando calmarme a mi o realmente comunicar algo?
            - Si ella no responde, me voy a sentir peor?
            - Puedo esperar 1 hora antes de mandar esto?

            Si la respuesta a cualquiera de esas es "es por mi ansiedad" → no lo mandes.

            ---

            ## Lo que SI funciona

            - Mensajes cortos y livianos
            - Sin carga emocional pesada
            - Sin expectativa de respuesta
            - Respetar sus tiempos

            ---

            ## Cosas que NO debes decir/escribir

            - "No me quiero separar del mejor pololo que has tenido"
            - "Prometo que nunca mas..."
            - "No quiero perder mi familia"
            - "Te han joteado?"
            - Cualquier cosa desde el miedo a perderla

            ---

            ## Cosas que SI puedes decir

            - "Espero que estes bien"
            - "Avísame si necesitas algo"
            - Y despues SILENCIO

            ---

            > "El silencio comunica mas que 20 mensajes. Dice: estoy bien, respeto tu espacio, confio en nosotros."
            """
        ),

        ProcessTopic(
            id: "errores",
            title: "Errores que no debo repetir",
            icon: "exclamationmark.triangle.fill",
            content: """
            ## Mis patrones concretos

            Estos son comportamientos especificos que debo dejar de hacer:

            ---

            ## En mensajes

            - Mandar multiples mensajes seguidos sin respuesta
            - Editar y borrar mensajes (senal de ansiedad actuando)
            - Subir la intensidad emocional con cada mensaje
            - Pedir juntarse repetidamente cuando ya dijo que no
            - Mandar fotos o cosas buscando reaccion emocional

            ---

            ## En la relacion

            - Cuestionar sus amistades o salidas
            - Preguntar si la han joteado
            - No respetar su tiempo con amigas
            - Hacer comentarios sobre su independencia
            - Tratar de controlar situaciones sociales

            ---

            ## En mi cabeza

            - Asumir lo peor cuando no responde
            - Crear historias sobre lo que esta haciendo
            - Interpretar la distancia como abandono
            - Buscar senales de que me esta dejando

            ---

            ## Lo que ella necesita de mi

            Ella lo dijo claro:
            - "No puedo aguantar que alguien no me deje tener mi tiempo y espacio con mis amigos"
            - "Es algo repetitivo"
            - "Es tu proceso y yo no quiero estar ahi"

            > Escuchala. No la interpretes. Escuchala.

            ---

            ## Recordatorio clave

            Tu ansiedad no es su responsabilidad.
            Tu proceso es tuyo.
            Ella no tiene que cargar con eso.

            > "Los cambios se demuestran, no se prometen por WhatsApp."
            """
        ),
    ]
}
