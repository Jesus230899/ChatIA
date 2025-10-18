# ChatIA

## Resumen
Este es un proyecto personal creado para implementar IA a través de un chatbot usando Gemini IA de Google como LLM

## Contacto
¿Tienes alguna duda o sugerencia? Contáctame por: 
- [LinkedIn](https://www.linkedin.com/in/developer-mobile-jesus-alberto-aguilar-martinez/) 
- [Correo electrónico](jesusalberto.aguilar01@gmail.com)

--------

## Antes de empezar...

### Configuración

La versión de Flutter SDK usada es `3.35.5` proveniente del canal `estable`, asi que asegurate de tener una versión superior o compatible.
Asi mismo, se hace uso de Dart en su versión `3.9.2`, asi que asegurate de tener una versión superior o compatible.

Este proyecto usa archivos `.env` para guardar las Key usadas para poder consumir la IA. Puedes obtener una key completamente gratuita en [Google IA Studio](https://aistudio.google.com/) !Es totalmente gratuito!

--------

### Ejecución

Si es tu primera vez corriendo en tu maquina este proyecto debes de ejcutar el comando 

```shell
flutter pub get
```

Adicional a lo anterior, necesitas generar los archivos autogenerados de la libreria AutoRoute con la ayuda de los `build_runner`, para ello vas a ejecutar el comando:

```shell
flutter packages pub run build_runner build --delete-conflicting-outputs
```