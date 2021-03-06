#DEDUP-GUI v1.01
#By ptit_poulet

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void][System.Windows.Forms.Application]::EnableVisualStyles() 
 
$form = New-Object Windows.Forms.Form
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $False
$form.MinimizeBox = $False
$form.Text = "DEDUP-GUI"
$form.Size = New-Object System.Drawing.Size(675,260)

$labelVersion = New-Object System.Windows.Forms.Label
$labelVersion.Location = New-Object System.Drawing.Point(10,215)
$labelVersion.Size = New-Object System.Drawing.Size(195,18)
$labelVersion.Text = "Version 0.99"
$form.Controls.Add($labelVersion)

$labelMoi = New-Object System.Windows.Forms.Label
$labelMoi.Location = New-Object System.Drawing.Point(590,215)
$labelMoi.Size = New-Object System.Drawing.Size(195,18)
$labelMoi.Text = "By ptit_poulet"
$form.Controls.Add($labelMoi)

$ListViewHDD = New-Object System.Windows.Forms.ListView 
$ListViewHDD.Location = New-Object System.Drawing.Size(5,5)
$ListViewHDD.Width = 660
$ListViewHDD.Height = 150  
$ListViewHDD.View = 'Details'
$ListViewHDD.Columns.Add('Partition', 50)
$ListViewHDD.Columns.Add('Nom complet', 75)
$ListViewHDD.Columns.Add('Taille (Go)', 60)
$ListViewHDD.Columns.Add('Libre (Go)', 59)
$ListViewHDD.Columns.Add('Déduplication', 77)
$ListViewHDD.Columns.Add('Espace gagné (Go)', 105)
$ListViewHDD.Columns.Add('Optimisation (%)', 90)
$ListViewHDD.Columns.Add('Tâche en cours', 90)
$ListViewHDD.Columns.Add('Etat (%)', 50)
$form.Controls.Add($ListViewHDD)

$buttonActualiser = New-Object System.Windows.Forms.Button
$buttonActualiser.Text = "Actualiser"
$buttonActualiser.Location = New-Object System.Drawing.Size(40,165)
$buttonActualiser.Size = New-Object System.Drawing.Size(100,40)
$form.Controls.Add($buttonActualiser)

$buttonOptimiser = New-Object System.Windows.Forms.Button
$buttonOptimiser.Text = "Optimiser"
$buttonOptimiser.Location = New-Object System.Drawing.Size(200,165)
$buttonOptimiser.Size = New-Object System.Drawing.Size(100,40)
$form.Controls.Add($buttonOptimiser)

$buttonNettoyer = New-Object System.Windows.Forms.Button
$buttonNettoyer.Text = "Nettoyer"
$buttonNettoyer.Location = New-Object System.Drawing.Size(360,165)
$buttonNettoyer.Size = New-Object System.Drawing.Size(100,40)
$form.Controls.Add($buttonNettoyer)

$buttonDesactiver = New-Object System.Windows.Forms.Button
$buttonDesactiver.Text = "Désactiver"
$buttonDesactiver.Location = New-Object System.Drawing.Size(520,165)
$buttonDesactiver.Size = New-Object System.Drawing.Size(100,40)
$form.Controls.Add($buttonDesactiver)

$labelInfo = New-Object System.Windows.Forms.Label
$labelInfo.Location = New-Object System.Drawing.Point(270,215)
$labelInfo.Size = New-Object System.Drawing.Size(300,18)
$form.Controls.Add($labelInfo)

$buttonActualiser.Add_Click(
	{
		Actualiser
	})

$buttonOptimiser.Add_Click(
	{
		Optimiser
	})
	
$buttonNettoyer.Add_Click(
	{
		Nettoyer
	})
	
$buttonDesactiver.Add_Click(
	{
		Desactiver
	})

Function Lancement
	{
		Set-ExecutionPolicy Unrestricted

		If (Get-Module -ListAvailable -Name Deduplication) 
			{
				Import-Module Deduplication
			}
		Else
			{
				DISM.exe /Online /Add-Package /PackagePath:./Microsoft-Windows-VdsInterop-Package~31bf3856ad364e35~amd64~~10.0.15063.0.cab /PackagePath:./Microsoft-Windows-VdsInterop-Package~31bf3856ad364e35~amd64~en-US~10.0.15063.0.cab
				DISM.exe /Online /Add-Package /PackagePath:./Microsoft-Windows-FileServer-ServerCore-Package~31bf3856ad364e35~amd64~~10.0.15063.0.cab /PackagePath:./Microsoft-Windows-FileServer-ServerCore-Package~31bf3856ad364e35~amd64~en-US~10.0.15063.0.cab
				DISM.exe /Online /Add-Package /PackagePath:./Microsoft-Windows-Dedup-ChunkLibrary-Package~31bf3856ad364e35~amd64~~10.0.15063.0.cab /PackagePath:./Microsoft-Windows-Dedup-ChunkLibrary-Package~31bf3856ad364e35~amd64~en-US~10.0.15063.0.cab
				DISM.exe /Online /Add-Package /PackagePath:./Microsoft-Windows-Dedup-Package~31bf3856ad364e35~amd64~~10.0.15063.0.cab /PackagePath:./Microsoft-Windows-Dedup-Package~31bf3856ad364e35~amd64~en-US~10.0.15063.0.cab
				DISM.exe /Online /Enable-Feature /FeatureName:Dedup-Core /All
				Import-Module Deduplication
			}
		
		Actualiser
	}

