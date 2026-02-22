# AGENTS.md

Coding agent instructions for this repository.

## Project Overview

Python desktop GUI application using PySide6 (Qt for Python) with PyInstaller for packaging.

- Python: 3.13+
- GUI Framework: PySide6 (Qt 6)
- HTTP Client: requests
- Packaging: PyInstaller

## Build/Lint/Test Commands

### Environment Setup

```bash
python3 -m venv .venv
source .venv/bin/activate  # Linux/macOS
pip install -r requirements.txt
```

### Running the Application

```bash
python main.py
```

### Linting and Type Checking

```bash
# Ruff (fast linter/formatter)
ruff check .
ruff check --fix .
ruff format .

# Type checking with mypy
mypy .

# Single file
ruff check path/to/file.py
mypy path/to/file.py
```

### Testing

```bash
# Run all tests
pytest

# Run specific test file
pytest tests/test_file.py

# Run single test function
pytest tests/test_file.py::test_function_name

# Run with verbose output
pytest -v

# Run with coverage
pytest --cov=src --cov-report=term-missing
```

### Building with PyInstaller

```bash
pyinstaller --name="PomCraft" --windowed main.py
```

## Code Style Guidelines

### Imports

```python
# Standard library first
import os
import sys
from pathlib import Path
from typing import Optional, List, Dict, Any

# Third-party libraries second
from PySide6.QtWidgets import QApplication, QMainWindow, QWidget
from PySide6.QtCore import Qt, QTimer, Signal
from PySide6.QtGui import QIcon
import requests

# Local imports last
from .module import LocalClass
from . import constants
```

### Import Conventions

- Use absolute imports for project modules
- Group imports: stdlib, third-party, local (separated by blank lines)
- Import specific names rather than modules when possible
- Avoid wildcard imports (`from module import *`)

### Formatting

- Line length: 88 characters (Ruff default)
- Use 4 spaces for indentation (no tabs)
- Use double quotes for strings
- Trailing commas in multi-line collections

### Type Hints

```python
from typing import Optional, List, Dict, Any, Callable

def process_data(
    items: List[str],
    config: Optional[Dict[str, Any]] = None,
) -> Dict[str, int]:
    ...

class DataProcessor:
    def __init__(self, name: str, max_items: int = 100) -> None:
        self.name = name
        self.max_items = max_items

    def process(self, data: List[Dict[str, Any]]) -> List[str]:
        ...
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Modules | snake_case | `data_processor.py` |
| Classes | PascalCase | `DataProcessor` |
| Functions | snake_case | `process_data()` |
| Methods | snake_case | `get_items()` |
| Variables | snake_case | `item_count` |
| Constants | UPPER_SNAKE_CASE | `MAX_CONNECTIONS` |
| Private attributes | _leading_underscore | `self._internal_state` |
| Signal handlers | on_<action> | `on_button_clicked` |

### Error Handling

```python
# Prefer specific exceptions
try:
    response = requests.get(url, timeout=30)
    response.raise_for_status()
except requests.Timeout:
    logger.error(f"Request to {url} timed out")
except requests.HTTPError as e:
    logger.error(f"HTTP error: {e}")
except requests.RequestException as e:
    logger.error(f"Request failed: {e}")

# Use context managers for resources
with open("file.txt", "r") as f:
    content = f.read()

# Raise meaningful exceptions
if not valid:
    raise ValueError(f"Invalid configuration: {reason}")
```

### PySide6/Qt Conventions

```python
from PySide6.QtWidgets import QMainWindow, QPushButton, QVBoxLayout
from PySide6.QtCore import Qt, Signal, Slot, QTimer

class MainWindow(QMainWindow):
    # Signals defined at class level
    data_loaded = Signal(dict)
    error_occurred = Signal(str)

    def __init__(self) -> None:
        super().__init__()
        self._setup_ui()
        self._connect_signals()

    def _setup_ui(self) -> None:
        self.setWindowTitle("PomCraft")
        self.setMinimumSize(800, 600)

        central_widget = QWidget()
        self.setCentralWidget(central_widget)

        layout = QVBoxLayout(central_widget)
        self._button = QPushButton("Start")
        layout.addWidget(self._button)

    def _connect_signals(self) -> None:
        self._button.clicked.connect(self._on_button_clicked)

    @Slot()
    def _on_button_clicked(self) -> None:
        self.data_loaded.emit({"status": "ready"})
```

### Documentation

```python
def calculate_total(
    items: List[Dict[str, float]],
    tax_rate: float = 0.1,
) -> float:
    """Calculate total price including tax.

    Args:
        items: List of item dictionaries with 'price' key.
        tax_rate: Tax rate as decimal (default 0.1 = 10%).

    Returns:
        Total price including tax.

    Raises:
        KeyError: If item missing 'price' key.
    """
    subtotal = sum(item["price"] for item in items)
    return subtotal * (1 + tax_rate)
```

### File Structure

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
│   ├── __init__.py
│   ├── test_main.py
│   └── test_services/
├── resources/           # Icons, images, QML files
├── requirements.txt
├── pyproject.toml
└── AGENTS.md
```

## Best Practices

1. Keep main.py minimal - just app initialization
2. Separate UI code from business logic
3. Use Qt signals/slots for component communication
4. Prefer composition over inheritance for widgets
5. Use QSettings for user preferences
6. Implement proper resource cleanup
7. Log errors appropriately
8. Write unit tests for non-UI logic

# Development Guidelines 

you need to follow those rules strictly

- we will use QML for the UI, so be creative 
- always you must ensure the Brand Consistency 
- try to use animation on all UI elements 