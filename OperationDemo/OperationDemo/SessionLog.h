//
//  SessionLog.h
//  OperationDemo
//
//  Created by zhangyi on 16/6/7.
//  Copyright © 2016年 money. All rights reserved.
//

#ifndef SessionLog_h
#define SessionLog_h

#import <dispatch/dispatch.h>
static dispatch_queue_t log_queue() {
    static dispatch_queue_t imageSession_log_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageSession_log_queue = dispatch_queue_create("com.imageSession.log", DISPATCH_QUEUE_SERIAL);
    });
    return imageSession_log_queue;
}

#ifndef SESSION_LOG

#define SESSION_LOG(...)        \
dispatch_async(log_queue(), ^{  \
NSLog(__VA_ARGS__);         \
})                              \

#endif

#endif /* SessionLog_h */
