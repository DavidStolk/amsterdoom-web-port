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
3. Click **Klik om te spelen** to start. Browsers only allow sound after a click.

On later visits the game starts straight away; the files are still in the browser. Saved players
are kept in the browser too. To remove the game files, use the link on the start screen ("remove
the game files from this browser"); your saved players stay.

The game is in Dutch.

## Running it

The page has to come from a web server. Browsers do not run it when you open `index.html`
directly from disk (it stays on "Laden…").

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

**Game controller** (Xbox, PS5 and compatible; press a button once so the page notices it).

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

## Legal

Amsterdoom, its name, levels, graphics, sounds, music and film are the property of their rights
holders. This repository contains none of them; you need your own copy of the game to play.

The engine is **Genesis3D 1.0** (Genesis3D Public License, see `LICENSE-Genesis3D.txt`). Also
used: **SDL2** (zlib license), **pl_mpeg** (MIT license), **stb_truetype** (MIT license or public
domain) and **Emscripten** with its **musl** C library (MIT license). Their license texts are in
`THIRD-PARTY-LICENSES.txt`.
