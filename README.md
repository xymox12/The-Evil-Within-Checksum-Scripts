# The Evil Within Saved Game File Checksum Algorithm

Note: Still in development. (Limited) testing with EPIC Store PC Version of TEW1:don't expect this to work with non-PC versions of the game. Always backup your saves before editing or replacing the checksum. Data loss is always a possibility if you do not choose to backup your saves prior to running the scripts or editing the file using ImHex.

History: I wanted to practice the levels I found challenging by using the chapter choice in NG+ before I ran a Akumu + no-upgrades run. However, I needed a way to remove all the upgrades I had from the previous game. Hence this.

## Checksum Calculation Scripts

The python versions are the original scripts:

1. savegame-chksm-tew1.py
2. savegame-chksm-tew1-simplified+commented.py

The 2nd script is a simplified version with better commenting

The PowerShell script was just out of interest to see how well ChatGPT could convert the python script. It seems to have accomplished this, but after a lot of backwards and forwards. Useful if you don't have Python available. This script is not as tested as the Python scripts.

- All scripts assume the file is within a local folder .\savefiles 
- The scripts create a new file with '_modified' appended to the filename. This has the new checksum. Copy that file into the original savegame folder and rename to replace the original. 

# ImHex Editor

You can use the ImHex Hex Editor with the provided Pattern file to edit appropriate areas in the inventory.zwei file. After saving the file, run the checksum script to replace the checksum etc.

![Example of the Pattern Editor](imhex-pattern-editor.png)

Again, this script is very much a work in progress.

### ImHex Editor

- https://github.com/WerWolv/ImHex


