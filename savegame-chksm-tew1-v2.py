import hashlib
import os


def md5_to_4byte_reduction(data):
    # Compute the MD5 hash of the input data
    md5_hash = hashlib.md5(data).digest()

    # Note on the calculatations below:
    # The << operator shifts the bits of the byte value to the left
    # e.g. 11111111  (binary representation of 0xFF) << 24 ==
    # 11111111 00000000 00000000 00000000  (24 bits added on the right, binary)
    # == 32-bit integer (or 0xFF000000, in this example)
    #
    # The pipe symbol (|) in the operation is the bitwise OR operator
    # If md5_hash[11] == 0x9C,  then md5_hash[11] << 16 == 0x009C0000
    # 0xFF000000
    # OR 0x009C0000
    # ----------
    # 0xFF9C0000 etc...
    #
    # XOR (^): Each XOR operation mixes the bits from the combined parts.
    # This process ensures that changes in any part of the input data significantly affect the output checksum.
    #
    # Finally the result is rearranged to provide the final checksum:
    # The >> operator shifts the bits of the byte value to the right
    # e.g. 0x36BD28F6 >> 16
    # 00110110 10111101 00101000 11110110  # 0x36BD28F6
    # 00000000 00000000 00110110 10111101  # 0x000036BD
    # Bitwise AND with 0xFF to isolate the least significant byte
    # 00110110 10111101 AND 00000000 11111111 == 00111101  # 0xBD
    # 10111101 << 24 == 10111101 00000000 00000000 00000000 # 0xBD000000


    # Combine md5_hash[10] through md5_hash[13] into a 32-bit integer
    part1 = (
            (md5_hash[10] << 24) |
            (md5_hash[11] << 16) |
            (md5_hash[12] << 8) |
            md5_hash[13]
    )

    # Combine md5_hash[14], md5_hash[15], md5_hash[0], and md5_hash[1] into another 32-bit integer
    part2 = (
            (md5_hash[14] << 24) |
            (md5_hash[15] << 16) |
            (md5_hash[0] << 8) |
            md5_hash[1]
    )

    # XOR the two parts together to combine their bits
    combined1 = part1 ^ part2

    # Combine md5_hash[2] through md5_hash[5] into another 32-bit integer
    part3 = (
            (md5_hash[2] << 24) |
            (md5_hash[3] << 16) |
            (md5_hash[4] << 8) |
            md5_hash[5]
    )

    # Combine md5_hash[6] through md5_hash[9] into another 32-bit integer
    part4 = (
            (md5_hash[6] << 24) |
            (md5_hash[7] << 16) |
            (md5_hash[8] << 8) |
            md5_hash[9]
    )

    # XOR these two new parts together to combine their bits
    combined2 = part3 ^ part4

    # Final XOR to combine the fully mixed parts
    final_combined = combined1 ^ combined2


    # Rearrange the bytes of the result to achieve the desired checksum output format
    rearranged = (
            ((final_combined >> 16) & 0xFF) << 24 |  # 3rd byte to 1st position
            ((final_combined >> 24) & 0xFF) << 16 |  # 4th byte to 2nd position
            (final_combined & 0xFF) << 8 |  # 1st byte to 3rd position
            ((final_combined >> 8) & 0xFF)  # 2nd byte to 4th position
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
