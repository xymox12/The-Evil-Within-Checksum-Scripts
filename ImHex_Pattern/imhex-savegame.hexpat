#pragma author YourName
#pragma description Weapon Upgrades Binary File
#pragma history
#pragma   0.1  2024-08-08 Initial support

import std.mem;
import std.string;
import std.array;
import std.io;


/// Entire stream minus checksum (4)
u64 data_len = std::mem::size() - 32;

// Define an enum for the upgrade level to enhance readability
enum UpgradeLevel : u32 {
    LEVEL_1 = 1,
    LEVEL_2 = 2,
    LEVEL_3 = 3,
    LEVEL_4 = 4,
    LEVEL_5 = 5
};

struct Header {
    u32 Checksum ;
};

struct WeaponUpgrade {
   be UpgradeLevel Damage_Multiplier;
   be UpgradeLevel Fire_Rate;
   be UpgradeLevel Reload_Time;
   be u32 UnKnown [[hidden]];
   be UpgradeLevel Clip_Capacity;
   be UpgradeLevel Accuracy;
   be UpgradeLevel Critical;
   be UpgradeLevel Stock;
};


struct CrossBowBlock {
    $ -= 0x04;
    le u32 strlen;
    char Upgrade[strlen];
    padding[46];         
    u8 Clip_Capacity;
    padding[19];
    u8 Critical;
    padding[3];
    u8 Stock;
};

struct WeaponBlock {
    $ -= 0x04;
    le u32 strlen;
    char Upgrade[strlen];
    padding[31];         
    WeaponUpgrade Weapon_Upgrade; // The embedded weapon data
};

struct Stock {
    padding[504];
    u8 Life_Gauge;
    padding[3];
    u8 Maximum_Sprint;
    padding[3];
    u8 Melee_Damage;
    padding[3];
    u8 Syringe_Recovery;
    padding[4];
    padding[4];
    padding[4];
    padding[3];
    u8 Granades;
    padding[3];
    u8 Syringes;
    padding[4];
    padding[3];
    u8 Matches; 
};


struct Bolt_Upgrades {
    padding[548];
    u8 Explosive;
    padding[3];
    u8 Shock;
    padding[3];
    u8 Freeze;
    padding[3];
    u8 Flash;
    padding[3];
    u8 Harpoon; 
};

struct Green_Gel {
    char Upgrade[while(std::mem::read_unsigned($, 1) != 0x00)][[hidden]];
    be u32 Gel [[color("50c878"),comment("Integer")]];
};

struct Trap_Parts {
    char Upgrade[while(std::mem::read_unsigned($, 1) != 0x00)][[hidden]];
    be u32 Parts [[color("50c878"),comment("Integer")]];
};



Header Header @ 0x00;

WeaponBlock Handgun @ std::mem::find_string(0,"weapon/upgrade/handgun");
CrossBowBlock CrossBow @ std::mem::find_string(0,"weapon/upgrade/trapgun");
WeaponBlock Shotgun @ std::mem::find_string(0,"weapon/upgrade/shotgun");
WeaponBlock Rifle @ std::mem::find_string(0,"weapon/upgrade/rifle");
WeaponBlock Magnum @ std::mem::find_string(0,"weapon/upgrade/magnum");

Green_Gel Gel @ std::mem::find_string(0,"zwei/player/upgrade_item");
Trap_Parts Parts @ std::mem::find_string(0,"zwei/player/trap_parts");

Stock Stock @ std::mem::find_sequence(0,0x67, 0x61, 0x6D, 0x65, 0x66, 0x6C, 0x61, 0x67, 0x2F, 0x64, 0x6C, 0x63, 0x33, 0x5F, 0x62, 0x6F, 0x78, 0x6D, 0x61, 0x6E, 0x5F, 0x73, 0x74, 0x6F, 0x72, 0x79);

Bolt_Upgrades Bolt_Upgrades @ std::mem::find_sequence(0,0x67, 0x61, 0x6D, 0x65, 0x66, 0x6C, 0x61, 0x67, 0x2F, 0x64, 0x6C, 0x63, 0x33, 0x5F, 0x62, 0x6F, 0x78, 0x6D, 0x61, 0x6E, 0x5F, 0x73, 0x74, 0x6F, 0x72, 0x79);