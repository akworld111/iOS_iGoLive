//
//  HelperMacroDefines.h
//  igolive
//
//  Created by greenhouse on 8/25/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#ifndef HelperMacroDefines_h
#define HelperMacroDefines_h

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))


/*
 NSStringFromCGPoint
 NSStringFromCGSize
 NSStringFromCGRect
 NSStringFromCGAffineTransform
 NSStringFromUIEdgeInsets
 An example:
 
 NSLog(@"rect1: %@", NSStringFromCGRect(rect1));
 */
#define CGRectString(rect) NSStringFromCGRect(rect)

/*
 Acquired from: http://twobitlabs.com/2011/03/some-great-uicolor-resources/
 ex: [view setBackgroundColor:NSColorFromHex(0x6758c8)];
 */
#define NSColorFromHex(hexValue) [NSColor colorWithSRGBRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]


/* e.g. */
#define NSColorFromHexAlpha(hexValue, alpha) [NSColor colorWithSRGBRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alpha]
#define UIColorFromHexAlpha(hexValue, alphaval) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaval]
#define UIColorFromRGB(r, g, b, alphaval) [UIColor colorWithRed:r green:g blue:b alpha:alphaval]
/* _e.g. */

//////////////////////////////////////////////////////
#pragma mark - regular expressions
//////////////////////////////////////////////////////
/*
 Explenation:
 ^  = start string, then match
 [-_A-Za-z\\d]+  = one or more combinations of -, _, letters (either uppercase or lowercase), or numbers
 (\\.[-_A-Za-z\\d]+)*  = then zero or more combinations of (one . followed by one or more combinations of -, _, letters (either uppercase or lowercase), or numbers)
 @  = then one @ sign
 [A-Za-z\\d]+  = then one or more combinations of letters (either uppercase or lowercase), or numbers
 (-*[A-Za-z\\d]+)*  = then zero or more combinations of (zero or more - (ie. dashes) followed by one or more combinations of letters (either uppercase or lowercase), or numbers)
 \\.  = then one .
 [A-Za-z]{2}  = then exactly two combinations of letters (either uppercase or lowercase)
 [A-Za-z\\d]*  = then zero or more combinations of letters (either uppercase or lowercase), or numbers
 (\\.[A-Za-z\\d]+)*  = then zero or more combinations of (one . followed by one more more combinations of letters (either uppercase or lowercase), or numbers)
 $  = then end string
 */
#define regex_symc_email @"^[-_A-Za-z\\d]+(\\.[-_A-Za-z\\d]+)*@[A-Za-z\\d]+(-*[A-Za-z\\d]+)*\\.[A-Za-z]{2}[A-Za-z\\d]*(\\.[A-Za-z\\d]+)*$"

/*
 Explenation:
 ^  = start string, then match
 [-_A-Za-z\\d]+  = one or more combinations of -, _, letters (either uppercase or lowercase), or numbers
 (\\.[-_A-Za-z\\d]+)*  = then zero or more combinations of (one . followed by one or more combinations of -, _, letters (either uppercase or lowercase), or numbers)
 @  = then one @ sign
 [A-Za-z\\d]+  = then one or more combinations of letters (either uppercase or lowercase), or numbers
 \\.  = then one .
 [A-Za-z]{2}  = then exactly two combinations of letters (either uppercase or lowercase)
 [A-Za-z\\d]*  = then zero or more combinations of letters (either uppercase or lowercase), or numbers
 (\\.[A-Za-z\\d]+)*  = then zero or more combinations of (one . followed by one or more combinations of letters (either uppercase or lowercase), or numbers)
 $  = then end string
 */
#define regex_wizr_email @"^[-_A-Za-z\\d]+(\\.[-_A-Za-z\\d]+)*@[A-Za-z\\d]+\\.[A-Za-z]{2}[A-Za-z\\d]*(\\.[A-Za-z\\d]+)*$";

/*
 Explenation:
 ^  = start string, then match
 [-_A-Za-z\\d]{2,}  = two or more combinations of -, _, letters (either uppercase or lowercase), or numbers
 (\\.[-_A-Za-z\\d]+)*  = then zero or more combinations of (one . followed by one or more combinations of -, _, letters (either uppercase or lowercase), or numbers)
 @  = then one @ sign
 [-_A-Za-z\\d]{2,}  = then two or more combinations of letters (either uppercase or lowercase), or numbers
 \\.  = then one .
 [A-Za-z]{2}  = then exactly two combinations of letters (either uppercase or lowercase)
 [A-Za-z\\d]*  = then zero or more combinations of letters (either uppercase or lowercase), or numbers
 (\\.[A-Za-z\\d]+)*  = then zero or more combinations of (one . followed by one or more combinations of letters (either uppercase or lowercase), or numbers)
 $  = then end string
 */
#define regex_copark_email @"^[-_A-Za-z\\d]{2,}(\\.[-_A-Za-z\\d]+)*@[-_A-Za-z\\d]{2,}\\.[A-Za-z]{2}[A-Za-z\\d]*(\\.[A-Za-z\\d]+)*$";


#endif /* HelperMacroDefines_h */
