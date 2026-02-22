# Pomcraft

Craft your focus.

Pomcraft is an open-source, developer-focused Pomodoro timer that integrates Markdown tasks and AI-powered task generation. It is designed for developers who work from README.md files and want to convert plans into execution without friction.

---

## Features

- Pomodoro timer with configurable work and break sessions
- Native Markdown task support
- AI-powered task generation from README.md using Gemini
- Ability to link Pomodoro sessions to specific tasks
- Session tracking and basic productivity statistics
- Modern desktop interface built with PySide6 and QML
- Fully open source

---

## How it works

1. Load or write your project README.md
2. Use Gemini to generate actionable tasks
3. Select a task
4. Start a Pomodoro session
5. Execute and track your progress

Pomcraft transforms documentation into execution.

---

## Screenshots

Coming soon.

---

## Installation

### Requirements

- Python 3.13 or newer
- PySide6

### Install dependencies
```
pip install -r requirements.txt
```

### Run

```
python main.py
```

---

## Project structure

```
pomcraft/
├── main.py              # Application entry point
├── src/
│   ├── __init__.py
│   ├── main_window.py   # Main window class
│   ├── widgets/         # Custom widgets
│   ├── models/          # Data models
│   ├── services/        # Business logic
│   └── utils/           # Helper functions
├── tests/
├── resources/           # Icons, images, QML files
├── requirements.txt
├── pyproject.toml
└── README.md
```

---

## Gemini Integration

Add your Gemini API key in Settings.

Pomcraft will use it to generate tasks from Markdown files.

The API key is stored locally.

---

## Vision

Pomcraft is built on a simple idea:

Markdown is a plan.
Pomodoro is execution.
AI assists the transition between both.

---

## Built with

- Python
- PySide6
- QML
- PyInstaller
- Gemini API

---

## Contributing

Contributions are welcome.

You can contribute by reporting issues, suggesting features, or improving the codebase.

---

## License

MIT License

---

## Philosophy

Stop planning.
Start crafting.

Pomcraft
