# Tuningrechner (Render, Node-Dienst)

Dateien: `server.js`, `package.json`, `render.yaml`, `public/index.html`, `supabase/schema.sql`. Der Server liefert nur die Seite aus (keine Variablen, kein Login, keine Festplatte nötig).

## Auf eine bestehende Render-Seite aufspielen
1. ZIP entpacken. Im GitHub-Repository „Add file → Upload files“, alle Dateien und die Ordner `public` und `supabase` hochladen (Gleichnamiges wird überschrieben, nichts in einem Unterordner).
2. Render deployt automatisch neu, sonst „Manual Deploy → Deploy latest commit“. „Root Directory“ leer lassen, Start-Befehl `node server.js`.

## Funktionen
- Leistungen antippen, Menge ändern, Fahrzeugklasse und Rabatt wählen. Unten steht groß der **Kundenpreis**.
- Einzelpreise sind auf der Seite ausgeblendet. Sie stehen nur im Dialog „✏️ Leistungen verwalten“, wo du Preise ändern, Leistungen hinzufügen und löschen kannst.
- Fahrzeugklassen mit Faktor (Standard: Normal ×1, Hypercar ×1,9), im Dialog „⚙️ Klassen verwalten“ änderbar.
- „📋 Text kopieren“ liefert Leistungen und Kundenpreis ohne Einzelpreise. „🗑️ Leeren“ setzt die Auswahl zurück.
- Keine Bilder, keine Rechnungsfunktion, kein Login. Die Seite ist öffentlich.

## Wo werden die Daten gespeichert?
- **Ohne Cloud-Speicher** (Standard nach dem Hochladen): nur im Browser des jeweiligen Geräts. Das ist **nicht** dauerhaft und nicht geräteübergreifend: Die Daten sind weg, wenn der Browser-Speicher gelöscht wird, im privaten Modus oder auf einem anderen Gerät. Die Seite zeigt „💾 Nur in diesem Browser gespeichert“.
- **Mit Cloud-Speicher** (Supabase, kostenlos): Jede Änderung wird automatisch auf dem Server gespeichert und mit allen Geräten geteilt, die denselben Link benutzen. Die Seite zeigt „☁️ In der Cloud gespeichert“ oder eine Fehlermeldung.

## Cloud-Speicher einrichten (einmalig, ca. 10 Minuten)
1. Auf supabase.com ein Konto anlegen und ein neues Projekt erstellen (Region in Europa).
2. Links **SQL Editor** → neue Abfrage → kompletten Inhalt von `supabase/schema.sql` einfügen → **Run**.
3. **Project Settings → API**: **Project URL** und **anon public**-Schlüssel (neu: „publishable key“) kopieren. Niemals den `service_role`-Schlüssel verwenden.
4. In `index.html` die Zeile mit `SUPABASE_URL:""` und `SUPABASE_ANON_KEY:""` suchen (nahe dem Ende des Quelltexts) und deine Werte in die Anführungszeichen einsetzen. Auf GitHub geht das im Browser über das Stift-Symbol. Dann „Commit changes“.
5. Nach dem Neu-Deployen die Seite öffnen. Beim ersten Besuch legt sie automatisch einen Arbeitsbereich an. Der Code steht im Link nach `#w=` und im Dialog **☁️ Cloud**.
6. Auf anderen Geräten oder für andere Personen: im Dialog „☁️ Cloud“ auf „Link kopieren“ klicken und den Link weitergeben.

## Wichtig
- **Wer den Link (mit Code) hat, kann alles sehen und ändern.** Ohne Code ist kein Zugriff möglich.
- Ändern zwei Geräte gleichzeitig, überschreibt keins stillschweigend das andere: Die Seite meldet einen Konflikt, und du wählst, welcher Stand gilt.
- Ist die Cloud kurz nicht erreichbar, speichert die Seite lokal weiter und lädt später automatisch hoch.
- Kostenlose Supabase-Projekte werden nach etwa einer Woche ohne Aktivität pausiert (bitte aktuell prüfen). Dann ist die Cloud nicht erreichbar, bis du das Projekt wieder startest. Die Daten bleiben erhalten.
- Neue Preisliste auf einer bestehenden Seite: Wer die vorherige Standardliste unverändert hatte, bekommt die neue automatisch. Eigene, veränderte Listen bleiben unangetastet. „↺ Standardliste“ im Dialog „Leistungen verwalten“ stellt die 34 Leistungen wieder her.
