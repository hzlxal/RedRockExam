//
//  MemoryItemStore.h
//  忆本
//
//  Created by hzl on 16/8/22.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MemoryItem;

@interface MemoryItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (MemoryItem *)createItem;
- (void)removeItem:(MemoryItem *)item;

- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex;

- (BOOL)saveChanges;

@end
