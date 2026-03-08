import markdown
import re
from PySide6.QtCore import QObject, Slot

class MarkdownRenderer(QObject):
    def __init__(self):
        super().__init__()
        # Use common extensions for better Markdown support
        self._md = markdown.Markdown(extensions=['tables', 'fenced_code', 'nl2br', 'sane_lists'])

    @Slot(str, result=str)
    def render(self, text):
        if not text:
            return ""

        # Pre-process task lists (checkboxes) into HTML spans with custom styling colors
        text = re.sub(r'(?m)^\s*[-*+]\s+\[ \]\s+(.*)$', r'<span style="color: #9CA3AF;">☐ \1</span><br/>', text)
        text = re.sub(r'(?m)^\s*[-*+]\s+\[[xX]\]\s+(.*)$', r'<span style="color: #10B981; font-weight: bold;">☑ \1</span><br/>', text)

        # Pre-process strikethroughs
        text = re.sub(r'~~([^~]+)~~', r'<del style="color: #6B7280;">\1</del>', text)

        html = self._md.convert(text)
        
        # Add basic CSS tailored to the application's dark theme for QML RichText
        css = """
        <style>
            body { font-family: 'Inter', sans-serif; font-size: 15px; }
            h1, h2, h3, h4, h5 { color: #A78BFA; font-weight: bold; margin-bottom: 8px; }
            a { color: #3B82F6; text-decoration: underline; }
            pre { background-color: #1F1F35; margin: 10px 0; padding: 10px; border-radius: 6px; }
            code { font-family: monospace; color: #10B981; background-color: #1F1F35; padding: 2px 4px; }
            blockquote { color: #9CA3AF; font-style: italic; margin: 10px 0 10px 20px; }
            table { border-collapse: collapse; margin-top: 10px; margin-bottom: 10px; }
            th { border-bottom: 2px solid #4B5563; padding: 8px; text-align: left; color: #E5E7EB; }
            td { border-bottom: 1px solid #374151; padding: 8px; }
            hr { border: 0; background-color: #374151; height: 1px; margin: 15px 0; }
        </style>
        """
        
        return css + "<body>" + html + "</body>"
