//
//  MemoryItemStore.m
//  忆本
//
//  Created by hzl on 16/8/22.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import "MemoryItemStore.h"
#import "MemoryItem.h"
#import "MemoryImageStore.h"

@interface MemoryItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation MemoryItemStore

+ (instancetype)sharedStore
{
    static MemoryItemStore *sharedStore;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[MemoryItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (MemoryItem *)createItem
{
    MemoryItem *item = [[MemoryItem alloc] init];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(MemoryItem *)item
{
    NSString *key = item.itemKey;
    if (key) {
        [[MemoryImageStore sharedStore] deleteImageForKey:key];
    }
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    MemoryItem *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    [self.privateItems insertObject:item atIndex:toIndex];
}

@end
