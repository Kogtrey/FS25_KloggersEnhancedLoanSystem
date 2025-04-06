if (!(Test-Path "$PSScriptRoot/build")) { New-item -Path "$PSScriptRoot" -Name 'build' -ItemType Directory }
if (!(Test-Path "$PSScriptRoot/build/temp")) { New-item -Path "$PSScriptRoot/build" -Name 'temp' -ItemType Directory }


$FILES = @("gui", "images", "src", "translations")
$DESCFILE = [xml](Get-Content "$PSScriptRoot/modDesc.xml")
$DESCFILE.modDesc.version = Read-Host "New module version (Current: $($DESCFILE.xml.modDesc))"
$MOD_NAME = "FS25_KloggersEnhancedLoanSystem"
$mTEMPPATH = "$PSScriptRoot/build/temp/$MOD_NAME"

try {
    New-Item -Path "$PSScriptRoot/build/temp/" -Name $MOD_NAME -ItemType Directory
    
    $DESCFILE.InnerXml | Out-File "$PSScriptRoot/modDesc.xml"
    
    Copy-Item -Path "$PSScriptRoot/modDesc.xml" -Destination $mTEMPPATH
    Copy-Item -Path "$PSScriptRoot/*.dds" -Destination $mTEMPPATH
    foreach ($file in $FILES) {
        Copy-Item -Recurse -path "$PSScriptRoot/$file" -Destination $mTEMPPATH
    }
    
    Compress-Archive -Path $mTEMPPATH -DestinationPath "$PSScriptRoot/build/$MOD_NAME" -Update
    
    Remove-Item $mTEMPPATH -Recurse -Force
    
    Write-Host "Successfully packed '$MODULE_NAME v$($DESCFILE.ModuleVersion)" -fore Green
}
catch {
    Write-Error "Failed to pack module: $_"
    return
}