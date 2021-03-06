#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Install-WindowsFeature -Name RSAT-AD-Tools;Install-WindowsFeature -Name GPMC;Install-WindowsFeature -Name RSAT-DNS-Server

Install-WindowsFeature ADFS-Federation -IncludeManagementTools

$LocalTempDir = $env:TEMP
$dirsync = "dirsync-win64.exe" 
(new-object System.Net.WebClient).DownloadFile('https://dl.google.com/dirsync/dirsync-win64.exe', "$LocalTempDir\$dirsync"); & "$LocalTempDir\$dirsync" -q    

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
$git = "Git.exe" 
(New-Object net.webclient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/Git-2.28.0-32-bit.exe', "$LocalTempDir\$git"); & "$LocalTempDir\$git" /VERYSILENT

$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)

