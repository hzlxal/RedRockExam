//
//  MemoryImageStore.m
//  忆本
//
//  Created by hzl on 16/8/22.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import "MemoryImageStore.h"

@interface MemoryImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

- (NSString *)imagePathForKey:(NSString *)key;

@end

@implementation MemoryImageStore

+ (instancetype)sharedStore
{
    static MemoryImageStore *sharedStore;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[MemoryImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    
    return self;
}

- (void)clearCache:(NSNotification *)note
{
    [self.dictionary removeAllObjects];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    NSString *imagePath = [self imagePathForKey:key];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    UIImage *result = self.dictionary[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if (result) {
            self.dictionary[key] = result;
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath
                                               error:NULL];
}

@end
