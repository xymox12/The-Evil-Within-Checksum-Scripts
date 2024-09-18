# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Death Count Reader"
$form.Size = New-Object System.Drawing.Size(400,300)

# Create a label to display the result
$label = New-Object System.Windows.Forms.Label
$label.Size = New-Object System.Drawing.Size(350,40)
$label.Location = New-Object System.Drawing.Point(20,50)
$label.Text = "Waiting for file selection..."
$form.Controls.Add($label)

# Create a button to open the file dialog
$button = New-Object System.Windows.Forms.Button
$button.Size = New-Object System.Drawing.Size(100,30)
$button.Location = New-Object System.Drawing.Point(150,100)
$button.Text = "Select File"
$form.Controls.Add($button)

# Function to find the last occurrence of "weapon/", locate the weapon name end, and calculate the death count
function Get-WeaponAndDeathCount {
    param (
        [string]$FilePath
    )

    # Read the file's bytes
    $FileBytes = [System.IO.File]::ReadAllBytes($FilePath)

    # Define the weapon string in ASCII bytes (for "weapon/")
    $weaponPattern = [System.Text.Encoding]::ASCII.GetBytes("weapon/")

    # Initialize variables
    $lastFoundPosition = -1

    # Search for the last occurrence of "weapon/" in the byte array
    for ($i = 0; $i -le ($FileBytes.Length - $weaponPattern.Length); $i++) {
        $found = $true
        for ($j = 0; $j -lt $weaponPattern.Length; $j++) {
            if ($FileBytes[$i + $j] -ne $weaponPattern[$j]) {
                $found = $false
                break
            }
        }
        if ($found) {
            # Update the last found position of the "weapon/" string
            $lastFoundPosition = $i
        }
    }

    if ($lastFoundPosition -ge 0) {
        # "weapon/" string found at the last position
        Write-Host "Found 'weapon/' at offset: $lastFoundPosition"

        # Extract the weapon name after "weapon/"
        $weaponNameStart = $lastFoundPosition + $weaponPattern.Length
        $weaponNameBytes = @()

        # Read bytes until we find a null byte, space, or underscore (terminators for weapon name)
        while ($weaponNameStart -lt $FileBytes.Length - 1) {
            $currentByte = $FileBytes[$weaponNameStart]
            if ($currentByte -eq 0x00 -or $currentByte -eq 0x20 -or $currentByte -eq 0x5F) {
                break
            }
            $weaponNameBytes += $currentByte
            $weaponNameStart++
        }

        # Convert weapon name bytes to string
        $weaponName = [System.Text.Encoding]::ASCII.GetString($weaponNameBytes)

        # Calculate the offset to the death count (104 bytes after the weapon name end)
        $deathCountOffset = $weaponNameStart + 104

        # Ensure the offset is within file bounds
        if ($deathCountOffset + 3 -lt $FileBytes.Length) {
            # Extract the 4-byte death count in Big-Endian format
            $deathCountBytes = $FileBytes[$deathCountOffset..($deathCountOffset + 3)]
            [Array]::Reverse($deathCountBytes)  # Reverse the byte order for Big-Endian
            $deathCount = [BitConverter]::ToInt32($deathCountBytes, 0)

            Write-Host "Death Count: $deathCount"
            return @{ Weapon = $weaponName; DeathCount = $deathCount }
        } else {
            Write-Host "Death count offset is outside of the file bounds."
            return $null
        }
    } else {
        Write-Host "'weapon/' string not found in the file."
        return $null
    }
}

# Button click event to select file and find the weapon name and death count
$button.Add_Click({
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    $OpenFileDialog.Filter = "All files (*.*)|*.*"
    
    if ($OpenFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $FilePath = $OpenFileDialog.FileName
        $label.Text = "Reading file..."

        # Get the weapon name and death count from the selected file
        $result = Get-WeaponAndDeathCount -FilePath $FilePath

        if ($result -ne $null) {
            $weaponName = $result.Weapon
            $deathCount = $result.DeathCount
            $label.Text = "Weapon currently held: $weaponName`nDeath Count: $deathCount"
        } else {
            $label.Text = "Weapon or Death count not found."
        }
    } else {
        $label.Text = "No file selected."
    }
})

# Show the form
[void]$form.ShowDialog()
