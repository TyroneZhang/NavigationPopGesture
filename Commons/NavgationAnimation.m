//
//  NavgationAnimation.m
//  Nav动画方案一
//
//  Created by Demon_Yao on 15/6/22.
//  Copyright (c) 2015年 WorfMan. All rights reserved.
//

#import "NavgationAnimation.h"
#import <QuartzCore/QuartzCore.h>

@interface NavgationAnimation ()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation NavgationAnimation

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Animation duration
    return 0.25;
}

/**
 *  transitionContext你可以看作是一个工具，用来获取一系列动画执行相关的对象，并且通知系统动画是否完成等功能。
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 动画来自哪个控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // 专场到哪个动画
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // containerView作为“舞台”,执行两个控制器视图的转场动画
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    /*
     * 执行动画,让fromVC的视图移动到屏幕最右侧
     */

#if USE_方案一一
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    } completion:^(BOOL finished) {
        /**
         *  当你的动画执行完成，这个方法必须要调用，否则系统会认为你的其余任何操作都在动画执行过程中。
         */
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
    
#elif USE_方案一二
    _transitionContext = transitionContext;
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [UIView commitAnimations];
    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
#elif USE_方案一三
    _transitionContext = transitionContext;
    CATransition *transition = [CATransition animation];
    transition.type = @"cube";
    transition.subtype = @"fromLeft";
    transition.duration = duration;
    transition.removedOnCompletion = NO;
    transition.fillMode = kCAFillModeForwards;
    transition.delegate = self;
    [containerView.layer addAnimation:transition forKey:nil];
    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
#endif
}

- (void)animationDidStop:(CATransition *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}

@end
