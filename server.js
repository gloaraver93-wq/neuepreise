'use strict';
// Kleiner Webserver: liefert die Seite (index.html) aus. Keine Datenbank, kein Login, keine Einstellungen nötig.
const http = require('http'), fs = require('fs'), path = require('path');
const PORT = process.env.PORT || 3000;
const HEAD = { 'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'no-cache', 'X-Content-Type-Options': 'nosniff', 'X-Frame-Options': 'DENY', 'Referrer-Policy': 'same-origin' };
const findFile = () => [path.join(__dirname, 'index.html'), path.join(__dirname, 'public', 'index.html')].find(f => fs.existsSync(f));
http.createServer((req, res) => {
  let p = '/';
  try { p = new URL(req.url, 'http://x').pathname; } catch (e) {}
  if (p === '/healthz') { res.writeHead(200, { 'Content-Type': 'text/plain' }); return res.end('ok'); }
  if (p === '/' || p === '/index.html') {
    const f = findFile();
    if (!f) { res.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' }); return res.end('index.html fehlt'); }
    const s = fs.createReadStream(f);
    s.on('error', () => { if (!res.headersSent) res.writeHead(500); res.end('Fehler'); });
    s.once('open', () => { res.writeHead(200, HEAD); s.pipe(res); });
    return;
  }
  res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' }); res.end('Nicht gefunden');
}).listen(PORT, () => console.log('Läuft auf Port ' + PORT));
