function Get-MD5Hash {
    param (
        [byte[]]$data
    )

    # Create an MD5 hash object
    $md5 = [System.Security.Cryptography.MD5]::Create()
    
    # Compute the MD5 hash
    return $md5.ComputeHash($data)
}

function Convert-MD5To4ByteReduction {
    param (
        [byte[]]$data
    )

    $md5Hash = Get-MD5Hash -data $data

    # Convert the necessary bytes to 32-bit unsigned integers
    $part1 = [BitConverter]::ToUInt32($md5Hash[10..13], 0)
    $part2 = [BitConverter]::ToUInt32($md5Hash[14..15] + $md5Hash[0..1], 0)
    $part3 = [BitConverter]::ToUInt32($md5Hash[2..5], 0)
    $part4 = [BitConverter]::ToUInt32($md5Hash[6..9], 0)

    # XOR the parts together
    $combined1 = $part1 -bxor $part2
    $combined2 = $part3 -bxor $part4

    $finalCombined = $combined1 -bxor $combined2

    # Rearrange the bytes as per the original script
    $rearranged = (($finalCombined -shr 16) -band 0xFF) -shl 24 -bor
                  (($finalCombined -shr 24) -band 0xFF) -shl 16 -bor
                  (($finalCombined -band 0xFF) -shl 8) -bor
                  (($finalCombined -shr 8) -band 0xFF)

    return $rearranged
}

# Replace 'path_to_your_file' with the actual path to your binary file
$filePath = "savefiles/inventory.zwei"

# Read the file data
$data = [System.IO.File]::ReadAllBytes($filePath)

# Ensure data is loaded correctly and is longer than 4 bytes
if ($data.Length -lt 4) {
    throw "Invalid file: The file must be at least 4 bytes long."
}

# Extract the original checksum (first 4 bytes)
$originalChecksum = [BitConverter]::ToUInt32($data[0..3], 0)

# Calculate checksum for the rest of the file data
$calculatedChecksum = Convert-MD5To4ByteReduction -data $data[4..($data.Length - 1)]

# Print the original and calculated checksums in hexadecimal format
Write-Host ("Original checksum: {0:X8}" -f $originalChecksum)
Write-Host ("Calculated checksum: {0:X8}" -f $calculatedChecksum)

# Compare the checksums
if ($originalChecksum -eq $calculatedChecksum) {
    Write-Host "Checksums match!"
} else {
    Write-Host "Checksums do not match."

    # Create the new checksum bytes
    $newChecksumBytes = [BitConverter]::GetBytes($calculatedChecksum)

    # Combine the new checksum with the rest of the file data
    $newData = $newChecksumBytes + $data[4..($data.Length - 1)]

    # Create the new file name
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
    $ext = [System.IO.Path]::GetExtension($filePath)
    $newFilePath = "$baseName`_modified$ext"

    # Write the modified data to a new file
    [System.IO.File]::WriteAllBytes($newFilePath, $newData)

    Write-Host "New file saved with updated checksum: $newFilePath"
}
