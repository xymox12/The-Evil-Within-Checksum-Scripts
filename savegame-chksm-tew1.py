import hashlib
import os

def md5_to_4byte_reduction(data):
    # Compute MD5 hash
    md5_hash = hashlib.md5(data).digest()

    # Extract and combine bytes as per the given disassembly logic
    r8d = (md5_hash[10] << 8) | md5_hash[11]
    r8d = (r8d << 8) | md5_hash[12]
    r8d = (r8d << 8) | md5_hash[13]

    r8d ^= ((md5_hash[14] << 24) | (md5_hash[15] << 16) | (md5_hash[0] << 8) | md5_hash[1])

    ecx = (md5_hash[2] << 8) | md5_hash[3]
    ecx = (ecx << 8) | md5_hash[4]
    ecx = (ecx << 8) | md5_hash[5]

    eax = ((md5_hash[6] << 8) | md5_hash[7])
    eax = (eax << 8) | md5_hash[8]
    eax = (eax << 8) | md5_hash[9]

    eax ^= r8d

    # Combine more bytes
    edx = ((md5_hash[2] << 8) | md5_hash[3])
    edx = (edx << 8) | md5_hash[4]
    edx = (edx << 8) | md5_hash[5]

    eax ^= edx

    return eax


def rearrange_bytes(val):
    """Rearrange the bytes of a 4-byte value to match the desired order."""
    b0 = (val >> 24) & 0xFF
    b1 = (val >> 16) & 0xFF
    b2 = (val >> 8) & 0xFF
    b3 = val & 0xFF

    # Rearrange bytes to achieve desired checksum output: A19C9C0B
    rearranged_val = (b1 << 24) | (b0 << 16) | (b3 << 8) | b2

    return rearranged_val


# Replace 'path_to_your_file' with the actual path to your binary file
file_path = 'savefiles/inventory.zwei'

# Read the file data
with open(file_path, 'rb') as file:
    data = file.read()

# Ensure data is loaded correctly and is longer than 4 bytes
if len(data) < 4:
    raise ValueError("Invalid file: The file must be at least 4 bytes long.")

# Extract the original checksum (first 4 bytes)
original_checksum = int.from_bytes(data[:4], 'big')

# Calculate checksum for the rest of the file data
calculated_checksum = md5_to_4byte_reduction(data[4:])

# Rearrange the calculated checksum to match the expected pattern
rearranged_checksum = rearrange_bytes(calculated_checksum)

# Print the original and calculated checksums in hexadecimal format
print(f"Original checksum: {original_checksum:08x}")
print(f"Calculated checksum: {rearranged_checksum:08x}")

# Compare the checksums
if original_checksum == rearranged_checksum:
    print("Checksums match!")
else:
    print("Checksums do not match.")

    # Create the new checksum bytes
    new_checksum_bytes = rearranged_checksum.to_bytes(4, 'big')

    # Combine the new checksum with the rest of the file data
    new_data = new_checksum_bytes + data[4:]

    # Create the new file name
    base_name, ext = os.path.splitext(file_path)
    new_file_path = f"{base_name}_modified{ext}"

    # Write the modified data to a new file
    with open(new_file_path, 'wb') as new_file:
        new_file.write(new_data)

    print(f"New file saved with updated checksum: {new_file_path}")
