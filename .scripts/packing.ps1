
function Repack-Tar-File($file) {
  $p = (get-childitem $file)
  $src=  (resolve-path $p.FullName).Path
  $dest = $src.substring(0,$src.LastIndexOf('.')) + ".bz2"
  
  if( test-path $dest ) {
    ~ :green "Repacked file " :cyan $dest :green " already exists -- skipping" :: 
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
  return $dest
}

function Repack-Exe-File($file) {
  $p = (get-childitem $file)
  $src=  (resolve-path $p.FullName).Path
  $dest = $src.substring(0,$src.LastIndexOf('.')) + ".zip"
  
  if( test-path $dest ) {
    ~ :green "Repacked file " :cyan $dest :green " already exists -- skipping" :: 
  } else {
    try {
     :green "Repacking " |::|:>|:cyan $src |:green " to " |::|:cyan $dest |::|:<

      $tmp = tempdir
      pushd ($tmp)
      $shh = 7z x $src 
      
      if( test-path '.\$PLUGINSDIR' ) {
        cmd /c rmdir /s /q  '.\$PLUGINSDIR'
      }

      if( test-path '.\Uninstall.exe' ) {
        erase '.\Uninstall.exe'
      }

      $shh = 7z a -tzip $dest *
    } finally {
      popd
      rmd $tmp 
    }
  }
  return $dest
}


function sha256($file) {
  $localhash = (Get-FileHash $file -ea 0)
  if( $localhash -ne $null) {
    return $localhash.hash.ToLower()
  }
  return $null
}