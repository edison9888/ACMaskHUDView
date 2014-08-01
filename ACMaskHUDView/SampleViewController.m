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
    [self.maskHUDView showActivityIndicatorHUDWithLabelText:@"数据加载中"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.maskHUDView showRefreshHUDWithLabelText:@"刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊刷新啊啊啊啊测试内容输入啊啊啊啊"];
        
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
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"测试"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(rightBarButtonClicked:)];
    
    
    //-- test
    UILabel *testShow = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 280, 50)];
    testShow.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    testShow.backgroundColor = [UIColor grayColor];
    testShow.text = @"加载完成前被遮挡的内容";
    testShow.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:testShow];
    
    
    
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

// support interface rotation
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.maskHUDView willChangeOrientation];
}

#pragma mark - ACMaskHUDViewDelegate

- (void)refreshButtondidTap
{
    [self.maskHUDView showNoticeHUDWithTitleText:@"没有网络测试显示字符串长度换行什么的"
                                   andDetailText:@"请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，请检查 wifi 3g 什么的，"];
    
    //[self.maskHUDView showNoticeHUDWithTitleText:nil andDetailText:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.maskHUDView hideNoticeHUDWithDuration:0.4 completion:nil];
        
    });
}

@end
