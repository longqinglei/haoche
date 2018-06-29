//
//  MyTabBarController.m
//  HCBuyer
//
//  Created by 张熙 on 15/8/24.
//  Copyright (c) 2015年 张熙. All rights reserved.
//

#import "HCMyTabBarController.h"
#import "UIImage+RTTint.h"
@interface HCMyTabBarController ()

@end

@implementation HCMyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(240, 240, 240);
}

- (void)createViewControllers {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"MyTabController" ofType:@"plist"];
    NSArray *myArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *controllers = [NSMutableArray array];
    
    for (NSDictionary *dic in myArray) {
        NSString *className = [dic objectForKey:@"className"];
        
        Class class = NSClassFromString(className);
        
        HCBaseViewController  *root = [[class alloc] init];
        
        
        NSString *imageName = [dic objectForKey:@"iconName"];
        //iOS7中
        if ([root.tabBarItem respondsToSelector:@selector(initWithTitle:image:selectedImage:)]) {
            //iOS7
            UIImage *image = [UIImage imageNamed:imageName];
            image = [image rt_tintedImageWithColor:[UIColor blackColor]];
            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[dic objectForKey:@"titleName"] image:image tag:100];
            root.tabBarItem = item;
            [root.tabBarItem setSelectedImage:[UIImage imageNamed:[dic objectForKey:@"iconselect"]]];
        }else{
            //iOS7以前
            [root.tabBarItem setImage:[UIImage imageNamed:imageName]];
        }
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:root];
        
        [controllers addObject:navController];
    }
    self.tabBarController.tabBar.translucent = NO;
    self.tabBar.tintColor = PRICE_STY_CORLOR;
    self.viewControllers = controllers;
    // NSLog(@"count=%ld",self.viewControllers.count);
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[Tools createImageWithColor:[UIColor whiteColor]]];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    //se Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
