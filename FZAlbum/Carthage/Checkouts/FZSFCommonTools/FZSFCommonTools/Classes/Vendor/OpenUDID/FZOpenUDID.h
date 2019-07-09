//
//  FZOpenUDID.h
//  FZOpenUDID
//
//  initiated by Yann Lechelle (cofounder @Appsfire) on 8/28/11.
//  Copyright 2011 FZOpenUDID.org
//
//  Main branches
//      iOS code: https://github.com/ylechelle/FZOpenUDID
//

/*
    !!! IMPORTANT !!!

    IF YOU ARE GOING TO INTEGRATE FZOpenUDID INSIDE A (STATIC) LIBRARY,
    PLEASE MAKE SURE YOU REFACTOR THE FZOpenUDID CLASS WITH A PREFIX OF YOUR OWN,
    E.G. ACME_FZOpenUDID. THIS WILL AVOID CONFUSION BY DEVELOPERS WHO ARE ALSO
    USING FZOpenUDID IN THEIR OWN CODE.

    !!! IMPORTANT !!!

*/

/*
 http://en.wikipedia.org/wiki/Zlib_License
 
 This software is provided 'as-is', without any express or implied
 warranty. In no event will the authors be held liable for any damages
 arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not
 claim that you wrote the original software. If you use this software
 in a product, an acknowledgment in the product documentation would be
 appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be
 misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source
 distribution.
*/

#import <Foundation/Foundation.h>

//
// Usage:
//    #include "FZOpenUDID.h"
//    NSString* FZOpenUDID = [FZOpenUDID value];
//

#define kFZOpenUDIDErrorNone          0
#define kFZOpenUDIDErrorOptedOut      1
#define kFZOpenUDIDErrorCompromised   2

@interface FZOpenUDID : NSObject {
}
+ (NSString*) value;
+ (NSString*) valueWithError:(NSError**)error;
+ (void) setOptOut:(BOOL)optOutValue;

@end
