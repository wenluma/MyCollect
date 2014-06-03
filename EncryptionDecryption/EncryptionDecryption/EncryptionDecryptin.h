//
//  EncryptionDecryptin.h
//  EncryptionDecryption
//
//  Created by kaxiaoer on 14-6-3.
//  Copyright (c) 2014年 miaogaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"

@interface EncryptionDecryptin : NSObject

@end
@interface NSData (DES)
- (NSData *)DESEncryptByKey:(NSString *)key;
- (NSData *)DESDecryptByKey:(NSString *)key;
- (NSString *)DESDecryptToStringByKey:(NSString *)key;
@end
@interface NSString (DES)
- (NSData *)DESEncryptByKey:(NSString *)key;
- (NSString *)DESEncryptToStringByKey:(NSString *)key;
- (NSString *)DESDecryptToStringByKey:(NSString *)key;
@end

