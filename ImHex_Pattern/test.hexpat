import std.mem;

#define SEARCH_VALUE "ammo/pistol/standard"

struct PatternSearcher {
	if (std::mem::read_string($, 20) == SEARCH_VALUE) {
            // If value has been found here, place a u32 at that address
            padding[20];
            be u32 value;
            if (std::mem::read_unsigned($, 4) == 0xFFFFFFFF) {
            padding[4];
            be u32 value2;
            }
        }
	else {
            // If not, increment the current offset by one byte and discard that array entry
	    padding[1];
	    continue;
	}
};

// Create an array at offset 0x00 that extends all the way to the end of the file
PatternSearcher patterns[while(!std::mem::eof())] @ 0x00;