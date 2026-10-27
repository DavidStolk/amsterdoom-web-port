@echo off
rem Serves this folder on http://localhost and opens Amsterdoom in the browser.
rem Browsers do not run the game from a file:// page. Close this window to stop.
set "ADAM_BAT=%~f0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((Get-Content -LiteralPath $env:ADAM_BAT -Raw) -csplit ('#'+'POWERSHELL'),2)[1]"
if errorlevel 1 pause
exit /b
#POWERSHELL
$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetDirectoryName($env:ADAM_BAT).TrimEnd('\') + '\'
$types = @{ '.html' = 'text/html; charset=utf-8'; '.js' = 'text/javascript'; '.wasm' = 'application/wasm' }
$port = 8123
while ($true) {
  $http = New-Object System.Net.HttpListener
  $http.Prefixes.Add("http://localhost:$port/")
  try { $http.Start(); break } catch { $http.Close(); $port++; if ($port -gt 8199) { throw } }
}
Write-Host "Amsterdoom: http://localhost:$port/  (close this window to stop)"
Start-Process "http://localhost:$port/"
while ($http.IsListening) {
  $ctx = $http.GetContext()
  $res = $ctx.Response
  try {
    $rel = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath).TrimStart('/')
    if ($rel -eq '') { $rel = 'index.html' }
    $file = [IO.Path]::GetFullPath([IO.Path]::Combine($root, $rel))
    if ($file.StartsWith($root, [StringComparison]::OrdinalIgnoreCase) -and [IO.File]::Exists($file)) {
      $type = $types[[IO.Path]::GetExtension($file).ToLowerInvariant()]
      if (-not $type) { $type = 'application/octet-stream' }
      $res.ContentType = $type
      $fs = [IO.File]::OpenRead($file)
      try { $res.ContentLength64 = $fs.Length; $fs.CopyTo($res.OutputStream) } finally { $fs.Close() }
    } else {
      $res.StatusCode = 404
    }
  } catch {
    # the browser closed the connection (page reloaded or closed): keep serving
  } finally {
    try { $res.Close() } catch { }
  }
}
