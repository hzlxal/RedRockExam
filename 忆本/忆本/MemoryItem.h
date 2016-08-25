//
//  MemoryItem.h
//  忆本
//
//  Created by hzl on 16/8/22.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MemoryItem : NSObject

- (instancetype)initWithTitle:(NSString *)title
               date:(NSString *)date
                      weather:(NSString *)weather
                   introduece:(NSString *)introduce
                    diaryName:(NSString *)diaryName;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *weather;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *diaryName;

@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic, strong) UIImage *thumbnail;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
