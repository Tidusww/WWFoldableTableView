//
//  UITableView+WWFoldableTableView.h
//  WWFoldableTableView
//
//  https://github.com/Tidusww/WWFoldableTableView
//  Created by Tidus on 17/1/6.
//  Copyright © 2017年 Tidus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (WWFoldableTableView)


/**
 *  设为YES，让tableView具备折叠功能
 */
@property (assign, nonatomic) BOOL ww_foldable;
/**
 *  设为YES，让tableView初次加载时折叠所有section
 */
@property (assign, nonatomic) BOOL ww_foldAtFirst;

/**
 *  返回某个section的折叠状态。YES - 折叠中
 */
- (BOOL)ww_isSectionFolded:(NSInteger)section;
/**
 *  设置指定section的折叠状态。
 */
- (void)ww_foldSection:(NSInteger)section fold:(BOOL)fold;

@end


@interface NSObject (WWExtension)

+ (void)ww_swizzInstanceMethod:(SEL)methodOrig withMethod:(SEL)methodNew;
+ (void)ww_swizzClassMethod:(SEL)methodOrig withMethod:(SEL)methodNew;

@end
