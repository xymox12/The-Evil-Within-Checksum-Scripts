#pragma author YourName
#pragma description Weapon Upgrades Binary File
#pragma history
#pragma 0.1 2024-08-08 Initial support
#pragma debug

import std.mem;
import std.string;
import std.array;
import std.io;

struct Ammo_Stock {
    $ -= 0x04;
    le u32 strlen [[hidden]];
    char Ammo[strlen] [[hidden]];
    be u32 Available;
    padding[4];
    be u32 Capacity;
};

struct Ammo { 
    $ -= 0x04;
    le u32 strlen [[hidden]];
    char Ammo[strlen] [[hidden]];
    be u32 Loaded;
    try {
          Ammo_Stock Stock @ std::mem::find_string(1, Ammo);
     }
};



struct Weapon_Ammo {

    Ammo Handgun_Ammo @ std::mem::find_string(0,"ammo/pistol/standard");
    Ammo Matches @ std::mem::find_string(0,"zwei/player/matchstick");

};


Weapon_Ammo Weapon_Ammo @ 0x00;  




// Death count: final 'weapon/' string + weapon-name + padding[104] + deathcount word value