//
//  MemoryItemTableViewCell.h
//  忆本
//
//  Created by hzl on 16/8/22.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoryItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
