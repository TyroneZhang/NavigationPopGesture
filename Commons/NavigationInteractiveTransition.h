//
//  NavigationInteractiveTransition.h
//  Nav动画方案一
//
//  Created by Demon_Yao on 15/6/22.
//  Copyright (c) 2015年 WorfMan. All rights reserved.
///Users/demon_yao/Desktop/练习app/Nav动画方案一/Controllers/TZNavigationController.h

#import <UIKit/UIKit.h>

@class UIViewController, UIPercentDrivenInteractiveTransition;

@interface NavigationInteractiveTransition : NSObject <UINavigationControllerDelegate>

- initWithViewController:(UIViewController *)viewController;

- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;

- (UIPercentDrivenInteractiveTransition *)interactivePopTransition;

@end