Function Actualiser
	{
		$labelInfo.Text = "Actualisation en cours..."
		$form.Refresh
		
		$ListViewHDD.Items.Clear()
		
		$partitionLetter = Get-Partition | where {$_.DriveLetter} | where {($_.IsBoot -like 'False') -and ($_.Type -like 'IFS')} | select DriveLetter, Size/1Gb | sort DriveLetter
		
		foreach($obj in $partitionLetter)
			{
				$infoVolume = Get-Volume | where {$_.DriveLetter -like $obj.DriveLetter} | select Size, SizeRemaining, FileSystemLabel
				$infoDedup = Get-DedupVolume | where {$_.Volume -like $obj.DriveLetter+":"} | select Enabled, SavedSpace, SavingsRate
					
				$ListViewHDDItem = New-Object System.Windows.Forms.ListViewItem($obj.DriveLetter)
				$ListViewHDDItem.Subitems.Add($infoVolume.FileSystemLabel)
				$ListViewHDDItem.Subitems.Add([math]::round($infoVolume.Size/1GB,2))
				$ListViewHDDItem.Subitems.Add([math]::round($infoVolume.SizeRemaining/1GB,2))
					
				If ($($infoDedup.Enabled) -like "True" -or (Get-DedupJob | where {$_.Volume -like $obj.DriveLetter+":"}))
					{
						$ListViewHDDItem.Subitems.Add("Activé")
						$ListViewHDDItem.Subitems.Add([math]::round($infoDedup.SavedSpace/1GB,2))
						$ListViewHDDItem.Subitems.Add($infoDedup.SavingsRate)
							
						$infoDedupJob = Get-DedupJob | where {$_.Volume -like $obj.DriveLetter+":"} | select Progress
							
						If ($infoDedupJob)
							{
								$ListViewHDDItem.Subitems.Add($($infoDedupJob.Progress).count)
								$ListViewHDDItem.Subitems.Add($($infoDedupJob.Progress | Measure-Object -Sum).sum)
							}
						Else
							{
								$ListViewHDDItem.Subitems.Add("0")
								$ListViewHDDItem.Subitems.Add("Terminé")
							}
					}
				Else
					{
						$ListViewHDDItem.Subitems.Add("Désactivé")
						$ListViewHDDItem.Subitems.Add("0")
						$ListViewHDDItem.Subitems.Add("0")
						$ListViewHDDItem.Subitems.Add("0")
						$ListViewHDDItem.Subitems.Add("Néant")
					}
				$ListViewHDD.Items.Add($ListViewHDDItem)		
			}
		
		$labelInfo.Text = "Actualisation terminée."
		$form.Refresh
	}

Function Optimiser
	{
		$volume = $ListViewHDD.SelectedItems | Foreach-Object {$_.Text}
		$infoVolume = Get-Volume | where {$_.DriveLetter -like $volume} | select Size, SizeRemaining
		$volume = $volume+":"
		$infoDedup = Get-DedupVolume | where {$_.Volume -like $volume} | select Enabled
		
		If ($($infoDedup.Enabled) -like "True")
			{		
				Start-DedupJob -Type Optimization -Volume $volume
				$labelInfo.Text = "Optimisation en cours..."
				$form.Refresh
			}
		Else
			{
				$pourcentage = $infoVolume.SizeRemaining * 100 / $infoVolume.Size
		
				If ($pourcentage -le "10")
					{
						$labelInfo.Text = "Optimisation impossible ! Espace disponible insuffisant !"
						$form.Refresh	
					}
				Else
					{
						Enable-DedupVolume -Volume $volume
						Set-DedupVolume -Volume $volume -MinimumFileAgeDays 0
						Start-DedupJob -Type Optimization -Volume $volume
						$labelInfo.Text = "Optimisation en cours..."
						$form.Refresh
					}
			}
	}
	
Function Nettoyer
	{
		$volume = $ListViewHDD.SelectedItems | Foreach-Object {$_.Text}
		$volume = $volume+":"
		$infoDedup = Get-DedupVolume | where {$_.Volume -like $volume} | select Enabled
		
		If ($($infoDedup.Enabled) -like "True")
			{		
				Start-DedupJob -Type GarbageCollection -Volume $volume
				Start-DedupJob -Type Scrubbing -Volume $volume
				$labelInfo.Text = "Nettoyage en cours..."
				$form.Refresh
			}
		Else
			{
				$labelInfo.Text = "Nettoyage impossible..."
				$form.Refresh			
			}
	}

Function Desactiver
	{
		$volume = $ListViewHDD.SelectedItems | Foreach-Object {$_.Text}
		$infoVolume = Get-Volume | where {$_.DriveLetter -like $volume} | select SizeRemaining
		
		$volume = $volume+":"
		$infoDedup = Get-DedupVolume | where {$_.Volume -like $volume} | select SavedSpace
		
		$total = $infoVolume.SizeRemaining - $infoDedup.SavedSpace * 1.1
	
		If ($total -le "0")
			{
				$labelInfo.Text = "Désactivation impossible ! Espace disponible insuffisant !"
				$form.Refresh	
			}
		Else
			{
				Start-DedupJob -Type GarbageCollection -Volume $volume
				Start-DedupJob -Type Scrubbing -Volume $volume
				Start-DedupJob -Type Unoptimization -Volume $volume
				Disable-DedupVolume -Volume $volume
				
				$labelInfo.Text = "Désactivation en cours..."
				$form.Refresh
			}
	}

Lancement

$form.ShowDialog()