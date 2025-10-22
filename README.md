# ChatIA

## Resumen
ChatIA es un proyecto personal que implementa un chatbot utilizando **Gemini IA de Google** como LLM.  
El propósito de esta app es ofrecer un asistente inteligente capaz de responder preguntas y consultar APIs externas para enriquecer sus respuestas.

## Contacto
¿Tienes dudas o sugerencias? Contáctame por:
- [LinkedIn](https://www.linkedin.com/in/developer-mobile-jesus-alberto-aguilar-martinez/) 
- [Correo electrónico](mailto:jesusalberto.aguilar01@gmail.com)

## APK / Instalación
Puedes descargar el APK de la app aquí:  
[Descargar APK](https://drive.google.com/file/d/1r8u7X3JJve30c-Py52zhMQGLDaPGCZWb/view?usp=sharing)

## Antes de empezar...

### Requisitos
- **Flutter SDK:** 3.35.5 (canal estable) o superior  
- **Dart:** 3.9.2 o superior  
- Archivos `.env` para las **API Keys** (puedes obtener una key gratuita en [Google IA Studio](https://aistudio.google.com/))


### Instalación
1. Clona el repositorio

2. Instala dependencias

```shell
flutter pub get
```

3. Genera archivos autogenerados de AutoRoute con `build_runner`:

```shell
flutter packages pub run build_runner build --delete-conflicting-outputs
```

4. Corre la app:

```shell
flutter run
```

### APIs utilizadas
- **Gemini IA** (`gemini-2.5-flash`) → Para procesar preguntas y generar respuestas inteligentes.
- **PokeAPI** (`https://pokeapi.co/api/v2/pokemon/$nombrePokemon`) → Para consultas de información de Pokemón.
- **Pipedream**  → Para simular inserción y consulta de datos via `HTTP GET/POST`

> Todas las llamadas se realizan mediante un HTTPClient personalizado que centraliza el manejo de peticiones y errores.


## Arquitectura y Diseño Técnico

Este proyecto está desarrollado bajo una **arquitectura basada en DDD (Domain-Driven Design)**, la cual permite mantener una estructura modular, escalable y fácil de mantener.  
Cada capa tiene responsabilidades claramente definidas:

```
lib/
│
├── core/                   # Código reutilizable y utilidades base
│   ├── http/               # Cliente HTTP personalizado para manejo de APIs
│   ├── failure/            # Manejo centralizado de errores
│   └── utils/              # Métodos auxiliares y constantes globales
│
├── features/               # Módulos independientes basados en características
│   └── studybot/           # Módulo principal del chatbot IA
│       ├── data/           # Acceso a datos y fuentes externas (APIs, DB local)
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/         # Entidades y contratos abstractos
│       │   ├── entities/
│       │   └── repositories/
│       ├── di/         # Inyección de dependencias de datasources, repositorios, usecases y blocs
│       └── presentation/   # Capa de interfaz con el usuario (UI + BLoC)
│           ├── blocs/
│           └── views/
│
└── main.dart               # Punto de entrada de la aplicación
```


#### **Domain**

Es la capa central y más independiente del proyecto.  
Contiene:

- **Entities:** Definen la estructura de los modelos de negocio. Extienden de `Equatable` para facilitar la comparación de objetos.
- **Repositories:** Se definen como **clases abstractas o interfaces**, que establecen los contratos que deben implementar las capas inferiores.
- **UseCases:** Representan las acciones o reglas de negocio. Actúan como puente entre el `domain` y la `presentation`.


#### **Data**

Contiene la implementación concreta de los repositorios, modelos y fuentes de datos.

- **Constants:** Almacena los `gemini_prompts`, encargados de entrenar la IA, definir condiciones para enviar prompts y concatenar información del usuario con datos externos como la PokeAPI.
- **Datasources:** Define las fuentes de datos (locales y remotas).
  - Incluye servicios específicos como `GeminiService`, `PokeAPIService` y un `PromptBuilder` (helper que une el mensaje del usuario con el prompt adecuado).
- **Models:** Cada modelo extiende de su entidad y agrega métodos como `fromJson`, `toJson` y `copyWith`.
- **Repositories:** Implementan los contratos definidos en `domain/repositories` y solicitan sus datasources mediante el constructor.


#### **DI (Dependency Injection)**

Usa **GetIt** como inyector de dependencias.  
Cada feature tiene su propio archivo de configuración donde se registran sus `BLoCs`, `usecases`, `repositories` y `datasources`.  
Gracias a GetIt, las dependencias se resuelven automáticamente en los constructores (`getIt<ExampleDatasource>()`).


#### **Presentation**

Contiene toda la capa visual: **Widgets, Views, Screens y BLoCs**.  
Cada feature mantiene su propio estado mediante su respectivo BLoC.

> El uso de DDD permite que ChatIA, aún siendo un MVP (v0.0.1), tenga una base sólida, modular y preparada para escalar con nuevas funcionalidades.

---

### ⚙️ Patrón de Estado: BLoC

El manejo del estado se realiza con el patrón **BLoC (Business Logic Component)**, el cual separa completamente la lógica de negocio de la interfaz de usuario.  
Esto garantiza una aplicación **reactiva, mantenible y testeable**, facilitando el trabajo colaborativo y las pruebas unitarias.

Cada `Bloc` se encarga de orquestar la comunicación entre la capa de dominio y la capa de presentación.

---

### 🗂️ Estructura del proyecto

El proyecto se encuentra dividido por **features**:

- **Auth:**

  - Gestiona login y registro.
  - Usa **Pipedream** para simular el envío y recepción de datos.
  - Implementa validación de formularios.

- **Home:**

  - Contiene la UI principal donde se listan las IAs disponibles.
  - Actualmente el BLoC tiene un estado mínimo sin lógica compleja.

- **Splash:**

  - Muestra una animación de carga.
  - Redirige al usuario a `Home` o `Login` según haya datos almacenados localmente.

- **StudyBot (feature principal):**
  - Se comunica con **Gemini IA** y **PokeAPI**.
  - Entrenado con un prompt que define su personalidad y propósito: responder preguntas científicas y sobre Pokémon.
  - Responde entre 1 y 4 párrafos evitando redundancias o disculpas.
  - Genera títulos de chat a partir de las primeras 4 preguntas.
  - Guarda los chats localmente (solo si la IA devuelve una palabra clave).
  - Usa datos de PokeAPI para complementar sus respuestas incluso con errores ortográficos en los nombres.
  - UI basada en tres tabs:
    1. Chat con la IA
    2. Lista de chats guardados
    3. Perfil del usuario (nombre, correo, cerrar sesión)

---

### 🔄 Flujo de datos

El flujo de información sigue las capas del DDD:

> HTTPClient → DataSource → Repository → UseCase → BLoC → UI

1. **HTTPClient:** Gestiona las peticiones HTTP hacia Gemini, PokeAPI y Pipedream.
2. **SecurePrefs (basado en FlutterSecureStorage):** Almacena información local (como la lista de chats) de forma segura.
3. **Datasources:** Usan `HTTPClient` o `SecurePrefs` según la necesidad (remoto o local).
4. **Repositories:** Implementan la lógica de negocio usando los datasources.
5. **UseCases:** Ejecutan las operaciones definidas por los repositorios.
6. **BLoCs:** Orquestan la comunicación entre la UI y los UseCases.
7. **UI:** Muestra el resultado al usuario y gestiona las interacciones.

Las dependencias entre cada capa se resuelven mediante **GetIt** y se centralizan en un archivo `base_injection.dart`.

---

### 🧩 Principios Técnicos Aplicados

- **Inyección de dependencias** para desacoplar componentes.
- **Uso de `.env`** para manejo seguro de claves API.
- **Generación automática de rutas** mediante AutoRoute.
- **Separación de capas y responsabilidades** (UI, dominio, datos).
