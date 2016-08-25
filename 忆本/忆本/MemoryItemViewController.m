//
//  MemoryItemViewController.m
//  忆本
//
//  Created by hzl on 16/8/22.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import "MemoryItemViewController.h"
#import "MemoryDetaileViewController.h"
#import "MemoryItem.h"
#import "MemoryItemStore.h"
#import "MemoryImageStore.h"
#import "MemoryItemTableViewCell.h"


@interface MemoryItemViewController ()<UIPopoverControllerDelegate>

@end

@implementation MemoryItemViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        MemoryItem *item = [[MemoryItemStore sharedStore] createItem];
        
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = item.diaryName;
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                target:self
                                                action:@selector(addNewItem:)];
        bbi.tintColor = [UIColor lightGrayColor];
        navItem.rightBarButtonItem = bbi;
        

        self.editButtonItem.tintColor = [UIColor lightGrayColor];
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(updateTableViewForDynamicTypeSize)
                   name:UIContentSizeCategoryDidChangeNotification
                 object:nil];
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"MemoryItemTableViewCell" bundle:nil];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"MemoryItemTableViewCell"];
    
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:250/255.0 blue:200/255.0 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTableViewForDynamicTypeSize];
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{ UIContentSizeCategoryExtraSmall : @44,
                                  UIContentSizeCategorySmall : @44,
                                  UIContentSizeCategoryMedium : @44,
                                  UIContentSizeCategoryLarge : @44,
                                  UIContentSizeCategoryExtraLarge : @55,
                                  UIContentSizeCategoryExtraExtraLarge : @65,
                                  UIContentSizeCategoryExtraExtraExtraLarge : @75 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[MemoryItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MemoryItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemoryItemTableViewCell" forIndexPath:indexPath];
    
    NSArray *items = [[MemoryItemStore sharedStore] allItems];
    MemoryItem *item = items[indexPath.row];
    
    cell.titleLabel.text = item.title;
    cell.weatherLabel.text = item.weather;
    cell.dateLabel.text = item.date;
    cell.thumbnailView.image = item.thumbnail;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemoryDetaileViewController *detailViewController = [[MemoryDetaileViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[MemoryItemStore sharedStore] allItems];
    MemoryItem *selectedItem = items[indexPath.row];
    
    
    detailViewController.item = selectedItem;
    
    
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

- (void)   tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[MemoryItemStore sharedStore] allItems];
        MemoryItem *item = items[indexPath.row];
        [[MemoryItemStore sharedStore] removeItem:item];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)   tableView:(UITableView *)tableView
  moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
         toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[MemoryItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)addNewItem:(id)sender
{
    MemoryItem *newItem = [[MemoryItemStore sharedStore] createItem];
    
    MemoryDetaileViewController *detailViewController = [[MemoryDetaileViewController alloc] initForNewItem:YES];
    
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:NULL];
}


@end
