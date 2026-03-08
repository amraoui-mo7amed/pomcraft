import re
from PySide6.QtGui import QSyntaxHighlighter, QTextCharFormat, QColor, QFont
from PySide6.QtCore import Qt


class MarkdownHighlighter(QSyntaxHighlighter):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._formats = {}
        self._setup_formats()

    def _setup_formats(self):
        # Header Format
        header = QTextCharFormat()
        header.setForeground(QColor("#6366F1"))
        header.setFontWeight(QFont.Weight.Bold)
        header.setFontPointSize(18)
        self._formats["header"] = header

        # Bold Format
        bold = QTextCharFormat()
        bold.setForeground(QColor("#8B5CF6"))
        bold.setFontWeight(QFont.Weight.Bold)
        self._formats["bold"] = bold

        # Italic Format
        italic = QTextCharFormat()
        italic.setFontItalic(True)
        italic.setForeground(QColor("#EC4899"))
        self._formats["italic"] = italic

        # Code Format
        code = QTextCharFormat()
        code.setForeground(QColor("#10B981"))
        code.setBackground(QColor("#1F1F35"))
        code.setFontFamily("Consolas, monospace")
        self._formats["code"] = code

        # List/Bullet Format
        list_fmt = QTextCharFormat()
        list_fmt.setForeground(QColor("#F59E0B"))
        list_fmt.setFontWeight(QFont.Weight.Bold)
        self._formats["list"] = list_fmt

    def highlightBlock(self, text):
        # Apply header styling for lines starting with #
        if text.startswith("#"):
            self.setFormat(0, len(text), self._formats["header"])
            return  # Don't apply other formats to headers for clarity

        # Apply bold: **text**
        for match in re.finditer(r"\*\*[^\*]+\*\*", text):
            self.setFormat(
                match.start(), match.end() - match.start(), self._formats["bold"]
            )

        # Apply italic: *text* (avoiding ** matches)
        for match in re.finditer(r"(?<!\*)\*[^\*]+\*(?!\*)", text):
            self.setFormat(
                match.start(), match.end() - match.start(), self._formats["italic"]
            )

        # Apply inline code: `code`
        for match in re.finditer(r"`[^`]+`", text):
            self.setFormat(
                match.start(), match.end() - match.start(), self._formats["code"]
            )

        # Apply list bullet styling
        if re.match(r"^\s*([-*+]|\d+\.)\s", text):
            # Format just the bullet/number
            bullet_match = re.match(r"^\s*([-*+]|\d+\.)", text)
            if bullet_match:
                self.setFormat(0, bullet_match.end(), self._formats["list"])
