//
//  TZNavigationController.m
//  Nav动画方案一
//
//  Created by Demon_Yao on 15/6/22.
//  Copyright (c) 2015年 WorfMan. All rights reserved.
//

#import "TZNavigationController.h"
#import "NavigationInteractiveTransition.h"
#import <objc/runtime.h>

@interface TZNavigationController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NavigationInteractiveTransition *navInteractiveTransition;

@end

@implementation TZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];

#if USE_方案二
    /*
    NSLog(@"==================== gesture\n%@",gesture);
    
    NSLog(@"==================== 利用runtime遍历所有成员\n");
    unsigned int count = 0;
    Ivar *var = class_copyIvarList([UIGestureRecognizer class], &count);
    for (int i=0; i<count; i++) {
        Ivar _var = * (var + i);
        NSLog(@"typeEncodeing = %s ---- name = %s",ivar_getTypeEncoding(_var),ivar_getName(_var));
    }
    */
    /**
     *  获取系统手势的target数组
     */
//    NSLog(@"==================== 获取targets\n");
    NSMutableArray *targets = [gesture valueForKey:@"_targets"];
//    NSLog(@"===== targets\n%@",targets);
    /**
     *  获取它的唯一对象，我们知道它是一个叫UIGestureRecognizerTarget的私有类，它有一个属性叫_target
     */
    id gestureRecognizerTarget = targets[0];
    /**
     *  获取_target:_UINavigationInteractiveTransition，它有一个方法叫handleNavigationTransition:
     */
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    /**
     *  通过前面的打印，我们从控制台获取出来它的方法签名。
     */
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    /**
     *  创建一个与系统一模一样的手势，我们只把它的类改为UIPanGestureRecognizer
     */
    [popRecognizer addTarget:navigationInteractiveTransition action:handleTransition];
#else
    self.navInteractiveTransition = [[NavigationInteractiveTransition alloc] initWithViewController:self];
    [popRecognizer addTarget:_navInteractiveTransition action:@selector(handleControllerPop:)];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    /**
     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
     */
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}


@end
