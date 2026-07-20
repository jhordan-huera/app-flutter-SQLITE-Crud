# 📚 Aplicación de Gestión de Libros (CRUD SQLite)

¡Bienvenido al repositorio oficial del proyecto **Gestión de Libros**! 

Esta es una aplicación móvil desarrollada en **Flutter** que implementa un sistema CRUD (Crear, Leer, Actualizar y Eliminar) completamente funcional utilizando **SQLite FFI** para el almacenamiento local persistente de datos.

---

## ✨ Características Principales

- **Diseño UI/UX Pro Max:** Interfaz construida con principios de diseño modernos, incluyendo:
  - Tema Oscuro (Dark Theme) con gradientes cósmicos inmersivos.
  - Tarjetas y formularios con efecto *Glassmorphism* (Cristal esmerilado).
  - Micro-animaciones y efectos de entrada escalonados (*Staggered Animations*).
  - Transiciones fluidas y botones interactivos estilo neón.
- **Gestión de Libros (CRUD):**
  - **Crear:** Agregar nuevos libros indicando Título, Autor y Año de publicación.
  - **Leer:** Visualización de todos los libros en tiempo real mediante *FutureBuilder*.
  - **Actualizar:** Edición de la información de los libros ya guardados.
  - **Eliminar:** Borrado seguro de la base de datos previa confirmación visual.
- **Identificadores Únicos (UUID):** Generación de IDs robustos (texto) en la base de datos usando el paquete estándar `uuid`.
- **Base de Datos Local:** Implementación robusta utilizando la librería `sqflite_common_ffi` para garantizar rendimiento.

---

## 📸 Capturas de Pantalla y Funcionamiento

> **Nota:** Puedes agregar tus capturas arrastrándolas desde tu explorador de archivos y soltándolas directamente aquí debajo de cada título en GitHub o en tu editor.

### 1. Pantalla Principal (Lista de Libros)
*(Coloca aquí tu captura de la lista de libros mostrando el fondo oscuro y las tarjetas)*

### 2. Pantalla de Formulario (Crear/Editar)
*(Coloca aquí la captura del formulario estilo Glassmorphism)*

### 3. Diálogo de Confirmación (Eliminar)
*(Coloca aquí la captura del pop-up flotante que aparece al intentar eliminar un libro)*

---

## 🛠 Tecnologías y Paquetes Utilizados

- **[Flutter](https://flutter.dev/):** Framework principal.
- **[sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi):** Base de datos relacional SQLite para el almacenamiento local multiplataforma.
- **[path](https://pub.dev/packages/path) & [path_provider](https://pub.dev/packages/path_provider):** Gestión de rutas del sistema de archivos.
- **[uuid](https://pub.dev/packages/uuid):** Generación de IDs.

---

## 🚀 Cómo ejecutar el proyecto

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/jhordan-huera/app-flutter-SQLITE-Crud.git
   ```
2. **Entrar al directorio e instalar dependencias:**
   ```bash
   cd app-flutter-SQLITE-Crud
   flutter pub get
   ```
3. **Ejecutar la app:**
   ```bash
   flutter run
   ```

---
*Diseño e Ingeniería enfocados en la Excelencia.* 🚀
