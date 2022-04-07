$path = "C:\Script Test\"
$softwares = Import-Csv "C:\Script Test\pkgs.csv" -Delimiter "," -Header 'Installer','switch' | Select-Object Installer,switch

foreach($software in $softwares){

    $softexec = $software.Installer
    $softexec = $softexec.ToString()

    $pkgs = Get-ChildItem $path$softexec | Where-Object {$_.Name -eq $softexec}

    foreach($pkg in $pkgs){

        $ext = [System.IO.Path]::GetExtension($pkg)
        $ext = $ext.ToLower()

        $switch = $software.switch
        $switch = $switch.Tostring()

        if($ext -eq ".msi"){
        mkdir c:\Temp\Softwares -Force 
        Copy-Item "$path$softexec" -Recurse c:\Temp\Softwares -Force
        Write-Host "Installing $softexec silently, please wait..." -foregroundColor Yellow
        Start-Process "c:\Temp\Softwares\$softexec" -ArgumentList "$switch" -wait

        Remove-Item "c:\temp\softwares\$softexec" -Recurse -Force
        Write-Host "Installation of $softexec completed" -foregroundColor Green

        }
        else{

        mkdir c:\Temp\Softwares -Force 
        Copy-Item "$path$softexec" -Recurse c:\Temp\Softwares -Force
        Write-Host "Installing $softexec silently, please wait..." -BackgroundColor Yellow
        Start-Process "c:\Temp\Softwares\$softexec" -ArgumentList "$switch" -wait -NoNewWindow

        Remove-Item "c:\temp\softwares\$softexec" -Recurse -Force
        Write-Host "Installation of $softexec completed" -BackgroundColor Green

        }


   } 
}

