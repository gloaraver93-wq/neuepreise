# Tuningrechner

Reiner Rechner: Leistungen antippen, Menge ändern, Rabatt eintragen, unten steht der Kundenpreis. Einzelpreise sind auf der Seite ausgeblendet, keine Bilder, keine Rechnung, kein Login.

## In GitHub einfügen (bestehendes Repository)
1. ZIP entpacken.
2. Im GitHub-Repository: **Add file → Upload files**. Alle entpackten Dateien (`index.html`, `server.js`, `package.json`, `render.yaml`, `README.md`) per Drag & Drop hineinziehen. Sie müssen **ganz oben** im Repository liegen, nicht in einem Unterordner. Gleichnamige Dateien werden überschrieben.
3. **Commit changes** klicken.
4. Render veröffentlicht automatisch neu (sonst: Dienst öffnen → Manual Deploy → Deploy latest commit). In Render muss „Root Directory“ leer sein und der Start-Befehl `node server.js` lauten.

## Neue Seite auf Render
- **Variante A (Static Site):** New → Static Site → Repository wählen → Build Command leer lassen → Publish Directory `.` → Create.
- **Variante B (Web Service):** New → Web Service → Runtime Node → Build Command `echo ok` → Start Command `node server.js`.

## Preise ändern
Auf der Seite: **✏️ Leistungen verwalten**. Wichtig: Änderungen werden nur im Browser des jeweiligen Geräts gespeichert, nicht auf dem Server. Wer dauerhaft eine neue Preisliste für alle möchte, lässt sie im Code ändern (`index.html`, Zeile mit `PARTS0`).
