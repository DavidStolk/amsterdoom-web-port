# Amsterdoom — web port

Play **Amsterdoom** (the Dutch first-person shooter from 2000, set in Amsterdam) in a modern web
browser.

This repository contains only the **port**: the game program rebuilt for the browser
(WebAssembly and WebGL2). It contains **none of the game's files** (levels, graphics, sounds,
music, the intro film). To play, you need **your own copy of Amsterdoom**: the original CD, or a
folder where the game is installed.

## Playing

1. Start the page (see [Running it](#running-it) below) and wait for it to load.
2. Click **Kies de cd-map… / Choose the CD folder…** and choose the folder of your Amsterdoom CD,
   or the folder the game is installed in. The page finds the game in it by itself, so the CD
   drive itself is fine (it looks for `Adamwin.ini`, which on the CD is in `Target Files`).
   - The files are read into this browser's own storage (IndexedDB). **They are not uploaded or
     sent anywhere.** Reading in takes from a few seconds to about a minute (around 220 MB).
   - Optional: add **Times New Roman** (`times.ttf`, found in `C:\Windows\Fonts` on Windows) for
     a few texts in the game ("please wait", the pause screen). Without it those texts use the
     menu's own font.
3. Click **Klik om te spelen** to start. Browsers only allow sound after a click.

On later visits the game starts straight away; the files are still in the browser. Saved players
are kept in the browser too. To remove the game files, use the link on the start screen ("remove
the game files from this browser"); your saved players stay.

The game is in Dutch.

## Running it

The page has to come from a web server. Browsers do not run it when you open `index.html`
directly from disk (it stays on "Laden…").

### Online (GitHub Pages)

The repository can be served as is with GitHub Pages: in the repository's **Settings → Pages**,
choose **Deploy from a branch**, branch `main`, folder `/ (root)`. The game is then at
`https://<user>.github.io/amsterdoom-web-port/`. Any other static web hosting works as well; the
server only has to send `.wasm` files as `application/wasm`, as current servers do.

### On your own computer

Download the repository (**Code → Download ZIP**, then unpack it, or `git clone` it). Each
starter runs a small web server that only this computer can reach (127.0.0.1, from port 8123
up) and opens the game in your default browser. Nothing needs to be installed.

- **Windows:** double-click **Start Amsterdoom.bat**. It uses Windows' own PowerShell. Close its
  window to stop. If Windows warns about a downloaded file: **More info → Run anyway**.
- **Mac:** double-click **Start Amsterdoom.command**. It uses the Perl that comes with macOS
  (`serve.pl`). Close its Terminal window to stop. The first time, macOS may refuse to open it:
  right-click it, choose **Open**, then **Open** again.
- **Linux:** run `./start-amsterdoom.sh` in a terminal (or let your file manager run it). It uses
  Perl (`serve.pl`), or Python 3 when Perl is missing. Press Ctrl+C to stop.
- **By hand**, with any static web server, for example:

  ```sh
  cd amsterdoom-web-port
  python3 -m http.server 8123 --bind 127.0.0.1
  ```

  Then open <http://127.0.0.1:8123/>. If the port is taken, use another number, such as 8124.

Note that the browser keeps the imported files and saved players per address. Each address
(for example `127.0.0.1:8123` versus `127.0.0.1:8124`, or the online page) asks for the CD once
and has its own saved players.

### Browsers

A current Chrome, Edge, Firefox or Safari on a desktop or laptop. The browser needs WebGL2 and
must allow choosing a folder. Phones and tablets are not supported (keyboard, mouse or game
controller needed).

## Controls

The original defaults; change them in the menu under **Opties → Besturing**.

| Action | Keyboard and mouse |
|---|---|
| Walk forward / back | ↑ / ↓ |
| Step left / right | ← / → |
| Turn left / right | Shift + ← / → |
| Look around | mouse (click into the game to capture it) |
| Fire | Ctrl or left mouse button |
| Jump | Space |
| Choose a weapon | 1–5 (next: Insert or middle mouse button, previous: Shift+7) |
| Look up / down / centre | A / Z / Shift+6 |
| Pause | P |
| Back to the menu | Esc (also releases the mouse) |

**Game controller** (Xbox and compatible; press a button once so the page notices it). The
original game had no controller support; its buttons can be changed on the same Besturing
screen.

| Action | Controller |
|---|---|
| Walk / step | left stick |
| Turn / look | right stick |
| Fire | RT |
| Walk slowly | hold LT |
| Jump | A |
| Previous / next weapon | LB / RB |
| Weapon 1–4 | D-pad ↑ → ↓ ← |
| Centre the view | click the right stick |
| Pause | Start |
| Back to the menu | B or Back/View |

In the menus: arrow keys or D-pad to move, Enter or A to press, Escape or B to go back.

Add `?nointro` to the page's address to skip the intro film.

## Troubleshooting

- **It stays on "Laden…"**: the page was opened from disk. Use one of the ways under
  [Running it](#running-it).
- **"No Amsterdoom found in this folder"**: choose the CD itself, its `Target Files` folder, or
  the folder of the installed game. The game folder needs `Adamwin.ini`, `AdamWin.exe`,
  `AdamMenu.exe` and the `Levels` folder.
- **"The browser could not keep the files"**: the browser has too little storage for this site,
  or is in private mode. You can play, but you will have to choose the folder again next time.
- **No sound**: click into the page once; browsers only start sound after a click.
- **The mouse does not turn**: click into the game. Esc releases the mouse again.

## What is in here

| File | What |
|---|---|
| `index.html` | the page: the import of your game files and the start |
| `Amsterdoom.js`, `Amsterdoom.wasm` | the game program (WebAssembly) |
| `Start Amsterdoom.bat` | local starter for Windows |
| `Start Amsterdoom.command`, `start-amsterdoom.sh` | local starters for Mac and Linux |
| `serve.pl` | the small local web server the Mac and Linux starters use |
| `LICENSE-Genesis3D.txt` | the license of the 3D engine |

## Legal

Amsterdoom, its name, levels, graphics, sounds, music and film are the property of their rights
holders. This repository contains none of them; you need your own copy of the game to play.

The engine is **Genesis3D 1.0** (Genesis3D Public License, see `LICENSE-Genesis3D.txt`). Also
used: **SDL2** (zlib license), **pl_mpeg** (MIT license) and **stb_truetype** (public domain).
