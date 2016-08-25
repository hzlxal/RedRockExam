//
//  MemoryReminderViewController.m
//  忆本
//
//  Created by hzl on 16/8/23.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import "MemoryReminderViewController.h"

@interface MemoryReminderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *toDoField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *ReminderBtn;

@end

@implementation MemoryReminderViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
}

- (IBAction)addReminder:(id)sender
{
    NSDate *date = self.datePicker.date;
    
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = self.toDoField.text;
    note.fireDate = date;
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提醒" message:@"是否设置提醒？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] scheduleLocalNotification:note];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       [self dismissViewControllerAnimated:YES completion:NULL];
    }]];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
