//
//  MemoryItemTableViewCell.m
//  忆本
//
//  Created by hzl on 16/8/22.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import "MemoryItemTableViewCell.h"

@interface MemoryItemTableViewCell ()

@end

@implementation MemoryItemTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

@end
