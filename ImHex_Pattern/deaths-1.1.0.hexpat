#pragma once

import std.mem;
import std.string;

#define SEARCH_VALUE "weapon"

// Define the length of the pattern
const u8 pattern_length = std::string::length(SEARCH_VALUE);

struct PatternSearcher {
	if (std::mem::read_string($, 6) == SEARCH_VALUE) {
            // If value has been found here, place a u32 at that address
                $ -= 0x04;
                le u32 strlen [[hidden]];
                char Upgrade[strlen] [[hidden]];
                padding[4] [[hidden]];
                if (std::mem::read_string($, 6) == SEARCH_VALUE) {
                    $ -= 0x04;
                    le u32 strlen2 [[hidden]];
                    char Current_Weapon[strlen2];
                    padding[104];
                    be u32 Deaths;
                } else {
                    continue;
                    }
                } else {
                    u8 next_char = std::mem::read_unsigned($ + pattern_length, 1);
                    //str next_str =  std::mem::read_string($ + pattern_length, 1);   
                     // If the next character is not part of the pattern, skip the entire pattern length
                    //if (std::string::contains(SEARCH_VALUE,next_str)) {
                    if (next_char != 'w' && next_char != 'e' && next_char != 'a' && next_char != 'p' && next_char != 'o' && next_char != 'n') {
                    
                     try {
                         padding[pattern_length+1];  // Skip over the pattern length plus one character
                         continue;
                       } catch {
                         padding[1];
                         continue;
                       }
                     } else {                
                         padding[1];
                         continue;
                      }
                    
                  }  
}[[inline]];

// Create an array at offset 0x00 that extends all the way to the end of the file
PatternSearcher Stats[while(!std::mem::eof())] @ 0x1E8;