# Downloads and repacks archives to make with more accessible formats
$ProgressPreference='SilentlyContinue'
$ErrorActionPreference = "Stop"

#################################################################### Constants
$root = resolve-path "$PSScriptRoot/.."
$LLVMPROJECT = "https://api.github.com/repos/llvm/llvm-project/releases"
$initScript = "https://aka.ms/vcpkg-init.ps1"

####################################################### load console functions
. "$PSScriptRoot/console.ps1"
. "$PSScriptRoot/utils.ps1"

######################################################################## Setup 


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


function Repack-Tar-File($file) {
  $p = (get-childitem $file)
  $src=  (resolve-path $p.FullName).Path
  $dest = $src.substring(0,$src.LastIndexOf('.')) + ".bz2"
  
  if( test-path $dest ) {
    :green "Repacked file " |:cyan $dest |:green " already exists -- skipping" |:: 
  } else {
    try {
     :green "Repacking " |::|:>|:cyan $src |:green " to " |::|:cyan $dest |::|:<

      $tmp = tempdir
      pushd ($tmp)
      $shh = 7z x $src 
      $tar = (get-childitem .\*)[0].FullName
      $shh = 7z a -tbzip2 $dest $tar
    } finally {
      popd
      rmd $tmp 
    }
  }
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

    :green "Success: acquired VCPKG"
  } else {
    :red "Failed: acquiring VCPKG"
    exit
  }


  ################################################### get releases from github
  :green "Querying LLVM project releases..." |::
  $releases = get-json $LLVMPROJECT
  $releases | fl *

  repack-tar-file "./clang+llvm-14.0.0-aarch64-linux-gnu.tar.xz"

} finally {
  popd
  set-environment $orginalEnvironment
}