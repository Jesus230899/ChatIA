# ChatIA
Este es un proyecto personal creado para implementar IA a través de un chatbot usando Gemini IA de Google como LLM

Cualquier duda o aclaración contactar por [LinkedIn](https://www.linkedin.com/in/developer-mobile-jesus-alberto-aguilar-martinez/) 

--------

## Antes de empezar...

### Configuración

Asegurate de tener al menos la versión de Flutter `3.35.5` en el canal `estable` o una versión compatible. Tambien debes de tener Dart en su versión `3.9.2` o una versión compatible.

Este proyecto usa archivos `.env` para guardar las Key usadas para poder consumir la IA. Puedes obtener una key completamente gratuita en [Google IA Studio](https://aistudio.google.com/) !Es totalmente gratuito!

Si es tu primera vez corriendo en tu maquina este proyecto debes de ejcutar el comando 

```shell
flutter pub get
```

Adicional a lo anterior, necesitas generas los archivos autogenerados de la libreria AutoRoute con la ayuda de los `build_runner`, para ello vas a ejecutar el comando:

```shell
flutter packages pub run build_runner build --delete-conflicting-outputs
```