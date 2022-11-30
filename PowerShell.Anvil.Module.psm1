# Dot source public/private functions
$publicFunctionsPath = Join-Path -Path $PSScriptRoot -ChildPath '/src/public/*.ps1'
$privateFunctionsPath = Join-Path -Path $PSScriptRoot -ChildPath '/src/private/*.ps1'
$public = @(Get-ChildItem -Path $publicFunctionsPath -Recurse -ErrorAction Stop)
$private = @(Get-ChildItem -Path $privateFunctionsPath -Recurse -ErrorAction Stop)
foreach ($file in @($public + $private)) {
try {
. $file.FullName
}
 catch {
 throw "Unable to dot source [$($file.FullName)]"
 }
 }

 Export-ModuleMember -Function $public.BaseName