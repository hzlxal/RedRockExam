//
//  MemoryDetaileViewController.h
//  忆本
//
//  Created by hzl on 16/8/22.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemoryItem;

@interface MemoryDetaileViewController : UIViewController

@property (nonatomic, strong) MemoryItem  *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype)initForNewItem:(BOOL)isNew;

@end
