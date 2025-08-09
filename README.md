# App Médicos - Sistema de Gestión Hospitalaria

Aplicación móvil Flutter para la gestión médica hospitalaria, desarrollada con FlutterFlow. Proporciona herramientas integrales para médicos y personal sanitario en el manejo de pacientes, turnos y evoluciones clínicas.

## Características Principales

### 🏥 Gestión de Pacientes
- **Búsqueda de pacientes**: Sistema completo de búsqueda y visualización de información de pacientes
- **Panel de internaciones**: Gestión de pacientes internados con visualización por sectores y camas
- **Evolución ambulatoria**: Registro y seguimiento de evoluciones médicas ambulatorias
- **Escaneo QR**: Sistema de identificación rápida de pacientes mediante códigos QR

### 📅 Sistema de Turnos
- **Mis turnos**: Visualización y gestión de turnos médicos asignados
- **Turnos cercanos**: Algoritmo de detección de turnos próximos

### 💊 Gestión de Recetas
- **Carga de recetas**: Sistema para cargar y gestionar recetas médicas
- **Integración con farmacia**: Conexión con el sistema de farmacia del hospital

### 💰 Módulo de Caja
- **Caja prestador**: Gestión de cobros y prestaciones médicas

### 🔐 Seguridad y Acceso
- **Sistema de login**: Autenticación segura para profesionales médicos
- **Gestión de permisos**: Control de acceso basado en roles

## Stack Tecnológico

