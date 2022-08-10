function resolvepath([string] $filename) {
  $eError=$null
  $filename = Resolve-Path $filename -ErrorAction SilentlyContinue -ErrorVariable eError -relative

  if (-not($filename)) {
      return $eError[0].TargetObject
  }

  return $filename
}

function get-json([string]$url) {
  return convertfrom-json (iwr $url -useb).content
}


function get-environment() {
  $x = @{}; Get-ChildItem env: |% { $x[$_.name] =  $_.value } 
  return $x;
}

function set-environment($env) {
  $env.GetEnumerator() |% { set-item "env:$($_.Name)" $_.value } 
}


function ~() {
  if ($isVerbose ) {
    iex (($args |% { if( $_ -match " ") {"'$_'" } else { "$_" } } ) -join " ")
  }
}

function //() {
  if ($isDebug ) {
    iex (($args |% { if( $_ -match " ") {"'$_'" } else { "$_" } } ) -join " ")
  }
}