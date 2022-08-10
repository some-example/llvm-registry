function has-release($name) {
  $shh = github release view $name 
  if( $lastexitcode -eq 0 ) {
    return $true
  }
  return $false
}

function get-releases([string]$repo=$null)
{
  $releases = $null
  if( $repo ) {
    $releases = github release list --repo $repo -L 500
  } else {
    $releases = github release list -L 500
  }
  if( $releases ) {
    # ensure we have an array
    $releases = @($releases)

    # filter out prereleases
    $releases = $releases |? { -not ($_ -match "pre-release") }
    $result = @{}

    $releases |% {
      # split on tabs
      $split = $_ -Split ([char]9)

      $result[$split[2]] = @{
        name = $split[0]
        status = $split[1]
        tag = $split[2]
        time = $split[3]
      }
    }
      return $result;
  }
  
  return @{}
}

function get-assets([string]$repo=$null, [string]$tag="") {
  $assets = $null
  if( $repo ) {
    $assets = github release view $tag --repo $repo 
  } else {
    $assets = github release view $tag
  }
  # trim unnecessary assets
  $assets = $assets |? { ($_ -match "^asset:") -and (-not ($_ -match 'sha256$' )) -and -not ($_ -match 'sig$' ) -and -not ($_ -match "src") } 
  
  # just the filenames 
  return $assets |% { ($_ -split ([char]9))[1] }
}

function download-asset([string]$directory, [string]$file ,[string]$repo=$null, [string]$tag="")
{
  $target = resolvepath "$directory/$file"
  if( test-path $target) {
    ~ :green "Skipping download of " :cyan $file :green " - already exists" ::
    return $target;
  }

  :green "Downloading " |:cyan $file |:green " ." |::
  if( $repo ) {
    github release download $tag --repo $repo --dir $directory --pattern $file
  } else {
    github release download $tag --dir $directory --pattern $file
  }
  return $target;
}

function new-github-release([string]$repo=$null, [string]$name) {
  if( (has-release $name) ) {
    :green "Release " |:cyan $name |:green " already exists" ::
    return
  }

  ~ : green "Creating release" :cyan $name ::
  
  if( $repo ) {
    $shh = github release create $name --title $name --notes $name --repo $repo 
  } else {
    $shh = github release create $name --title $name --notes $name 
  }
}

function upload-to-github-release([string]$repo=$null, $name, $files) {
   if( -not (has-release $name) ) {
    :red "Release " |:cyan $name |:red " doesnt exists" ::
    exit
  }
  ~ : green "Uploading " :cyan @($files) :green " to " :cyan $name ::

  $job = @($files) | % -Parallel {
    $file = $_
    if( $repo ) {
      & "$using:tools\gh\bin\gh.exe" release upload $using:name  $file  --repo $using:repo
    } else {
      & "$using:tools\gh\bin\gh.exe" release upload $using:name  $file
    }
  }
  if( $job ) {
    : before
    receive-job -wait $job
    : after
  }
  
}