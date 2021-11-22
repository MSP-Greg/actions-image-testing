$ErrorActionPreference = 'Continue'

# below may not work on PS 5
$dash = if ($host.Version.major -eq '5') {"$([char]151)"} else {"—"}

$dash75 = $dash * 75

echo "`nCurrent Path: $PSScriptRoot"

# color hash used by EchoC and Color functions
$clr = @{
  'red' = [char]0x001B + '[31;1m'
  'grn' = [char]0x001B + '[32;1m'
  'yel' = [char]0x001B + '[93m'
  'blu' = [char]0x001B + '[34;1m'
  'mag' = [char]0x001B + '[35;1m'
  'cyn' = [char]0x001B + '[36;1m'
  'wht' = [char]0x001B + '[37;1m'
  'gry' = [char]0x001B + '[90;1m'
}

# Returns text in color
function Color($text, $color) {
  $rst = [char]0x001B + '[0m'
  $c = $clr[$color.ToLower()]
  "$c$text$rst"
}

# Writes text in color
function EchoC($text, $color) {
  echo $(Color $text $color)
}

echo ''

$where = 'bash.exe', 'sh.exe', 'make.exe', 'cmake.exe', 'bison.exe', 'ragel.exe',
  'tar.exe', '7z.exe', 'perl',
  'libcrypto-1_1-x64.dll', 'libssl-1_1-x64.dll', 'openssl.pc',
  'libeay32.dll', 'ssleay32.dll'
foreach ($e in $where) {
  EchoC "$dash75 $e" yel
  $rslt = where.exe $e 2>&1 | Out-String
  if ($rslt.contains($e)) { echo $rslt.Trim() }
  else { echo "Can't find $e" }
  echo ''
}

$version = @('gcc.exe')
foreach ($e in $version) {
  $rslts = where.exe $e 2>&1 | Out-String
  if ($rslts.Contains($e)) {
    EchoC "$dash75 gcc info" yel
    $ary = $rslts.Trim() -split "`r`n|`r|`n"
    foreach ($exe in $ary) {
      $exe = $exe.Trim()
      $out = &$exe --version | Out-String
      $out = "  " + ($out -split "`r`n|`r|`n")[0]
      echo "$exe --version"
      echo $out
    }
    echo ''
  }
}

$version = @('openssl.exe')
foreach ($e in $version) {
  $rslts = where.exe $e 2>&1 | Out-String
  if ($rslts.Contains($e)) {
    EchoC "$dash75 openssl info" yel
    $ary = $rslts.Trim() -split "`r`n|`r|`n"

    foreach ($exe in $ary) {
      $exe = $exe.Trim()
      $out = &$exe version | Out-String
      echo "$($out.Trim().PadRight(28))  $exe"
    }
    echo ''
  }
}
