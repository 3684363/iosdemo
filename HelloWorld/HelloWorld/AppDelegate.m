//
//  AppDelegate.m
//  HelloWorld
//
//  Created by  huwenqiang on 2024/3/3.
//

#import "AppDelegate.h"	
#import "ViewController.h"
#import "PictureViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window= [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    //ViewController@"新闻"
    ViewController *newsViewController=[[ViewController alloc] init];
    UINavigationController *navigationController1=[[UINavigationController alloc] initWithRootViewController:viewController1];
    navigationController1.view.backgroundColor=[UIColor whiteColor];
    navigationController1.tabBarItem.title=@"新闻";
    
    //PictureViewController@"图片"
    PictureViewController *pictureViewController=[[PictureViewController alloc] init];
    UINavigationController *navigationController2=[[UINavigationController alloc] initWithRootViewController:viewController2];
    navigationController2.tabBarItem.title=@"图片";
    
    //UIViewController@"我的"
    UIViewController *profileViewController=[[UIViewController alloc] init];
    controller3.view.backgroundColor=[UIColor yellowColor];
    controller3.tabBarItem.title=@"我的";
    
    //UITabBarController
    UITabBarController *tabBarController=[[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[navigationController1,navigationController2,controller3]];
    
    self.window.rootViewController=tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
