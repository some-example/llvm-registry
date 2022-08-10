param( [Switch]$debug, [Switch]$verbose )
# Downloads and repacks archives to make with more accessible formats
$ProgressPreference='SilentlyContinue'
$ErrorActionPreference = "Stop"
$isDebug=$debug.IsPresent
$isVerbose=$verbose.IsPresent

#################################################################### Constants
$root = resolve-path "$PSScriptRoot/.."
$LLVMPROJECT = "https://api.github.com/repos/llvm/llvm-project/releases"
$llvm = "llvm/llvm-project"
$initScript = "https://aka.ms/vcpkg-init.ps1"

$TARGETPROJECT = 'https://github.com/some-example/llvm-registry/releases/download'


####################################################### load console functions
. "$PSScriptRoot/console.ps1"
. "$PSScriptRoot/utils.ps1"
. "$PSScriptRoot/packing.ps1"
. "$PSScriptRoot/github.ps1"

######################################################################## Setup 
$assets = resolvepath "$root/.assets"


################################################################ cmdline tools 
$tools = resolvepath "$root/.tools"
new-alias 7z (resolve-path "$tools\7z\7z.exe")
new-alias github (resolve-path "$tools\gh\bin\gh.exe")

function rmd($folder) {
  if (test-path $folder) {
    $shh = cmd /c rmdir /s /q "$folder"
  }
}

function tempdir() {
  $temp = resolvepath "$env:tmp/repack"
  rmd $temp 
  $shh = mkdir -ea 0 $temp
  return $temp
}

function sha256($file) {
  $localhash = (Get-FileHash $file -ea 0)
  if( $localhash -ne $null) {
    return $localhash.hash.ToLower()
  }
  return $null
}

function newManifest() {
  return get-content "$PSScriptRoot/template.json.txt"  | convertfrom-json -asHashTable
}

function toJson($hashTable) {
  return convertto-json $hashTable -depth 100 
}

################################################################## Main Script
try {
  $orginalEnvironment = get-environment
  pushd $root

  ################################################## ensure vcpkg is installed
  iex (iwr -useb $initScript)
  if( get-command vcpkg -ea 0 ) {
    # ensure vcpkg-ce is installed too.
    vcpkg z-ce help | out-null

    :green "Success: acquired VCPKG" ::
  } else {
    :red "Failed: acquiring VCPKG" ::
    exit
  }
  
  ################################################### get releases from github
  :green "Querying LLVM project releases..." |::
  $llvmReleases = get-releases $llvm
  :note "Found " |:cyan $llvmReleases.Count |:darkgray " LLVM releases" |::

  $registryReleases = get-releases
  :note "Found " |:cyan $registryReleases.Count |:darkgray " registry releases" |::
  
  $llvmReleases.keys |% {
    $tag = $_
    $version = ($tag -split "(llvmorg-)(.*)")[2]
    if( $registryReleases.keys |? { $_ -match $version } ) {
      :green "Release exists: " |:cyan $version |::
      return;
    }
    
    :green "Ensuring files for release " :cyan $version :green " are downloaded" ::
    $assetFolder = resolvepath "$assets/llvm-$version"
    $shh = mkdir -ea 0 $assetFolder

    $files = get-assets $llvm $tag
    
    # filter out unsupported platforms
    $files = $files |? {
      ($_ -match "win64") `
      -or ($_ -match "win32") `
      -or ($_ -match "woa64") `
      -or ( ($_ -match "clang.llvm") -and -not ( $_ -match "freebsd"  )  -and -not ( $_ -match "solaris"  ) -and -not ($_ -match "powerpc" ) )
    }

    $localFiles = $files |% { download-asset $assetFolder $_ $llvm $tag} 

    $demands = (newManifest).demands.Values |% { $_['$MATCH'] }

    # ensure they are available in the correct format
    $outputFiles = $localFiles |% { 
      $file = resolve-path $_
      $ext = ($file -split "\.")[-1]
      switch( $ext) {
        "exe" {
          return (Repack-exe-file $file)
        }

        "xz" {
          return (Repack-Tar-File $file)
        };
        
        "zip" {
          # skip
          return $file
        };

        default {
          :red "Unsupported file extension: $file" |:cyan $ext |::
          exit;
        }
      }
    }

    $manifest = newManifest
    # create the artifact file for the release
    $outputFiles |% { 
      $file = $_
      $name = ($file -split '\\')[-1]
      $ext = ($file -split "\.")[-1]

      $found = $false
      if( $name -match "20.04") {
        return;
      }
      if( $name -match "sles") {
        return;
      }
       if( $name -match "20.10") {
        return;
      }
      
      # given an output, let's find out if there is an export for that.
      $manifest.demands.Values |% { 
        
        $demand = $_

        if( $demand['$MATCH'] -and ($name  -match $demand['$MATCH'])) {
          if( $found ) {
            :red "Found multiple matches for $name" |::
            exit;
          }
          $found = $true
          ~ : "Found match for $name "|:cyan $demand['$MATCH'] |::
          $demand.remove('$MATCH')

          if( $ext -eq "zip" ) {
            $demand.install.unzip = "$TARGETPROJECT/$tag/$name"
          } else {
            $demand.install.untar = "$TARGETPROJECT/$tag/$name"
          }
          $demand.install.sha256 = sha256 $file
        }
      }

      If (-not $found) {
        :red "No match found for $name" |::
        exit;
      }
    }   
    : "Creating manifest for release " |:cyan $version |::

    $manifest.info.version = $version

    $json = toJson $manifest
    $m2 = convertfrom-json $json -asHashTable

    $K =$manifest.demands.Keys
    # remove unused demands
    $K |% { 
      $q = $_
      
      if( $manifest.demands[$q]['$MATCH']  ) {
        $m2.demands.remove($q)
      }
    }

    $json = toJson $m2
    $jsonFile = resolvepath "$root/compilers/llvm-$version.json"

    :green "Writing manifest to " |:cyan $jsonFile |::
    set-content $jsonFile $json
    
    :green "Creating github release for " |:cyan "llvm-$version" |::
    new-github-release -name "llvm-$version"
    
    :green "Uploading files to release (background)" |:cyan "llvm-$version" |::
    upload-to-github-release -name "llvm-$version" -files $outputFiles
  }

} finally {
  vcpkg z-ce regenerate $root
  popd
  set-environment $orginalEnvironment
}