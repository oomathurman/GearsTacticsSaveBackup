# Parameters
$BaseDir = $env:LOCALAPPDATA + "\Packages\Microsoft.GanderBaseGame_8wekyb3d8bbwe\SystemAppData"
$BackupDir = "D:\automation\GearsTacticsSaveBackup"  #Change this to where you want to backup to

$Backups = Get-ChildItem -Path $BackupDir -Filter *.zip
$Count = 1

do {
    clear-host
    write-host "Select an option:"
    write-host "`t1. Backup"
    write-host "`t2. Restore"
    write-host "`t3. Cleanup Backup Files"
    write-host "`t4. Exit"
    write-host ""
    $mode = read-host "Option: "

    if ($mode -eq 1){

        write-host "Backing up!"
        foreach($item in $Backups){
            $Count++
        }
        Compress-Archive -Path $BaseDir\wgs -DestinationPath $BackupDir\Backup$Count.zip
    }
    Elseif ($mode -eq 2){
        $Backups = Get-ChildItem -Path $BackupDir -Filter *.zip
        do {
            clear-host
            write-host "Select Restore File:"
            $BackupCount = 1
            write-host "`t+-----------------------+-------------------------------+"
            write-host "`t|`tFile Name`t|     Last Write`t`t|"
            write-host "`t+-----------------------+-------------------------------+"
            foreach($item in $Backups){
                write-host "`t|  "$item "`t|" $item.LastWriteTime"`t`t|"
                $BackupCount++
            }
            write-host "`t|`tExit`t`t|     Exit Application`t`t|"
            write-host "`t+-----------------------+-------------------------------+"
            write-host ""
            $restorePoint = read-host "File Name: "
            do {
                try {
                    Remove-Item -path $BaseDir\wgs -recurse
                    Expand-Archive $BackupDir\$restorePoint -DestinationPath $BaseDir
                    write-host "Restoring File"
                    $x = 999
                    $restorePoint = "Exit"
                }
                catch {
                    $x = 999
                    write-host "File Not Restored"
                }
            }
            Until ($x -eq 999)
            
        }
        while ($restorePoint -notlike 'Exit')

    }
    ElseIf ($mode -eq 3){
        $Backups = Get-ChildItem -Path $BackupDir -Filter *.zip
        write-host "Remove all backup files?"
        $confirmYN = read-host "Y/N"
        if ($confirmYN -eq "Y"){
            foreach($item in $Backups){
                Remove-Item -path $BackupDir\$item
            }
        }
    }
    ElseIf ($mode -eq 4 -or $mode -like "Exit"){
        write-host "Exiting"
        $y = 999
    }
}
Until ($y -eq 999)


