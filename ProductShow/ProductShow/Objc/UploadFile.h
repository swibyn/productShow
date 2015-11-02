//
//  UploadFile.h
//  ProductShow
//
//  Created by s on 15/10/20.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadFile : NSObject
- (void)uploadFileWithURL:(NSURL * _Nonnull)url data:(NSData * _Nonnull)data
        completionHandler:(void (^ __nullable)(NSURLResponse* __nullable response, NSData* __nullable data, NSError* __nullable connectionError)) handler;
@end
