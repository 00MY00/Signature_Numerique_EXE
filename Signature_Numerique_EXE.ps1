##############################################################
# Crée par : Kuroakashiro
# V : 2.0
# 
# Ce Script permet de signer des executable 
# avec un sertificat SSL
#
#   Modification détection auto du repertoire de SDK Windows
# 
##############################################################

                                                  
                                                  
                                                  









# Racine de l'execution 
$Back = (Get-Location).Path



# Verification ci Administrateur ou non
$x = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if ($x -eq 'True') {Write-Host "Vous Avez bien les drois Administrateur" -ForegroundColor Green} else {Write-Host "Vous n'avez pas les drois Administrateur certaine action comme l'instalation de Module peuvent ne pas marcher !" -ForegroundColor Red; Read-Host "`n`nPAUSE"}


# Installation de choco
if (Get-Command choco -ErrorAction SilentlyContinue) {
    # Choco déja installer 
    Write-Host "Chocolatey est installé."
} else {
    Write-Host "Chocolatey n'est pas installé." -ForegroundColor Red 
    Write-Host "Début de l'Installation ..." -ForegroundColor Yellow
    # Installation Choco
    Write-Host "Fait Enter pour continuer une foit extraction afficher"
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}



# Installation de Openssl

# choco list openssl --localonly | Select-String -Pattern "openssl"


choco install openssl


$chemin = "C:\Program Files\OpenSSL-Win64\bin;"

# Vérifie si le chemin existe déjà dans la variable d'environnement Path
if (-not ($env:Path -split ';' | Select-String -Pattern "^$([regex]::Escape($chemin))$")) {
    # Ajoute le chemin à la variable d'environnement Path
    $nouveauPath = "$env:Path;$chemin"
    Set-ItemProperty -Path 'HKCU:\Environment' -Name 'Path' -Value $nouveauPath

    # Actualise la variable d'environnement Path dans la session actuelle
    $env:Path = $nouveauPath

    Write-Host "Le chemin pour : Openssl a été ajouté à la variable d'environnement Path." -ForegroundColor Green
} else {
    Write-Host "Le chemin pour : Openssl existe déjà dans la variable d'environnement Path." -ForegroundColor Green
}







# Installation de WinSDK
clear

if (Test-Path -Path "C:\Program Files (x86)\Windows Kits\10\bin\") { # Si le SDK 10 n'est pas installe

    $directory = 'C:\Program Files (x86)\Windows Kits\10\bin'
    $folders = Get-ChildItem $directory | Where-Object { $_.PSIsContainer }
    $folders = $folders.Name
    # Pour les calcule du repertoire le plus résent
    $largestNumber = -1
    # Recherche du docier le plus résent
    foreach ($folder in $folders) {
        $folderName = $folder
        # Ci le repertoire a un poin '.'
        if ($folderName -Match "\.") {
            $tmpName = $folderName
            $folderName = $folderName -replace '\.',''
            $folderNumber = $folderName.Substring(0, 6)
                # Recupère le plus grand des nom
                if ($folderNumber -gt $largestNumber) {
                    $largestNumber = $folderNumber
                    $global:max = $tmpName                         # Contien le nom du répertoire le plus résent dans SDK 10
                }
        }
    }

    
    if (Test-Path "C:\Program Files (x86)\Windows Kits\10\bin\$max\x64") {
        $global:SDKChemin = "C:\Program Files (x86)\Windows Kits\10\bin\$max\x64"      # Chemin complait SDK
    
    } else {
        Write-Host "Une erreur est survenu a la récuperation du chemin le plus resent !" -ForegroundColor Red
        Write-Host "Verifier que Windows SDK 10 soit bien installer !" -ForegroundColor Red
        Start-Sleep 5
        exit
    }
    

    $chemin = "$SDKChemin;"

    # Vérifie si le chemin existe déjà dans la variable d'environnement Path
    if (-not ($env:Path -split ';' | Select-String -Pattern "^$([regex]::Escape($chemin))$")) {
        # Ajoute le chemin à la variable d'environnement Path
        $nouveauPath = "$env:Path;$chemin"
        Set-ItemProperty -Path 'HKCU:\Environment' -Name 'Path' -Value $nouveauPath

        # Actualise la variable d'environnement Path dans la session actuelle
        $env:Path = $nouveauPath

        Write-Host "Le chemin pour : 'Signtool.exe a été ajouté à la variable d'environnement Path." -ForegroundColor Green
    } else {
        Write-Host "Le chemin pour : 'Signtool.exe existe déjà dans la variable d'environnement Path." -ForegroundColor Green
    }


} else {
    try {
        $DownloadUrl = "https://go.microsoft.com/fwlink/?linkid=2120843"
        $DownloadPath = "C:\Users\$env:USERNAME\Downloads\winsdksetup.exe"

        if (!(Test-Path $DownloadPath)) {
            Invoke-WebRequest -Uri $DownloadUrl -OutFile $DownloadPath
            Write-Host "Installation en cours..."
        }

        while ($True) {
            if (Test-Path $DownloadPath) {
                Write-Host "Le fichier est trouve. Installation en cours avec les configurations par defaut."
                Start-Process -FilePath $DownloadPath
                Start-Sleep 30
                break
            } else {
                Start-Sleep -Seconds 10
                Write-Host "Chargement..."
            }
        }
        # Installation de WinSDK reussie
        rm -force "$DownloadPath"       # Suprime l'installeur
    } catch {
        # Erreur lors de l'installation de WinSDK
    }
}

