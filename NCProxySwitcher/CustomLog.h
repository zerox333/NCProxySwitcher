//
//  CustomLog.h
//  NCProxySwitcher
//
//  Created by ding_yuanyi on 12-11-28.
//
//

#define NSLog(...) CustomLogger(__VA_ARGS__);

void CustomLogger(NSString *format, ...);
