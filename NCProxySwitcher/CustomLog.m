//
//  CustomLog.m
//  NCProxySwitcher
//
//  Created by ding_yuanyi on 12-11-28.
//
//

void CustomLogger(NSString *format, ...) {
    va_list argumentList;
    va_start(argumentList, format);
    NSMutableString * message = [[NSMutableString alloc] initWithFormat:format
                                                              arguments:argumentList];
    
    [message insertString:@"||--NCProxySwitcher--|| : " atIndex:0];
    NSLogv(message, argumentList);
    
    va_end(argumentList);
    [message release];
}
