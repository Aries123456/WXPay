//
//  AppDelegate.m
//  WXPay
//
//  Created by lk on 2019/5/13.
//  Copyright © 2019 lk. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <WXApi.h>
#import "WXApiManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     //向微信注册,发起支付必须注册
    [WXApi registerApp:@"wxb4ba3c02aa476ea1" enableMTA:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ViewController alloc]init];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    // 跳转到URL scheme中配置的地址
    NSLog(@"跳转到URL scheme中配置的地址-->%@",url);
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

//支付成功时调用，回到第三方应用中
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
     NSLog(@"****************url.host -- %@",url.host);
    if ([url.scheme isEqualToString:@"wx23a1f7f291ef4b3d"])
    {
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}


















- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
