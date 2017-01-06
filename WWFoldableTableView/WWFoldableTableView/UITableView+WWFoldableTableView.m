//
//  UITableView+WWFoldableTableView.m
//  WWFoldableTableView
//
//  https://github.com/Tidusww/WWFoldableTableView
//  Created by Tidus on 17/1/6.
//  Copyright © 2017年 Tidus. All rights reserved.
//

#import "UITableView+WWFoldableTableView.h"
#import <objc/runtime.h>

@implementation UITableView (WWFoldableTableView)
#pragma mark - init
+ (void)load
{
    [self ww_swizzInstanceMethod:@selector(_numberOfSections) withMethod:@selector(ww__numberOfSections)];
    [self ww_swizzInstanceMethod:@selector(_numberOfRowsInSection:) withMethod:@selector(ww__numberOfRowsInSection:)];
}

- (NSInteger)ww__numberOfSections
{
    NSInteger count = [self ww__numberOfSections];
    
    if(self.ww_foldable && !self.ww_foldState){
        //如果是可折叠列表，在获取section的数量后 初始化 ww_foldState
        NSMutableSet *foldState = [NSMutableSet set];
        if(self.ww_foldAtFirst){
            NSInteger index = 0;
            while (index<count) {
                [foldState addObject:@(index++)];
            }
        }
        self.ww_foldState = foldState;
    }
    
    return count;
}

- (NSInteger)ww__numberOfRowsInSection:(NSInteger)section
{
    if(!self.ww_foldState || !self.ww_foldState){
        return [self ww__numberOfRowsInSection:section];
    }
    
    //根据折叠状态返回行数
    BOOL isFolded = [self ww_isSectionFolded:section];
    return isFolded ? 0 : [self ww__numberOfRowsInSection:section];
}

#pragma mark - getter/setter
static const char WWFoldableKey = '\0';
- (BOOL)ww_foldable
{
    return [objc_getAssociatedObject(self, &WWFoldableKey) boolValue];
}

- (void)setWw_foldable:(BOOL)ww_foldable
{
    [self willChangeValueForKey:@"ww_foldable"];
    objc_setAssociatedObject(self, &WWFoldableKey, @(ww_foldable), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"ww_foldable"];
    //clean up
    if(!ww_foldable){
        [self setWw_foldAtFirst:NO];
        [self setWw_foldState:nil];
    }
}

#pragma mark - getter/setter
static const char WWFoldAtFirstKey = '\0';
- (BOOL)ww_foldAtFirst
{
    return [objc_getAssociatedObject(self, &WWFoldAtFirstKey) boolValue];
}

- (void)setWw_foldAtFirst:(BOOL)ww_foldAtFirst
{
    [self willChangeValueForKey:@"ww_foldAtFirst"];
    objc_setAssociatedObject(self, &WWFoldAtFirstKey, @(ww_foldAtFirst), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"ww_foldAtFirst"];
}


static const char WWFoldStateKey = '\0';
- (NSMutableSet *)ww_foldState
{
    return objc_getAssociatedObject(self, &WWFoldStateKey);
}

- (void)setWw_foldState:(NSMutableSet *)ww_foldState
{
    if(self.ww_foldable && ww_foldState != self.ww_foldState){
        [self willChangeValueForKey:@"ww_foldState"];
        objc_setAssociatedObject(self, &WWFoldStateKey, ww_foldState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"ww_foldState"];
    }
}

#pragma mark - methods
- (BOOL)ww_isSectionFolded:(NSInteger)section
{
    if(!self.ww_foldable || !self.ww_foldState){
        return NO;
    }
    return [self.ww_foldState containsObject:@(section)];
}

- (void)ww_foldSection:(NSInteger)section fold:(BOOL)fold
{
    if(!self.ww_foldable || !self.ww_foldState){
        return;
    }
    
    NSMutableSet *state = self.ww_foldState;
    if(fold){
        [state addObject:@(section)];
    }else{
        [state removeObject:@(section)];
    }
    self.ww_foldState = state;
    
    @try {
        //防止为止
        [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        [self reloadData];
    }
}
@end

@implementation NSObject (WWExtension)
+ (void)ww_swizzInstanceMethod:(SEL)methodOrig withMethod:(SEL)methodNew
{
    Method orig = class_getInstanceMethod(self, methodOrig);
    Method new = class_getInstanceMethod(self, methodNew);
    if(orig && new){
        method_exchangeImplementations(orig, new);
    }else{
        NSLog(@"swizz method failed");
    }
}

+ (void)ww_swizzClassMethod:(SEL)methodOrig withMethod:(SEL)methodNew
{
    Method orig = class_getClassMethod(self, methodOrig);
    Method new = class_getClassMethod(self, methodNew);
    if(orig && new){
        method_exchangeImplementations(orig, new);
    }else{
        NSLog(@"swizz method failed");
    }
}

@end
