//
//  NSString+MessageDigest.h
//  ProductShow
//
//  Created by s on 15/10/13.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MessageDigest)

- (NSString *)md2;

- (NSString *)md4;

- (NSString *)md5;

- (NSString *)sha1;

- (NSString *)sha224;

- (NSString *)sha256;

- (NSString *)sha384;

- (NSString *)sha512;

@end
