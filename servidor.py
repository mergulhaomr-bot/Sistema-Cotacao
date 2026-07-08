import os
from http.server import HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import unquote

DIR_SISTEMA = os.path.dirname(os.path.abspath(__file__))
DIR_PAI     = os.path.dirname(DIR_SISTEMA)

# Extra search roots for assets like Fentex-Fotos-All
# (add more paths here if photos move to a new location)
ONEDRIVE = os.path.join(os.path.expanduser('~'), 'OneDrive')
EXTRA_ROOTS = [
    os.path.join(ONEDRIVE, 'Fentex Surgical', 'Área de Trabalho'),
    os.path.join(ONEDRIVE, 'Fentex Surgical', 'Area de Trabalho'),
    os.path.join(ONEDRIVE, 'CMEtK'),
    os.path.join(ONEDRIVE, 'Fentex Surgical'),
]

class MultiDirHandler(SimpleHTTPRequestHandler):
    def translate_path(self, path):
        # Remove query string and decode URL
        path = path.split('?', 1)[0].split('#', 1)[0]
        path = unquote(path)
        # Convert URL separators to OS separators
        parts = [p for p in path.split('/') if p and p != '..']
        rel   = os.path.join(*parts) if parts else ''

        # 1. Try Sistema Cotacao first
        p1 = os.path.join(DIR_SISTEMA, rel)
        if os.path.exists(p1):
            return p1

        # 2. Try parent directory (CMEtK)
        p2 = os.path.join(DIR_PAI, rel)
        if os.path.exists(p2):
            return p2

        # 3. Try extra roots (finds Fentex-Fotos-All in old location)
        for root in EXTRA_ROOTS:
            px = os.path.join(root, rel)
            if os.path.exists(px):
                return px

        # Default (will 404)
        return p1

    def end_headers(self):
        # Prevent browser caching so edits always appear immediately
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

    def log_message(self, fmt, *args):
        # Only log errors
        if args and str(args[1]) not in ('200', '304'):
            print(f"[{args[1]}] {args[0]}")

os.chdir(DIR_SISTEMA)
print("Servidor rodando: http://127.0.0.1:8766/cotacao-fx.html")
print(f"  Sistema:  {DIR_SISTEMA}")
print(f"  Pai:      {DIR_PAI}")
for r in EXTRA_ROOTS:
    exists = os.path.exists(r)
    print(f"  Extra:    {r}  {'[OK]' if exists else '[nao encontrado]'}")
HTTPServer(('127.0.0.1', 8766), MultiDirHandler).serve_forever()
