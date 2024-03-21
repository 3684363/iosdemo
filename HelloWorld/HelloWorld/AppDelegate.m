//
//  AppDelegate.m
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/3.
//

#import "AppDelegate.h"	
#import "ViewController.h"
#import "PictureViewController.h"
#import "VideoViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window= [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    //ViewController@"新闻"
    ViewController *viewController1=[[ViewController alloc] init];
    UINavigationController *navigationController1=[[UINavigationController alloc] initWithRootViewController:viewController1];
    navigationController1.view.backgroundColor=[UIColor whiteColor];
    navigationController1.tabBarItem.title = @"新闻";
    
    //PictureViewController@"图片"
    PictureViewController *viewController2=[[PictureViewController alloc] init];
    UINavigationController *navigationController2=[[UINavigationController alloc] initWithRootViewController:viewController2];
    navigationController2.tabBarItem.title = @"图片";
    
    //VideoViewController@"我的"
    VideoViewController *viewController3=[[VideoViewController alloc] init];
    UINavigationController *navigationController3=[[UINavigationController alloc] initWithRootViewController:viewController3];
    navigationController3.tabBarItem.title = @"视频";
    
    //UITabBarController
    UITabBarController *tabBarController=[[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[navigationController1,navigationController2,navigationController3]];
    
    
    self.window.rootViewController=tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