### Frontend
![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![FlutterFlow](https://img.shields.io/badge/FlutterFlow-Visual_Builder-6202D9?style=for-the-badge)

- **Flutter** 3.0+ - Framework de desarrollo multiplataforma
- **FlutterFlow** - Herramienta de desarrollo visual para Flutter
- **Dart** 3.0+ - Lenguaje de programación

### Dependencias Principales

#### Navegación y Estado
![Go Router](https://img.shields.io/badge/go__router-12.1.3-4285F4?style=flat-square&logo=google&logoColor=white)
![Provider](https://img.shields.io/badge/provider-6.1.2-FF6200?style=flat-square&logo=dart&logoColor=white)

#### Networking y API
![HTTP](https://img.shields.io/badge/http-1.2.2-0175C2?style=flat-square&logo=dart&logoColor=white)
![Cache Manager](https://img.shields.io/badge/flutter__cache__manager-3.4.1-02569B?style=flat-square&logo=flutter&logoColor=white)

#### Multimedia y Dispositivo
![Barcode Scanner](https://img.shields.io/badge/flutter__barcode__scanner-2.0.0-4CAF50?style=flat-square)
![Image Picker](https://img.shields.io/badge/image__picker-latest-FF9800?style=flat-square)
![Lottie](https://img.shields.io/badge/lottie-2.7.0-00DDB3?style=flat-square)
![Permission Handler](https://img.shields.io/badge/permission__handler-11.3.1-9C27B0?style=flat-square)

#### Voz y Audio
![Speech to Text](https://img.shields.io/badge/speech__to__text-7.0.0-4285F4?style=flat-square&logo=google&logoColor=white)
![Flutter TTS](https://img.shields.io/badge/flutter__tts-3.6.3-02569B?style=flat-square&logo=flutter&logoColor=white)

#### UI y Diseño
![Google Fonts](https://img.shields.io/badge/google__fonts-6.1.0-4285F4?style=flat-square&logo=google&logoColor=white)
![Font Awesome](https://img.shields.io/badge/font__awesome-10.7.0-339AF0?style=flat-square&logo=fontawesome&logoColor=white)
![Flutter Animate](https://img.shields.io/badge/flutter__animate-4.5.0-02569B?style=flat-square&logo=flutter&logoColor=white)

#### Almacenamiento
![Shared Preferences](https://img.shields.io/badge/shared__preferences-2.3.2-4CAF50?style=flat-square)
![SQLite](https://img.shields.io/badge/sqflite-2.3.3-003B57?style=flat-square&logo=sqlite&logoColor=white)

- `go_router` (12.1.3) - Navegación y routing
- `provider` (6.1.2) - Gestión de estado
- `http` (1.2.2) - Llamadas API REST
- `flutter_barcode_scanner` (2.0.0) - Escaneo de códigos QR
- `lottie` (2.7.0) - Animaciones
- `speech_to_text` (7.0.0) - Reconocimiento de voz
- `flutter_tts` (3.6.3) - Text-to-Speech
- `image_picker` - Captura y selección de imágenes
- `permission_handler` (11.3.1) - Gestión de permisos del dispositivo

### Backend Integration
- API REST personalizada para gestión hospitalaria
- Manejo de respuestas JSON
- Sistema de caché con `flutter_cache_manager`

## Estructura del Proyecto

```
app-medicos/
├── lib/
│   ├── pages/              # Pantallas de la aplicación
│   │   ├── ambulatorio/    # Módulo ambulatorio
│   │   ├── buscar_paciente/# Búsqueda de pacientes
│   │   ├── caja/           # Gestión de caja
│   │   ├── cargar_receta/  # Carga de recetas
│   │   ├── evolucion_ambulatorio/ # Evoluciones
│   │   ├── evolucion_scan_q_r/    # Escaneo QR
│   │   ├── home_oficial/   # Pantalla principal
│   │   ├── internaciones/  # Gestión de internaciones
│   │   ├── login/          # Autenticación
│   │   ├── paciente/       # Información de pacientes
│   │   ├── pacientes_internados/ # Panel de camas
│   │   ├── sector/         # Gestión por sectores
│   │   └── turnos/         # Gestión de turnos
│   ├── backend/            # Integración con API
│   ├── components/         # Componentes reutilizables
│   ├── custom_code/        # Código personalizado
│   │   ├── actions/        # Acciones custom
│   │   └── widgets/        # Widgets personalizados
│   └── flutter_flow/       # Configuración FlutterFlow
├── assets/                 # Recursos multimedia
│   ├── images/            # Imágenes y logos
│   ├── jsons/             # Animaciones Lottie
│   └── fonts/             # Fuentes tipográficas
├── android/               # Configuración Android
├── ios/                   # Configuración iOS
└── web/                   # Configuración Web
```

## Instalación y Configuración

### Requisitos Previos
- Flutter SDK 3.0 o superior
- Dart SDK 3.0 o superior
- Android Studio / Xcode (para desarrollo móvil)
- Git

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone [URL_DEL_REPOSITORIO]
cd app-medicos
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar permisos de plataforma**
   - **iOS**: Configurar permisos en `ios/Runner/Info.plist` para cámara, micrófono y notificaciones
   - **Android**: Los permisos están configurados en `android/app/src/main/AndroidManifest.xml`

4. **Ejecutar la aplicación**
```bash
# Desarrollo
flutter run

# Build para producción
flutter build apk  # Android
flutter build ios  # iOS
flutter build web  # Web
```

## Configuración de API

La aplicación se conecta a un backend hospitalario. Configure los endpoints en:
- `lib/backend/api_requests/api_calls.dart`

## Características Especiales

### Reconocimiento de Voz
La aplicación integra reconocimiento de voz para facilitar el registro de evoluciones médicas, utilizando `speech_to_text`.

### Escaneo QR
Sistema de identificación rápida de pacientes mediante códigos QR, útil para agilizar procesos en emergencias.

### Notificaciones
Sistema de notificaciones push implementado para alertas de turnos y actualizaciones importantes.

## Desarrollo

### Estructura de Código
- **Models**: Cada página tiene su modelo correspondiente (`*_model.dart`)
- **Widgets**: Implementación de UI (`*_widget.dart`)
- **Custom Actions**: Lógica personalizada en `lib/custom_code/actions/`
- **API Integration**: Manejo de llamadas API en `lib/backend/`

### FlutterFlow
Este proyecto fue iniciado con FlutterFlow, lo que permite:
- Desarrollo visual de interfaces
- Generación automática de código Flutter
- Integración simplificada con backend
- Gestión de estado incorporada

## Testing

```bash
# Ejecutar tests
flutter test

# Análisis de código
flutter analyze
```

## Deployment

### Android
1. Configurar signing en `android/app/build.gradle`
2. Generar APK: `flutter build apk --release`
3. Generar App Bundle: `flutter build appbundle --release`

### iOS
1. Configurar certificados en Xcode
2. Build: `flutter build ios --release`
3. Subir a App Store Connect

### Web
1. Build: `flutter build web --release`
2. Deploy en servidor web o servicios como Firebase Hosting

## Contribución

Para contribuir al proyecto:
1. Fork el repositorio
2. Crea una rama feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## Soporte

Para soporte y consultas:
- Crear un issue en el repositorio
- Contactar al equipo de desarrollo

## Licencia

Proyecto privado - Todos los derechos reservados

## Notas de Versión

### v1.0.0 (Actual)
- Primera versión estable
- Módulos principales implementados
- Integración con sistema hospitalario
- Soporte para Android e iOS

## Roadmap

- [ ] Integración con sistemas de laboratorio
- [ ] Módulo de telemedicina
- [ ] Dashboard analítico para médicos
- [ ] Sincronización offline
- [ ] Integración con wearables médicos
