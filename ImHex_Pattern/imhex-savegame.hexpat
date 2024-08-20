#pragma author YourName
#pragma description Weapon Upgrades Binary File
#pragma history
#pragma   0.1  2024-08-08 Initial support

import std.mem;
import std.string;
import std.array;
import hex.http;
import std.io;


/// Entire stream minus checksum (4)
u64 data_len = std::mem::size() - 32;

struct Header {
    u32 Checksum ;
};

struct WeaponUpgrade {
    u8 Damage_Multiplier [[color("003f5c"),comment("Integer: 1 - 5")]];
    padding[3];
    u8 Fire_Rate [[color("374c80"),comment("Integer: 1 - 5")]];
    padding[3];
    u8 Reload_Time [[color("7a5195"),comment("Integer: 1 - 5")]];
    padding[7];
    u8 Clip_Capacity [[color("bc5090"),comment("Integer: 1 - 5")]];
    padding[3];
    u8 Accuracy [[color("ef5675"),comment("Integer: 1 - 5")]];
    padding[3];
    u8 Critical [[color("ff764a"),comment("Integer: 1 - 5")]];
    padding[3];
    u8 Stock [[color("ffa600"),comment("Integer: 1 - 5")]];
};

struct WeaponBlock {
    char Upgrade[while(std::mem::read_unsigned($, 1) != 0x00)][[hidden]];
    padding[4];         
    padding[16];
    padding[14];
    WeaponUpgrade Weapon_Upgrade; // The embedded weapon data
};

struct Stock {
    padding[15];
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


struct Bolt_Upgrade {
    padding[55];
    u8 Explosive;
    padding[3];
    u8 Shock;
    padding[3];
    u8 Freeze;
    padding[3];
    u8 Flash;
    padding[7];
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
WeaponBlock CrossBow @ std::mem::find_string(0,"weapon/upgrade/trapgun");
WeaponBlock Shotgun @ std::mem::find_string(0,"weapon/upgrade/shotgun");
WeaponBlock Rifle @ std::mem::find_string(0,"weapon/upgrade/rifle");
WeaponBlock Magnum @ std::mem::find_string(0,"weapon/upgrade/magnum");

Green_Gel Gel @ std::mem::find_string(0,"zwei/player/upgrade_item");
Trap_Parts Parts @ std::mem::find_string(0,"zwei/player/trap_parts");


Stock Stock @ std::mem::find_sequence(0, 0x00, 0x00, 0x06, 0x42, 0xC8, 0x00, 0x00, 0x42);

Bolt_Upgrade Bolt_Upgrades @ std::mem::find_sequence(0, 0x00, 0x00, 0x06, 0x42, 0xC8, 0x00, 0x00, 0x42);

//std::print("{0}", hex::http::get("api.hashify.net/hash/md5/hex?value=helloWorld"));