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
