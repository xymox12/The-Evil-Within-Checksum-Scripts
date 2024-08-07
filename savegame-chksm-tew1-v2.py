import hashlib
import os

def md5_to_4byte_reduction(data):
    md5_hash = hashlib.md5(data).digest()

    # Combine bytes using shifting and bitwise operations, followed by rearrangement
    combined = (
            ((md5_hash[10] << 24) |
             (md5_hash[11] << 16) |
             (md5_hash[12] << 8) |
             md5_hash[13])
            ^
            ((md5_hash[14] << 24) |
             (md5_hash[15] << 16) |
             (md5_hash[0] << 8) |
             md5_hash[1])
    )

    combined ^= (
            ((md5_hash[2] << 24) |
             (md5_hash[3] << 16) |
             (md5_hash[4] << 8) |
             md5_hash[5])
            ^
            ((md5_hash[6] << 24) |
             (md5_hash[7] << 16) |
             (md5_hash[8] << 8) |
             md5_hash[9])
    )

    # Rearrange the bytes to match the desired order
    rearranged = (
            ((combined >> 16) & 0xFF) << 24 |
            ((combined >> 24) & 0xFF) << 16 |
            (combined & 0xFF) << 8 |
            ((combined >> 8) & 0xFF)
    )

    return rearranged


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


# Print the original and calculated checksums in hexadecimal format
print(f"Original checksum: {original_checksum:08x}")
print(f"Calculated checksum: {calculated_checksum:08x}")

# Compare the checksums
if original_checksum == calculated_checksum:
    print("Checksums match!")
else:
    print("Checksums do not match.")

    # Create the new checksum bytes
    new_checksum_bytes = calculated_checksum.to_bytes(4, 'big')

    # Combine the new checksum with the rest of the file data
    new_data = new_checksum_bytes + data[4:]

    # Create the new file name
    base_name, ext = os.path.splitext(file_path)
    new_file_path = f"{base_name}_modified{ext}"

    # Write the modified data to a new file
    with open(new_file_path, 'wb') as new_file:
        new_file.write(new_data)

    print(f"New file saved with updated checksum: {new_file_path}")
