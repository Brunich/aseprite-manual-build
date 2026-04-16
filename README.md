# Aseprite v1.3.9 — Build Automático para Windows 🎨

Compila [Aseprite](https://github.com/aseprite/aseprite) en Windows con **un solo clic**, sin Docker, compatible con **cualquier edición de Windows 10/11** (Home, Pro, Enterprise).

> 💡 El enfoque con Docker ([eddex/aseprite-windows-docker-build](https://github.com/eddex/aseprite-windows-docker-build)) requiere Windows Pro/Enterprise. Este script funciona en **todas las ediciones**, incluyendo Windows Home.

---

## ⚡ Instalación en un clic

1. **Descarga este repositorio** → click en el botón verde **`Code`** → **`Download ZIP`**, extrae la carpeta  
   *(o clona con `git clone https://github.com/brunich99/aseprite-manual-build.git`)*

2. **Clic derecho en `compile_aseprite.bat`** → **"Ejecutar como administrador"**

3. **Espera** — el script hace TODO automáticamente ✅

4. Cuando termine, encuentra Aseprite en tu Desktop en la carpeta **`Aseprite_v1.3.9`**

> ⚠️ Si aparece un cuadro de **UAC**, acéptalo. Es necesario para instalar las herramientas de compilación.

---

## 🤖 ¿Qué hace el script automáticamente?

| Paso | Qué hace |
|------|----------|
| 1/6 | Verifica/instala **Git** (via winget o descarga directa) |
| 2/6 | Verifica/instala **VS 2022 Build Tools** con soporte C++ y CMake (~3 GB) |
| 3/6 | Inicializa el entorno de compilación x64 |
| 4/6 | Descarga los binarios de **Skia** (~50 MB) |
| 5/6 | Clona **Aseprite v1.3.9** con todos sus submódulos |
| 6/6 | Configura con **CMake** y compila con **Ninja** (20-40 min) |

Si ya tienes algún componente instalado, el script lo detecta y lo salta automáticamente.

---

## ✅ Requisitos

- Windows 10 o Windows 11 (cualquier edición, incluyendo Home)
- Conexión a internet
- ~5 GB de espacio libre en disco
- Nada más — el script instala todo lo que falta

---

## ⏱️ Tiempo estimado

| Situación | Tiempo |
|-----------|--------|
| Primera vez (instala todo) | 45–90 min |
| Ya tiene VS y Git instalados | 30–45 min |
| Ya compiló antes | ~2 min |

---

## 📁 Estructura del repositorio

```
aseprite-manual-build/
├── compile_aseprite.bat   ← ejecuta esto como administrador
└── README.md
```

---

## 🔁 Compilar otra versión

Edita `compile_aseprite.bat` y cambia esta línea:
```bat
git checkout v1.3.9
```
Por la versión que quieras, por ejemplo `v1.3.10`.  
Versiones disponibles: https://github.com/aseprite/aseprite/releases

---

## ⚖️ Licencia de Aseprite

Compilar Aseprite desde el código fuente es legal para **uso personal**. Para uso comercial, [compra una licencia oficial](https://www.aseprite.org/).

---

## 🙏 Créditos

| Proyecto | Autor | Link |
|----------|-------|------|
| Script de build manual (este repo) | brunich99 | [github.com/brunich99](https://github.com/brunich99) |
| Inspiración — build con Docker | eddex | [aseprite-windows-docker-build](https://github.com/eddex/aseprite-windows-docker-build) |
| Aseprite | David Capello | [aseprite/aseprite](https://github.com/aseprite/aseprite) |
| Skia (binarios) | Aseprite Team | [aseprite/skia](https://github.com/aseprite/skia) |

> 💙 **Apoya a los creadores de Aseprite**: https://www.aseprite.org/
