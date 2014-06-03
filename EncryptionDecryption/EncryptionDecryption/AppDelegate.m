//
//  AppDelegate.m
//  EncryptionDecryption
//
//  Created by kaxiaoer on 14-6-3.
//  Copyright (c) 2014年 miaogaoliang. All rights reserved.
//

#import "AppDelegate.h"

#define KEY @"2014CHINA"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *source = @"ccrypt 是一个用于文件和数据流加密解密的命令行工具包，主要设计用于替换标准 Linux/Unit 的 crypt 工具（因为它使用的是非常弱的加密算法）。ccrypt 基于 Rijndael 加密方法，这是美国政府所使用的高级加密标准之一，提供非常强大的安全性保证，同时也提供了兼容 crypt 工具的兼容模式。";
    
    NSData *data = [source DESEncryptByKey:KEY];
    NSString *descoure = [data DESDecryptToStringByKey:KEY];
    
    if ([descoure isEqualToString:source]) {
        NSLog(@"SUccess",nil);//虽然结果是一样的，但是，却不是相等的;
    }
    
    NSData *dat1 = [source dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *start = [dat1 DESEncryptByKey:KEY];
    NSString *end = [start DESDecryptToStringByKey:KEY];
    NSLog(end,nil);
    
    /*以数组的形式，加密，解密，失败
    NSArray *array = @[@"123",@"china"];
    NSData *dataArray = [NSKeyedArchiver archivedDataWithRootObject:array];
    NSData *soureArray = [dataArray DESEncryptByKey:KEY];
    NSData *deDataArray = [soureArray DESDecryptByKey:KEY];
    NSArray *deArray = [NSKeyedUnarchiver unarchiveObjectWithData:deDataArray];
    NSLog([deArray description],nil);*/
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
