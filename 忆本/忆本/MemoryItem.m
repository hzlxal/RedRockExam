//
//  MemoryItem.m
//  忆本
//
//  Created by hzl on 16/8/22.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import "MemoryItem.h"


@interface MemoryItem ()

@property (nonatomic, strong) NSDate *dateCreated;

@end

@implementation MemoryItem

- (id)initWithTitle:(NSString *)title date:(NSString *)date weather:(NSString *)weather introduece:(NSString *)introduce diaryName:(NSString *)diaryName

{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.weather = weather;
        self.date = date;
        self.introduce = introduce;
        self.diaryName = diaryName;
        
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    
    return self;
}

- (id)init {
    return [self initWithTitle:@"" date:@"" weather:@"" introduece:@"" diaryName:@""];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _date = [aDecoder decodeObjectForKey:@"date"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        _introduce = [aDecoder decodeObjectForKey:@"introduce"];
        _diaryName = [aDecoder decodeObjectForKey:@"diaryName"];
        
        _weather = [aDecoder decodeObjectForKey:@"weather"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [aCoder encodeObject:self.introduce forKey:@"introduce"];
    
    [aCoder encodeObject:self.weather forKey:@"weather"];
    [aCoder encodeObject:self.diaryName forKey:@"diaryName"];
}

- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    CGRect newRect = CGRectMake(0, 0, 60, 60);
    
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    UIGraphicsEndImageContext();
}

@end