# List des action
while ($True) {

    $user = ""      # Rinisialise la variable user

$colors = @(,
    "DarkGreen",
    "DarkCyan",
    "DarkRed",
    "DarkYellow",
    "Gray",
    "DarkGray",
    "Blue",
    "Green",
    "Cyan",
    "Magenta"
)

$randomColor = Get-Random -InputObject $colors

clear
Write-Host """                                                                                            
/****,,,,,,......,,,.,,,.,,,,,.,,*@&      
 ####((##(((((##(#########(((((##%        
 //*******,,,,,,,*,,*,,,,,,,,**,,*        
 /******,,,,,,,,,,,,,,.,,,,,,,,,,*        
 /*****,,,,,,,,,*,,,*,...,..,,,,,,        
 /****,,,,,,*,,,,,,,,,,.,...,,,,,,        
 ****,*,,,,,,,,,,,,,,......,.,.,,,        
 ******,,,,,,,,..,.......,.....,,,        
 /*/***,,,,,,,,.,.,......,....,,.,        
 /*****,*,,,*,,,..,...........,,,,        
 /******,,*,,,*,,,...........,,,,,        
 /******,,,,,,,,,,,,,.,,.,.....,,*        
 //******,**,,,,,,,.,,......,.,,,,        
 /****,,,,,,,,,,,,,.,,,.,,.,,.,,*,        
 /*//**,,,*,.,,,,,.,.,,,,,,,,,,,**        
****,,.......... .  .........,,,,*        
@(/****,,,,,,,,,,,,,,,,,,,,,*****/(       
                                                                       
""" -ForegroundColor $randomColor

$randomColor = Get-Random -InputObject $colors
    cd $Back
    Start-Sleep 3
    clear
    Write-Host "`n`n"
    Write-Host "SDK Location : " -NoNewline -ForegroundColor Cyan
    Write-Host "'$SDKChemin'" -ForegroundColor Blue
    Write-Host "╔═════════════════════════════════╗" -ForegroundColor $randomColor
    Write-Host "║  Sélectionner l'action à faire  ║" -ForegroundColor Yellow
    Write-Host "║[a] Affiche les licences crées   ║" -ForegroundColor Yellow
    Write-Host "║[s] Signe Un Executable          ║" -ForegroundColor Yellow
    Write-Host "║[k] Créer un certificat          ║" -ForegroundColor Yellow
    Write-Host "║[" -NoNewline -ForegroundColor Yellow
    Write-Host "exit" -NoNewline -ForegroundColor Red 
    Write-Host "] Pour quiter               ║" -ForegroundColor Yellow
    Write-Host "╚═════════════════════════════════╝" -ForegroundColor $randomColor
    Write-Host "" 
    Write-Host ""
    $user = Read-Host "-> " 

    if ($user -eq "exit") { # Quiter le script
        Write-Host "BYE " -NoNewline -ForegroundColor Cyan
        Write-Host "BYE ..." -ForegroundColor Magenta
        Start-Sleep 2
        exit
    }
    if ($user -eq "k") { # Crée un cerificat

        # Creation dossier de clé
        if (Test-Path "$Back\SSL") {                                        # Test ci le répertoir exist
            Write-Host "Le répertoire : '$Back\SSL' de licence exist déja" -ForegroundColor Yellow
            Start-Sleep 2
        } else {
            Write-Host "Creation du répertoire : '$Back\SSL'" -ForegroundColor Green
            & New-Item -ItemType Directory -Path "$Back\SSL" > $null        # Crée le repertoire
            Start-Sleep 2
        }
        ################
        while ($True) {                                                     # Choix du nom du certificat
            clear
            Write-Host "`n`n"
            $randomColor = Get-Random -InputObject $colors
            Write-Host "===========================================`n" -ForegroundColor $randomColor
            Write-Host "Choisisser le nom du certificat`n"
            Write-Host "===========================================`n" -ForegroundColor $randomColor

            $SSLName = Read-Host "-> "
            if (Test-Path "$Back\SSL\$SSLName*") {
                Write-Host "Le Nom identique existe déja !" -ForegroundColor Yellow
                Start-Sleep 5
            } else {
                Write-Host "Creation du sertificat '$SSLName' suivez les étape SVP" -ForegroundColor Green
                Start-Sleep 5
                break
            }
        }
        ################
        while ($True) {                                                     # Choix de la durée du certificat
            clear
            Write-Host "`n`n"
            $randomColor = Get-Random -InputObject $colors
            Write-Host "===========================================`n" -ForegroundColor $randomColor
            Write-Host "Choisisser la durée du certificat en jours`n"
            Write-Host "===========================================`n" -ForegroundColor $randomColor

            $SSLDuree = Read-Host "-> "
            if ($SSLDuree -gt 0) { # Verification que la durée du certificat est réalisable
                Write-Host "La durée est de '$SSLDuree' joures" -ForegroundColor Green
                Start-Sleep 5
                break
            } else {
                Write-Host "L'entrée n'est pas posible '$SSLDuree'" -ForegroundColor Red
                Start-Sleep 5
            }
        }

        ## Clé et certif SSL
        ############################
        clear
        Write-Host "`n`n"
        Write-Host "Récapitulatif : oublier pas le nom du certificat 'CN='"
        Write-Host "Récapitulatif : Nom des certificats : '$SSLName.csr' | '$SSLName.pfx' | 'private_$SSLName.key'"
        Write-Host "Récapitulatif : Durée du certificat : '$SSLDuree'"
        Write-Host "`n`n"

        cd "$Back\SSL\"                                                                 # Aller dans le bon repertoire SSL
        ## Creation de clé
        # openssl req -newkey rsa:2048 -nodes -keyout "private_$SSLName.key" -out "$SSLName.csr"        # Premier test
        try {
            # Reusit de la creation clé RSA auto completation
            openssl req -newkey rsa:2048 -nodes -keyout "$Back\SSL\private_$SSLName.key" -out "$Back\SSL\$SSLName.csr"
            Write-Host "Reusit de la creation clé RSA " -ForegroundColor Green
        } catch {
            # Erreur de la creation clé RSA auto completation
            Write-Host "Erreur de la creation clé RSA auto completation" -ForegroundColor Red
            try {                                                                                       # Mode manuel ci échèque
                # Reusit de la creation clé RSA manuell
                openssl req -newkey rsa:2048 -nodes -keyout "$Back\SSL\private_$SSLName.key" -out "$Back\SSL\$SSLName.csr"
                Write-Host "Reusit de la creation clé RSA manuell" -ForegroundColor Green
            } catch {
                # Erreur de la creation clé RSA manuell
                Write-Host "Erreur de la creation clé RSA manuell" -ForegroundColor Red
            }
        }
        ## Signature du sertificat avec clé priver
        try {
            # Reusit de la signature du certificat avec la clé RSA
            openssl x509 -req -days $SSLDuree -in "$Back\SSL\$SSLName.csr" -signkey "$Back\SSL\private_$SSLName.key" -out "$Back\SSL\$SSLName.crt"
            Write-Host "Signature du sertificat avec clé priver" -ForegroundColor Green
        } catch {
            # Erreur de la signature du certificat avec la clé RSA
            Write-Host "Erreur de la signature du certificat avec la clé RSA" -ForegroundColor Red
        }
        ## Convertion en PFXS
        try {
            # Reusit de la convertion de la clé '$SSLName.crt' en '$SSLName.pfx'
            openssl pkcs12 -export -in "$Back\SSL\$SSLName.crt" -inkey "$Back\SSL\private_$SSLName.key" -out "$Back\SSL\$SSLName.pfx"
            Write-Host "Reusit de la convertion de la clé '$SSLName.crt' en '$SSLName.pfx'" -ForegroundColor Green
        } catch {
            # Erreur de la convertion de la clé '$SSLName.crt' en '$SSLName.pfx'
            Write-Host "Erreur de la convertion de la clé '$SSLName.crt' en '$SSLName.pfx'" -ForegroundColor Red
        }
        ############################
        cd "$Back"                                                                      # Retoure Racine
        Start-Sleep 5
        # Fin Creation certificat
    }


    if ($user -eq "s") { # Signer un certificat
        while ($True) {
            clear
            $randomColor = Get-Random -InputObject $colors
            Write-Host "===========================================" -ForegroundColor $randomColor
            Write-Host "Choisisser une licence a utiliser !`n"
            Write-Host "===========================================`n" -ForegroundColor $randomColor
            
            $file = (Get-ChildItem -Path "$Back\SSL\" -Filter "*.pfx" -File).Name
            

            # Boucle pour afficher le contenu du tableau
            Write-Host "========================================" -ForegroundColor Yellow

            if ($file -is [array]) {
                $nombreElements = $file.Length
            } else {                    # Ci just un élément
                $nombreElements = 1 
                $file = [array]$file
            }

            # Affichage des licences
            for ($i = 0; $i -lt $nombreElements; $i++) {
                $Curentfile = $file[$i]
                Write-Host "[$i] : " -NoNewline -ForegroundColor Yellow
                Write-Host "$Curentfile" -ForegroundColor Magenta
            }

            $SSLName = Read-Host "-> "

            if (Test-Path "$Back\SSL\$($file[$SSLName])") {              # Verification que la licence existe
            $SSLName = "$($file[$SSLName])"
                Write-Host "Licence choisit : '$SSLName'" -ForegroundColor Green
                Start-Sleep 5
                break
            } else {
                Write-Host "Licence non existante !" -ForegroundColor Red
                Start-Sleep 5
            }
        }

        # Aller au répertoire
        if (Test-Path "$SDKChemin") {
            cd "$SDKChemin"
        } else {
            Write-Host "Erreur le répertoire Windows SDK est introuvable !" -ForegroundColor Red
            Start-Sleep 5
            exit
        }

        while ($True) {
            clear
            $randomColor = Get-Random -InputObject $colors
            Write-Host "===========================================" -ForegroundColor $randomColor
            Write-Host "Entrée le mot de passe de la licence"
            Write-Host "===========================================`n" -ForegroundColor $randomColor
            $SSLMdp = Read-Host "-> "

            if ($SSLMdp -eq "") {
                Write-Host "Entée Invalide !" -ForegroundColor Red
                Start -Sleep 5
            } else {
                Write-Host "MDP entrée !" -ForegroundColor Green
                Start-Sleep 5
                break
            }
        }

        while ($True) {         # Chemin exe
            clear
            $randomColor = Get-Random -InputObject $colors
            Write-Host "===========================================" -ForegroundColor $randomColor
            Write-Host "Entrée le chemin complait de l'executable"
            Write-Host "Sur le quel ajouter la licence"
            Write-Host "===========================================`n" -ForegroundColor $randomColor

            $Executabl = Read-Host "-> "

            if (Test-Path "$Executabl") {
                Write-Host "Chemin exist '$Executabl' !" -ForegroundColor Green
                Start-Sleep 5
                break
            } else {
                Write-Host "Erreur chemin non existent '$Executabl' !" -ForegroundColor Red
                Start-Sleep 5
            }
        }


        while ($True) {         # CN=
            clear
            $randomColor = Get-Random -InputObject $colors
            Write-Host "===========================================" -ForegroundColor $randomColor
            Write-Host "Entrée le nom 'CN' de votre licence"
            Write-Host "===========================================`n" -ForegroundColor $randomColor

            $SSLCn = Read-Host "-> "

            if (Test-Path "$SSLCn") {
                Write-Host "Chemin exist '$SSLCn' !" -ForegroundColor Green
                Start-Sleep 5
                break
            } else {
                Write-Host "Erreur chemin non existent '$SSLCn' !" -ForegroundColor Red
                Start-Sleep 5
            }
        }



        # Signe l'executable
        try {
            .\signtool sign /n "$SSLCn" /f "$Back\SSL\$SSLName" /p "$SSLMdp" /fd sha256 "$Executabl"
            Write-Host "Commande terminer avec sucssès !" -ForegroundColor Green
        } catch {
            while ($True) {
                clear
                Write-Host "Une erreur est survenu il est posible que le nom du certificat soit diferent. `nCi vous avec utiliser un certificat manuel" ForegroundColor Red
                Write-Host "Entrer le nom du proprietaire du sertificat 'CN='" -ForegroundColor Yellow

                $SSLCertNom = Read-Host "-> "
                if ($SSLCertNom -eq "") {
                    Write-Host "Entée Invalide !" -ForegroundColor Red
                    Start -Sleep 5
                } else {
                    Write-Host "Nom entrée !" -ForegroundColor Green
                    Start-Sleep 5
                    break
                }
            }
            # Dernière tentative
            try {
                .\signtool sign /n "$SSLCertNom" /f "$Back\SSL\$SSLName" /p "$SSLMdp" /fd sha256 "$Executabl"
            } catch {
                Write-Host "Erreur la dernière tentative de signment à échouer !" -ForegroundColor Red
                Start-Sleep 5

            }
        }
        Start-Sleep 5
        # Fin de la signature
    }


    if ($user -eq "a") { # Affichage des licence crée
        $colors = @(,
        "DarkGreen",
        "DarkCyan",
        "DarkRed",
        "DarkYellow",
        "Gray",
        "DarkGray",
        "Blue",
        "Green",
        "Cyan",
        "Magenta"
        )

        clear
        if (Test-Path "$Back\SSL\") {
            $randomColor = Get-Random -InputObject $colors
            Write-Host "========================" -ForegroundColor $randomColor
            Get-ChildItem -Path "$Back\SSL\" -Filter "*.pfx" | Select-Object -ExpandProperty Name
            Write-Host "========================`n" -ForegroundColor $randomColor
        } else {
            $randomColor = Get-Random -InputObject $colors
            Write-Host "========================" -ForegroundColor $randomColor
            Write-Host "Aucunne licence crée avec le script" -ForegroundColor Magenta
            Write-Host "Affichage de Cert:\CurrentUser\My" -ForegroundColor Yellow
            Write-Host "========================`n" -ForegroundColor $randomColor
            Get-ChildItem -Path Cert:\CurrentUser\My
        }

        Read-Host "`n`nPAUSE"
        # Fin Affichage licences
    }


}




















