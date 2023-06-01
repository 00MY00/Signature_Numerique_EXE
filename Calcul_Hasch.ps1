###############################
# Crée par : Kuroakashiro
# Verssion : 2.0
# 
# Ce Script permet de recupéré la signer des executable 
# Verification du certificat
#
#   
# 
$Back = (Get-Location).Path

$colors = @(,
    "DarkGreen",
    "DarkCyan",
    "DarkYellow",
    "Gray",
    "DarkGray",
    "Blue",
    "Green",
    "Cyan",
    "Magenta"
)



# Définition du répertoire
while ($True) {
    $randomColor = Get-Random -InputObject $colors
    clear
    Write-Host "`n`n════════════════════════════════════════════════════════════════════════" -ForegroundColor Yellow
    Write-Host "[c:\Users] Indiquer le repertoire dans le quel ce trouve l'executable" -ForegroundColor Magenta
    Write-Host "[.] pour indiquer dans le répertoire courent" -ForegroundColor $randomColor
    Write-Host "[exit] " -NoNewline -ForegroundColor Red
    Write-Host "pour quiter" -ForegroundColor Yellow
    Write-Host "════════════════════════════════════════════════════════════════════════" -ForegroundColor Yellow
    $user = Read-Host "`n-> "

    if ($user -eq "exit") {
        Write-Host "BYE " -NoNewline -ForegroundColor Cyan
        Write-Host "BYE ..." -ForegroundColor Magenta
        Start-Sleep 2
        exit
    }

    if ($user -eq ".") {
        try {
            $filePath = "$Back"
            Write-Host "Répertoire : '$Back'" -ForegroundColor Green
            Start-Sleep 3
            break
        } catch {
            Write-Host "Une erreur est survenu avec le repertoire courent" -ForegroundColor Red
            Start-Sleep 5
            continue
        }
        
    }

    if (Test-Path "$user") {
        try {
            $filePath = "$User"
            Write-Host "Répertoire : '$User'" -ForegroundColor Green
            Start-Sleep 3
            break
        } catch {
            Write-Host "Une erreur est survenu avec le repertoire enté" -ForegroundColor Red
            Start-Sleep 5
        }
    } else {
        Write-Host "Répertoire inexistent !" -ForegroundColor Red
        Start-Sleep 5
    }

}


# Choit du Hachage
while ($True) {
    $randomColor = Get-Random -InputObject $colors
    clear
    Write-Host "`n`n══════════════════════════════════" -ForegroundColor Yellow
    Write-Host "Choisiser le type de hachage" -ForegroundColor Magenta
    Write-Host "[0] " -NoNewline -ForegroundColor $randomColor
    Write-Host "MD5" -ForegroundColor Cyan
    Write-Host "[1] " -NoNewline -ForegroundColor $randomColor
    Write-Host "SHA1" -ForegroundColor Cyan
    Write-Host "[2] " -NoNewline -ForegroundColor $randomColor
    Write-Host "SHA256" -ForegroundColor Cyan
    Write-Host "[exit] " -NoNewline -ForegroundColor Red
    Write-Host "pour quiter" -ForegroundColor Yellow
    Write-Host "══════════════════════════════════" -ForegroundColor Yellow
    Write-Host "`n"

    $user = Read-Host "`n-> "

    if ($user -eq "exit") {
        Write-Host "BYE " -NoNewline -ForegroundColor Cyan
        Write-Host "BYE ..." -ForegroundColor Magenta
        Start-Sleep 2
        exit
    }

    if ($user -eq "0") {
        $hashAlgorithm = "MD5"
        Write-Host "Type de HAChage : '$hashAlgorithm'" -ForegroundColor Green
        Start-Sleep 3
        break
    }

    if ($user -eq "1") {
        $hashAlgorithm = "SHA1"
        Write-Host "Type de HAChage : '$hashAlgorithm'" -ForegroundColor Green
        Start-Sleep 3
        break
    }

    if ($user -eq "2") {
        $hashAlgorithm = "SHA256"
        Write-Host "Type de HAChage : '$hashAlgorithm'" -ForegroundColor Green
        Start-Sleep 3
        break
    } else {
        Write-Host "Erreur d'entrée !" -ForegroundColor Red
        Start-Sleep 5
    }

}

clear
$randomColor = Get-Random -InputObject $colors
# Récuperation des fichier
$file = (Get-ChildItem -Path "$filePath" -Filter "*.exe" -File).Name

# Boucle pour afficher le contenu du tableau
Write-Host "`n`n`n`n════════════════════════════════════════════════════════════════════════" -ForegroundColor $randomColor

if ($file -is [array]) {
    $nombreElements = $file.Length
} else {                    # Ci just un élément
        $nombreElements = 1 
        $file = [array]$file
    }

# Affichage des licences
for ($i = 0; $i -lt $nombreElements; $i++) {

    $randomColor2 = Get-Random -InputObject $colors             # Coloration

    $Curentfile = "$filePath" + "\" + "$($file[$i])"            # Creation du chemin complait

    $hasher = [System.Security.Cryptography.HashAlgorithm]::Create($hashAlgorithm)
    $fileStream = [System.IO.File]::OpenRead($Curentfile)
    $hash = $hasher.ComputeHash($fileStream)
    $fileStream.Close()

    $hashString = [System.BitConverter]::ToString($hash) -replace "-", ""
    
    Write-Host "► " -NoNewline -BackgroundColor $randomColor2
    Write-Host "[$($file[$i])] : " -NoNewline -ForegroundColor Yellow
    Write-Host "$hashString" -ForegroundColor Magenta
}

Write-Host "════════════════════════════════════════════════════════════════════════" -ForegroundColor $randomColor

Read-Host "`nPAUSE"
exit




