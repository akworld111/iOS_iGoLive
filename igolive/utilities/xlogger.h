//
//  xlogger.h
//  Zuma
//
//  Created by Eric Greenhouse on 4/01/15.
//  Copyright (c) 2015 Zuma Venture LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
     NOTE: the [, ...] and [## __VA_ARGS__] is what allows you to
      insert parameter string formats when invoking the logger
 
        eg. XLog(@"count: %u", 37);
 */

// Xtensive Logger
#ifdef DEBUG
// NOTE: __PRETTY_FUNCTION, __FUNCTION__, & __func__ all seem to work the same
#define XLog(message, ...) NSLog((@"%s:(%d) " message), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#else
#define XLog(x...)
#endif

// Xtensive Logger
#define XL_enter() XLog(@"<ENTER>")
#define XL_exit() XLog(@"<EXIT>")

// Xtensive Logger Message
#define XLM_enter(ENTER, ...) XLog(@"<ENTER>: " ENTER, ## __VA_ARGS__)
#define XLM_exit(EXIT, ...) XLog(@"<EXIT>: " EXIT, ## __VA_ARGS__)
#define XLM_info(INFO, ...) XLog(@"INFO: " INFO, ## __VA_ARGS__)
#define XLM_warning(WARNING, ...) XLog(@"\n\n  **WARNING*:\n    " WARNING, ## __VA_ARGS__)
#define XLM_alert(ALERT, ...) XLog(@"\n\n\n  **ALERT**:\n    " ALERT, ## __VA_ARGS__)
#define XLM_error(ERROR, ...) XLog(@"\n\n\n  **ERROR******:\n    " ERROR, ## __VA_ARGS__)
#define XLM_dominate(DOMINATE, ...) XLog(@"\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************\n**********************************DOMINATE******:\n    " DOMINATE, ## __VA_ARGS__)


// Xtensive Logger Next Step
#define XLNS_enter(ENTER, ...) NSLog(@"<ENTER>: " ENTER, ## __VA_ARGS__)
#define XLNS_exit(EXIT, ...) NSLog(@"<EXIT>: " EXIT, ## __VA_ARGS__)
#define XLNS_info(INFO, ...) NSLog(@"INFO: " INFO, ## __VA_ARGS__)
#define XLNS_warning(WARNING, ...) NSLog(@"\n  WARNING:    " WARNING, ## __VA_ARGS__)
#define XLNS_error(ERROR, ...) NSLog(@"\n  **ERROR******:\n    " ERROR, ## __VA_ARGS__)
#define XLNS_alert(ALERT, ...) NSLog(@"\n  **ALERT**:\n    " ALERT, ## __VA_ARGS__)

