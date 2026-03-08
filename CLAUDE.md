# Invite App — Flutter Invitation Builder

## Project Overview
A Flutter app for creating professional invitation cards with a drag-and-drop editor,
image export, and pre-built templates for weddings, funerals, and birthdays.

## Agent Team Roles

### Architect
Owns `lib/core/` and overall project structure.
Responsibilities:
- State management setup (Riverpod)
- Routing (go_router)
- Dependency injection
- pubspec.yaml dependencies
- Folder structure conventions

### Developer
Owns `lib/features/editor/` and `lib/features/export/`.
Responsibilities:
- Drag-and-drop canvas editor
- Element manipulation (text, images, stickers)
- Image export logic (render widget to PNG/PDF)
- Editor state and undo/redo

### Designer
Owns `lib/features/templates/` and `lib/core/theme/`.
Responsibilities:
- Template definitions (wedding, funeral, birthday)
- Color palettes and typography per category
- Pre-built layout structures
- Design tokens and theme

## Project Structure
```
lib/
  core/
    theme/       # Design tokens, app theme
    router/      # go_router configuration
    di/          # Dependency injection / providers
  features/
    editor/      # Drag-and-drop canvas editor
    templates/   # Template library
    export/      # Image/PDF export
  shared/
    widgets/     # Reusable UI components
    models/      # Shared data models
    utils/       # Utilities
```

## Tech Stack
- State: Riverpod
- Routing: go_router
- Export: screenshot / pdf packages
- Canvas: flutter_drawing_board or custom Stack-based editor
