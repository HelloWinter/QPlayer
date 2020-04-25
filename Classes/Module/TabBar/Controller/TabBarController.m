//
//  TabBarController.m
//
//  Created by dyf on 2017/12/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "SettingsViewController.h"

@interface TabBarController ()

// The property determines whether The dark interface style was truned on.
@property (nonatomic, assign) BOOL isDarkMode;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self identifyMode];
}

- (void)setup {
    UIImage *htbItemImage = QPImageNamed(@"tabbar_item_home_00");
    UIImage *htbItemSelectedImage = self.originalImage(QPImageNamed(@"tabbar_item_home_01"));
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"本地资源"
                                                      image:htbItemImage
                                              selectedImage:htbItemSelectedImage];
    BaseNavigationController *hnc = [self tbc_navigationController:homeVC];
    
    UIImage *stbItemImage = QPImageNamed(@"tabbar_item_browser_00");
    UIImage *stbItemSelectedImage = self.originalImage(QPImageNamed(@"tabbar_item_browser_01"));
    
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"打开网址"
                                                        image:stbItemImage
                                                selectedImage:stbItemSelectedImage];
    BaseNavigationController *snc = [self tbc_navigationController:searchVC];
    
    UIImage *settbItemImage = QPImageNamed(@"tabbar_item_setting_00");
    UIImage *settbItemSelectedImage = self.originalImage(QPImageNamed(@"tabbar_item_setting_01"));
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    settingsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置"
                                                          image:settbItemImage
                                                  selectedImage:settbItemSelectedImage];
    BaseNavigationController *setnc = [self tbc_navigationController:settingsVC];
    
    self.viewControllers = @[hnc, snc, setnc];
    self.selectedIndex   = 0;
}

- (UIImage *(^)(UIImage *image))originalImage {
    
    UIImage *(^block)(UIImage *image) = ^UIImage *(UIImage *image) {
        UIImageRenderingMode imgRenderingMode = UIImageRenderingModeAlwaysOriginal;
        return [image imageWithRenderingMode:imgRenderingMode];
    };
    
    return block;
}

- (BaseNavigationController *)tbc_navigationController:(UIViewController *)viewController {
    return [[BaseNavigationController alloc] initWithRootViewController:viewController];
}

- (void)identifyMode {
    if (@available(iOS 13.0, *)) {
        
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        
        if (mode == UIUserInterfaceStyleDark) {
            // Dark Mode
            self.isDarkMode = YES;
        } else if (mode == UIUserInterfaceStyleLight) {
            // Light Mode or unspecified Mode
            self.isDarkMode = NO;
        }
        
    } else {
        
        self.isDarkMode = NO;
    }
    
    [self adjustTabBarThemeStyle];
}

- (void)adjustTabBarThemeStyle {
    
    UIColor *normalColor = self.isDarkMode ? QPColorFromRGB(200, 200, 200) : [UIColor grayColor];
    UIColor *selectedColor = self.isDarkMode ? QPColorFromRGB(39, 220, 203) : QPColorFromRGB(58, 60, 66);
    UIFont *font = [UIFont systemFontOfSize:12];
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    if (@available(iOS 13.0, *)) {
        
        self.tabBar.unselectedItemTintColor = normalColor;
        self.tabBar.tintColor = selectedColor;
        
        [tabBarItem setTitleTextAttributes:@{NSFontAttributeName : font} forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:@{NSFontAttributeName : font} forState:UIControlStateSelected];
        
    } else {
        
        [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : normalColor, NSFontAttributeName : font} forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : selectedColor, NSFontAttributeName : font} forState:UIControlStateSelected];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self identifyMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
