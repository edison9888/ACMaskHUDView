//
//  SampleViewController.m
//  ACMaskHUDView
//
//  Created by Albert Chu on 14/7/29.
//  Copyright (c) 2014年 AC. All rights reserved.
//

#import "SampleViewController.h"

#import "ACMaskHUDView.h"


@interface SampleViewController () <ACMaskHUDViewDelegate>

@property (nonatomic, strong) ACMaskHUDView *maskHUDView;

@end


@implementation SampleViewController

#pragma mark - Action func

- (void)rightBarButtonClicked:(UIButton *)sender
{
    [self.maskHUDView showActivityIndicatorHUDWithText:@"loading"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.maskHUDView showRefreshHUDWithText:@"Unexpected error \n Please try again"];
        
    });
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Sample";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(rightBarButtonClicked:)];
    
    
    //-- test
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 280, 50)];
    testLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    testLabel.backgroundColor = [UIColor grayColor];
    testLabel.text = @"Test Label";
    testLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:testLabel];
    
    
    
    //-- ACMaskHUDView
    self.maskHUDView = [[ACMaskHUDView alloc] initWithFrame:self.view.bounds];
    self.maskHUDView.delegate = self;
    
    [self.view addSubview:self.maskHUDView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return YES;
//}

#pragma mark - ACMaskHUDViewDelegate

- (void)refreshButtondidTap
{
    [self.maskHUDView showNoticeHUDWithTitleText:@"Cannot Connect \n to the Internet"
                                      detailText:@"You must connect to a Wi-Fi \n or cellular data network. \n Please check your network."];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        [self.maskHUDView hideHUDWithDuration:0.36f completion:^(BOOL finished) {
//            [self.maskHUDView showNoticeHUDWithTitleText:nil
//                                              detailText:nil];
//        }];
        
        [self.maskHUDView hideHUD];
        [self.maskHUDView showNoticeHUDWithTitleText:nil
                                          detailText:nil];
        
    });
}

@end
