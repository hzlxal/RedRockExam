//
//  MemoryDetaileViewController.m
//  忆本
//
//  Created by hzl on 16/8/22.
//  Copyright © 2016年 hzl. All rights reserved.
//

#import "MemoryDetaileViewController.h"
#import "MemoryItem.h"
#import "MemoryImageStore.h"
#import "MemoryItemStore.h"

@interface MemoryDetaileViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,
UITextFieldDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *weatherField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UITextView *introduceTextView;

@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@end

@implementation MemoryDetaileViewController

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(save:)];
            doneItem.tintColor = [UIColor lightGrayColor];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
            cancelItem.tintColor = [UIColor lightGrayColor];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView.layer.cornerRadius = 12;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MemoryItem *item = self.item;
    self.titleField.text = item.title;
    self.dateField.text = item.date;
    self.weatherField.text = item.weather;
    self.introduceTextView.text = item.introduce;
    
    NSString *itemKey = self.item.itemKey;
    if (itemKey) {
        UIImage *imageToDisplay = [[MemoryImageStore sharedStore] imageForKey:itemKey];
        
        self.imageView.image = imageToDisplay;
    } else {
        self.imageView.image = nil;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    MemoryItem *item = self.item;
    item.title = self.titleField.text;
    item.date = self.dateField.text;
    item.weather = self.weatherField.text;
    item.introduce = self.introduceTextView.text;
}



- (void)setItem:(MemoryItem *)item
{
    _item = item;
    self.navigationItem.title = _item.title;
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    [[MemoryItemStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (IBAction)takePicture:(id)sender
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device ahs a camera, take a picture, otherwise,
    // just pick from the photo library
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.delegate = self;
    
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = self.item.itemKey;
    
    if (oldKey) {
        [[MemoryImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];
    
    [[MemoryImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
