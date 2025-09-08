if ($env:SystemDrive -ne 'X:') {
    Set-ExecutionPolicy Bypass -Force
    Write-SectionHeader -Message "**Testing**"
    #Windows Updates
    Write-SectionHeader -Message "**Running MS Updates**"
    Write-Host -ForegroundColor Gray "**Running Defender Updates**"
    Update-DefenderStack
    Write-Host -ForegroundColor Gray "**Running Windows Updates**"
    Start-WindowsUpdate
    Write-Host -ForegroundColor Gray "**Running Driver Updates**"
    Start-WindowsUpdateDriver

    #Store Updates
    Write-Host -ForegroundColor Gray "**Running Winget Updates**"
    Write-Host -ForegroundColor Gray "Invoke-UpdateScanMethodMSStore"
    Invoke-UpdateScanMethodMSStore
    #Write-Host -ForegroundColor Gray "winget upgrade --all --accept-package-agreements --accept-source-agreements"
    #winget upgrade --all --accept-package-agreements --accept-source-agreements
    # Execute local Hash.ps1 script with error handling
    Write-Host -ForegroundColor Gray "**Running Hash.ps1 Script**"
    try {
        if (Test-Path "C:\OSDCloud\Scripts\SetupComplete\Hash.ps1") {
            & "C:\OSDCloud\Scripts\SetupComplete\Hash.ps1"
            Write-Host -ForegroundColor Green "Hash.ps1 completed successfully"
        } else {
            Write-Host -ForegroundColor Yellow "Hash.ps1 not found at specified path"
        }
    }
    catch {
        Write-Host -ForegroundColor Red "Error running Hash.ps1: $($_.Exception.Message)"
    }
    #Modified Version of Andrew's Debloat Script
    Write-SectionHeader -Message "**Running Debloat Script**" 
    iex (irm https://raw.githubusercontent.com/jrd-ta/OSDCloud/refs/heads/main/Scripts/RemoveBloat.ps1)
    #MS Teams personal removal
    Write-Host -ForegroundColor Gray "**Removing Microsoft Teams Personal**"
    iex (irm https://raw.githubusercontent.com/jrd-ta/OSDCloud/refs/heads/main/Scripts/TeamsRemoval.ps1)

    #OSDCloud cleanup script
    Write-SectionHeader -Message "**Running OSDCloud Cleanup Script**"
    iex (irm https://raw.githubusercontent.com/jrd-ta/OSDCloud/refs/heads/main/Scripts/CleanUp.ps1)
    
    #OEM Updates
    try {
        iex (irm https://raw.githubusercontent.com/jrd-ta/OSDCloud/refs/heads/main/Scripts/Lenovo.ps1)
    }
    catch {}

    try {
        iex (irm https://raw.githubusercontent.com/jrd-ta/OSDCloud/refs/heads/main/Scripts/Dell.ps1)
    }
    catch {}

    #Set Time Zone
    Write-Host -ForegroundColor Gray "**Setting TimeZone based on IP**"
    Set-TimeZoneFromIP

    Write-SectionHeader -Message  "**Completed Sub script**" 
    #OSDCloud cleanup script
    Write-SectionHeader -Message "**Running OSDCloud Cleanup Script**"
    iex (irm https://raw.githubusercontent.com/jrd-ta/OSDCloud/refs/heads/main/Scripts/CleanUp.ps1)
}