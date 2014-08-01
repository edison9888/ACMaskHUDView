//
//  ACMaskHUDView.m
//  ACMaskHUDView
//
//  Created by Albert Chu on 14/7/29.
//  Copyright (c) 2014年 AC. All rights reserved.
//

#import "ACMaskHUDView.h"

#pragma mark - const
//-- const -------------------------------------------------------------------------------------------------------------
#define kACMaskHUDViewBackgroundColor                           [UIColor whiteColor]

#define kACMaskHUDViewTextColor                                 \
[UIColor colorWithRed: 153 / 255.f green: 153 / 255.f blue: 153 / 255.f alpha:1.f]

#define kACMaskHUDViewHideDuration                              0.2f

#define kACMaskHUDViewActivityIndicatorView_w_h                 32.0f
#define kACMaskHUDViewActivityIndicator_gap                     4.0f
#define kACMaskHUDViewActivityIndicatorLabel_h                  kACMaskHUDViewActivityIndicatorView_w_h
#define kACMaskHUDViewActivityIndicatorLabel_max_w              220.0f
#define kACMaskHUDViewActivityIndicatorLabel_font               [UIFont boldSystemFontOfSize:18.0f]


#define kACMaskHUDViewRefreshButtonText                         @"Refresh"
#define kACMaskHUDViewRefreshButtonTextActionColor              \
[UIColor colorWithRed:   0 / 255.f green: 122 / 255.f blue: 255 / 255.f alpha:1.f]
#define kACMaskHUDViewRefreshButtonTextHighlightedColor         \
[UIColor colorWithRed: 210 / 255.f green: 230 / 255.f blue: 255 / 255.f alpha:1.f]
#define kACMaskHUDViewRefreshLabel_font                         [UIFont boldSystemFontOfSize:22.0f]
#define kACMaskHUDViewRefreshButton_w                           180.0f
#define kACMaskHUDViewRefreshButton_h                           40.0f
#define kACMaskHUDViewRefresh_gap                               16.0f
#define kACMaskHUDViewRefreshLabel_max_w                        300.0f
#define kACMaskHUDViewRefreshLabel_max_h                        \
(210.f - kACMaskHUDViewRefreshButton_h - kACMaskHUDViewRefresh_gap)


#define kACMaskHUDViewNoticeTitleLabel_font                     [UIFont boldSystemFontOfSize:36.0f]
#define kACMaskHUDViewNoticeDetailLabel_font                    [UIFont boldSystemFontOfSize:22.0f]
#define kACMaskHUDViewNotice_max_w                              300.0f
#define kACMaskHUDViewNoticeTitleLabel_max_h                    90.0f
#define kACMaskHUDViewNotice_gap                                0.0f
#define kACMaskHUDViewNoticeDetailLabel_max_h                   120.0f
#define kACMaskHUDViewNoticeEmptyText                           @"!"

//--------------------------------------------------------------------------------------------------------------------//

@interface ACMaskHUDView ()

@property (nonatomic, strong) UIActivityIndicatorView           *activityIndicatorView;
@property (nonatomic, strong) UILabel                           *activityIndicatorLabel;
@property (nonatomic, strong) NSString                          *activityIndicatorLabelString;
@property (nonatomic, assign) BOOL                              isShowingActivityIndicatorHUD;

@property (nonatomic, strong) UILabel                           *refreshLabel;
@property (nonatomic, strong) NSString                          *refreshLabelString;
@property (nonatomic, strong) UIButton                          *refreshButton;
@property (nonatomic, assign) BOOL                              isShowingRefreshHUD;

@property (nonatomic, strong) UILabel                           *noticeTitleLabel;
@property (nonatomic, strong) NSString                          *noticeTitleLabelString;
@property (nonatomic, strong) UILabel                           *noticeDetailLabel;
@property (nonatomic, strong) NSString                          *noticeDetailLabelString;
@property (nonatomic, assign) BOOL                              isShowingNoticeHUD;

@end


@implementation ACMaskHUDView


#pragma mark - Hide whatever is showing

- (void)hideHUD
{
    [self hideHUDWithDuration:0.0f completion:nil];
}

- (void)hideHUDWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    if (self.isShowingActivityIndicatorHUD)
    {
        [self hideActivityIndicatorElement];
    }
    else if (self.isShowingRefreshHUD)
    {
        [self hideRefreshHUDElement];
    }
    else if (self.isShowingNoticeHUD)
    {
        [self hideNoticeHUDElement];
    }
    [self hideSelfWithDuration:duration completion:completion];
}

#pragma mark - Hide Self Animation

- (void)hideSelfWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    [self removeNotificationObserver];
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (completion) {
            completion(finished);
        }
    }];
}

#pragma mark - ActivityIndicatorHUD show func

- (void)showActivityIndicatorHUD
{
    [self showActivityIndicatorHUDWithText:nil];
}

- (void)showActivityIndicatorHUDWithText:(NSString *)string
{
    [self addNotificationObserver];
    
    // hide others first
    if (self.isShowingRefreshHUD)
    {
        [self hideRefreshHUDElement];
    }
    else if (self.isShowingNoticeHUD)
    {
        [self hideNoticeHUDElement];
    }
    
    self.isShowingActivityIndicatorHUD = YES;
    self.hidden = NO;
    self.alpha = 1.0f;
    
    self.activityIndicatorLabelString = string;
    [self setActivityIndicatorHUDWithText:self.activityIndicatorLabelString];
    
    self.activityIndicatorLabel.hidden = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)setActivityIndicatorHUDWithText:(NSString *)string
{
    if (string)
    {
        //-- 以 center 点为参照座标设定菊花和文字 -----------
        self.activityIndicatorLabel.text = string;
        // 计算 label 大小
        NSDictionary *activityIndicatorLabelAttribute =
        [NSDictionary dictionaryWithObjectsAndKeys:kACMaskHUDViewActivityIndicatorLabel_font, NSFontAttributeName, nil];
        
        CGSize activityIndicatorLabelSize =
        [self.activityIndicatorLabel.text
         boundingRectWithSize:CGSizeMake(kACMaskHUDViewActivityIndicatorLabel_max_w,
                                         kACMaskHUDViewActivityIndicatorLabel_h)
         options: NSStringDrawingUsesLineFragmentOrigin
         attributes:activityIndicatorLabelAttribute
         context:nil].size;
        
        CGFloat unite_w =
        kACMaskHUDViewActivityIndicatorView_w_h
        + kACMaskHUDViewActivityIndicator_gap
        + activityIndicatorLabelSize.width;
        
        CGFloat activityIndicator_y = self.center.y - (kACMaskHUDViewActivityIndicatorLabel_h / 2.0f);
        
        CGFloat activityIndicatorView_x =
        ((self.bounds.size.width - unite_w) / 2.0f);
        
        self.activityIndicatorView.frame = CGRectMake(activityIndicatorView_x,
                                                      activityIndicator_y,
                                                      kACMaskHUDViewActivityIndicatorView_w_h,
                                                      kACMaskHUDViewActivityIndicatorView_w_h);
        
        CGFloat activityIndicatorLabel_x =
        activityIndicatorView_x
        + kACMaskHUDViewActivityIndicatorView_w_h
        + kACMaskHUDViewActivityIndicator_gap;
        self.activityIndicatorLabel.frame = CGRectMake(activityIndicatorLabel_x,
                                                       activityIndicator_y,
                                                       activityIndicatorLabelSize.width,
                                                       kACMaskHUDViewActivityIndicatorLabel_h);
        
    }
    else
    {
        // 只显示菊花
        self.activityIndicatorView.center = self.center;
    }
}

#pragma mark - ActivityIndicatorHUD hide func

- (void)hideActivityIndicatorElement
{
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
    self.activityIndicatorLabel.hidden = YES;
    self.isShowingActivityIndicatorHUD = NO;
}

#pragma mark - RefreshHUD show func

- (void)showRefreshHUD
{
    [self showRefreshHUDWithText:nil];
}

- (void)showRefreshHUDWithText:(NSString *)string
{
    [self addNotificationObserver];
    
    // hide others first
    if (self.isShowingActivityIndicatorHUD)
    {
        [self hideActivityIndicatorElement];
    }
    else if (self.isShowingNoticeHUD)
    {
        [self hideNoticeHUDElement];
    }
    
    self.isShowingRefreshHUD = YES;
    self.hidden = NO;
    self.alpha = 1.0f;
    
    self.refreshLabelString = string;
    [self setRefreshHUDWithText:self.refreshLabelString];
    
    self.refreshLabel.hidden = NO;
    self.refreshButton.hidden = NO;
}

- (void)setRefreshHUDWithText:(NSString *)string
{
    if (string)
    {
        //-- 以 center 点为参照座标设定刷新说明和按钮 -----------
        self.refreshLabel.text = string;
        // 计算 label 大小
        NSDictionary *refreshLabelAttribute =
        [NSDictionary dictionaryWithObjectsAndKeys:kACMaskHUDViewRefreshLabel_font, NSFontAttributeName, nil];
        
        CGSize refreshLabelSize =
        [self.refreshLabel.text
         boundingRectWithSize:CGSizeMake(kACMaskHUDViewRefreshLabel_max_w,
                                         kACMaskHUDViewRefreshLabel_max_h)
         options: NSStringDrawingUsesLineFragmentOrigin
         attributes:refreshLabelAttribute
         context:nil].size;
        
        CGFloat unite_h = refreshLabelSize.height + kACMaskHUDViewRefresh_gap + kACMaskHUDViewRefreshButton_h;
        
        CGFloat refreshLabel_x = (self.bounds.size.width - refreshLabelSize.width) / 2.0f;
        CGFloat refreshLabel_y = self.center.y - (unite_h / 2.0f);
        self.refreshLabel.frame = CGRectMake(refreshLabel_x,
                                             refreshLabel_y,
                                             refreshLabelSize.width,
                                             refreshLabelSize.height);
        
        CGFloat refreshButton_x = (self.bounds.size.width - kACMaskHUDViewRefreshButton_w) / 2.0f;
        CGFloat refreshButton_y = refreshLabel_y + refreshLabelSize.height + kACMaskHUDViewRefresh_gap;
        self.refreshButton.frame = CGRectMake(refreshButton_x,
                                              refreshButton_y,
                                              kACMaskHUDViewRefreshButton_w,
                                              kACMaskHUDViewRefreshButton_h);
        
    }
    else
    {
        // 只显示刷新按钮
        self.refreshButton.center = self.center;
    }
}

#pragma mark - RefreshHUD hide func

- (void)hideRefreshHUDElement
{
    self.refreshLabel.hidden = YES;
    self.refreshButton.hidden = YES;
    self.isShowingRefreshHUD = NO;
}

#pragma mark - NoticeHUD show func

- (void)showNoticeHUDWithTitleText:(NSString *)titleString detailText:(NSString *)detailString
{
    [self addNotificationObserver];
    
    // hide others first
    if (self.isShowingActivityIndicatorHUD)
    {
        [self hideActivityIndicatorElement];
    }
    else if (self.isShowingRefreshHUD)
    {
        [self hideRefreshHUDElement];
    }
    
    self.isShowingNoticeHUD = YES;
    self.hidden = NO;
    self.alpha = 1.0f;
    
    self.noticeTitleLabelString = titleString;
    self.noticeDetailLabelString = detailString;
    [self setNoticeHUDWithTitleText:self.noticeTitleLabelString detailText:self.noticeDetailLabelString];
    
    self.noticeTitleLabel.hidden = NO;
    self.noticeDetailLabel.hidden = NO;
}

- (void)setNoticeHUDWithTitleText:(NSString *)titleString detailText:(NSString *)detailString
{
    if (titleString && detailString)
    {
        //-- 以 center 点为参照座标 -----------
        self.noticeTitleLabel.text = titleString;
        self.noticeDetailLabel.text = detailString;
        
        // noticeTitleLabel 大小
        NSDictionary *noticeTitleLabelAttribute =
        [NSDictionary dictionaryWithObjectsAndKeys:kACMaskHUDViewNoticeTitleLabel_font, NSFontAttributeName, nil];
        
        CGSize noticeTitleLabelSize =
        [self.noticeTitleLabel.text
         boundingRectWithSize:CGSizeMake(kACMaskHUDViewNotice_max_w,
                                         kACMaskHUDViewNoticeTitleLabel_max_h)
         options: NSStringDrawingUsesLineFragmentOrigin
         attributes:noticeTitleLabelAttribute
         context:nil].size;
        
        // noticeDetailLabel 大小
        NSDictionary *noticeDetailLabelAttribute =
        [NSDictionary dictionaryWithObjectsAndKeys:kACMaskHUDViewNoticeTitleLabel_font, NSFontAttributeName, nil];
        
        CGSize noticeDetailLabelSize =
        [self.noticeDetailLabel.text
         boundingRectWithSize:CGSizeMake(kACMaskHUDViewNotice_max_w,
                                         kACMaskHUDViewNoticeDetailLabel_max_h)
         options: NSStringDrawingUsesLineFragmentOrigin
         attributes:noticeDetailLabelAttribute
         context:nil].size;
        
        
        CGFloat unite_h = noticeTitleLabelSize.height + noticeDetailLabelSize.height + kACMaskHUDViewNotice_gap;
        
        CGFloat noticeTitleLabel_x = (self.bounds.size.width - noticeTitleLabelSize.width) / 2.0f;
        CGFloat noticeTitleLabel_y = self.center.y - (unite_h / 2.0f);
        self.noticeTitleLabel.frame = CGRectMake(noticeTitleLabel_x,
                                                 noticeTitleLabel_y,
                                                 noticeTitleLabelSize.width,
                                                 noticeTitleLabelSize.height);
        
        CGFloat noticeDetailLabel_x = (self.bounds.size.width - noticeDetailLabelSize.width) / 2.0f;
        CGFloat noticeDetailLabel_y = noticeTitleLabel_y + noticeTitleLabelSize.height + kACMaskHUDViewNotice_gap;
        self.noticeDetailLabel.frame = CGRectMake(noticeDetailLabel_x,
                                                  noticeDetailLabel_y,
                                                  noticeDetailLabelSize.width,
                                                  noticeDetailLabelSize.height);
        
    }
    else if (titleString && !detailString)
    {
        // 只显示 title label
        self.noticeTitleLabel.text = titleString;
        
        // noticeTitleLabel 大小
        NSDictionary *noticeTitleLabelAttribute =
        [NSDictionary dictionaryWithObjectsAndKeys:kACMaskHUDViewNoticeTitleLabel_font, NSFontAttributeName, nil];
        
        CGSize noticeTitleLabelSize =
        [self.noticeTitleLabel.text
         boundingRectWithSize:CGSizeMake(kACMaskHUDViewNotice_max_w,
                                         kACMaskHUDViewNoticeTitleLabel_max_h)
         options: NSStringDrawingUsesLineFragmentOrigin
         attributes:noticeTitleLabelAttribute
         context:nil].size;
        
        self.noticeTitleLabel.frame = CGRectMake(self.center.x - (noticeTitleLabelSize.width / 2.0f),
                                                 self.center.y - (noticeTitleLabelSize.height / 2.0f),
                                                 noticeTitleLabelSize.width,
                                                 noticeTitleLabelSize.height);
    }
    else if (!titleString && detailString)
    {
        // 只显示 detail label
        self.noticeDetailLabel.text = detailString;
        
        // noticeDetailLabel 大小
        NSDictionary *noticeDetailLabelAttribute =
        [NSDictionary dictionaryWithObjectsAndKeys:kACMaskHUDViewNoticeTitleLabel_font, NSFontAttributeName, nil];
        
        CGSize noticeDetailLabelSize =
        [self.noticeDetailLabel.text
         boundingRectWithSize:CGSizeMake(kACMaskHUDViewNotice_max_w,
                                         kACMaskHUDViewNoticeDetailLabel_max_h)
         options: NSStringDrawingUsesLineFragmentOrigin
         attributes:noticeDetailLabelAttribute
         context:nil].size;
        
        self.noticeDetailLabel.frame = CGRectMake(self.center.x - (noticeDetailLabelSize.width / 2.0f),
                                                  self.center.y - (noticeDetailLabelSize.height / 2.0f),
                                                  noticeDetailLabelSize.width,
                                                  noticeDetailLabelSize.height);
    }
    else
    {
        self.noticeTitleLabelString = kACMaskHUDViewNoticeEmptyText;
        [self setNoticeHUDWithTitleText:kACMaskHUDViewNoticeEmptyText detailText:nil];
    }
}

#pragma mark - NoticeHUD hide func

- (void)hideNoticeHUDElement
{
    self.noticeTitleLabel.hidden = YES;
    self.noticeDetailLabel.hidden = YES;
    self.isShowingNoticeHUD = NO;
}


#pragma mark - Orientation func

- (void)orientationDidChange:(NSNotification*)notification
{
    if (self.isShowingActivityIndicatorHUD)
    {
        [self setActivityIndicatorHUDWithText:self.activityIndicatorLabelString];
    }
    else if (self.isShowingRefreshHUD)
    {
        [self setRefreshHUDWithText:self.refreshLabelString];
    }
    else if (self.isShowingNoticeHUD)
    {
        [self setNoticeHUDWithTitleText:self.noticeTitleLabelString detailText:self.noticeDetailLabelString];
    }
}

#pragma mark - NSNotificationCenter Register

- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)removeNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - dealloc

-(void)dealloc
{
    [self removeNotificationObserver];
}

#pragma mark - Init func

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.backgroundColor = kACMaskHUDViewBackgroundColor;
        
        [self createSubviews];
        
        // hidden at the beginning
        self.alpha = 0.0f;
        self.hidden = YES;
    }
    return self;
}

#pragma mark - Create Subviews

- (void)createSubviews
{
    [self createIndicatorHUD];
    [self createRefreshHUD];
    [self createNoticeHUD];
}

#pragma mark - Indicator HUD

- (void)createIndicatorHUD
{
    self.activityIndicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    [self addSubview:self.activityIndicatorView];
    
    self.activityIndicatorLabel = [[UILabel alloc] init];
    self.activityIndicatorLabel.frame = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.activityIndicatorLabel.textColor = kACMaskHUDViewTextColor;
    self.activityIndicatorLabel.font = kACMaskHUDViewActivityIndicatorLabel_font;
    [self addSubview:self.activityIndicatorLabel];
    
    self.isShowingActivityIndicatorHUD = NO;
    
    // hidden at the beginning
    self.activityIndicatorView.hidden = YES;
    self.activityIndicatorLabel.hidden = YES;
    
    // testing rect
    //self.activityIndicatorView.backgroundColor = [UIColor blueColor];
    //self.activityIndicatorLabel.backgroundColor = [UIColor orangeColor];
}

#pragma mark - Refresh HUD

- (void)refreshButtonBorderColorNormal
{
    self.refreshButton.layer.borderColor = kACMaskHUDViewRefreshButtonTextActionColor.CGColor;
}

- (void)refreshButtonBorderColorHighlighted
{
    self.refreshButton.layer.borderColor = kACMaskHUDViewRefreshButtonTextHighlightedColor.CGColor;
}

- (void)refreshButtonTapped:(UIButton *)sender
{
    self.refreshButton.layer.borderColor = kACMaskHUDViewRefreshButtonTextActionColor.CGColor;
    if ( nil != self.delegate && [self.delegate respondsToSelector:@selector(refreshButtondidTap)] )
    {
        [self.delegate refreshButtondidTap];
    }
}

- (void)createRefreshHUD
{
    self.refreshLabel = [[UILabel alloc] init];
    self.refreshLabel.frame = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.refreshLabel.textColor = kACMaskHUDViewTextColor;
    self.refreshLabel.font = kACMaskHUDViewRefreshLabel_font;
    self.refreshLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshLabel.numberOfLines = 0;
    [self addSubview:self.refreshLabel];
    

    self.refreshButton = [[UIButton alloc] init];
    self.refreshButton.frame = CGRectMake(0.0f, 0.0f, kACMaskHUDViewRefreshButton_w, kACMaskHUDViewRefreshButton_h);
    
    [self.refreshButton setTitleColor:kACMaskHUDViewRefreshButtonTextActionColor forState:UIControlStateNormal];
    [self.refreshButton setTitleColor:kACMaskHUDViewRefreshButtonTextHighlightedColor forState:UIControlStateHighlighted];
    [self.refreshButton setTitle:kACMaskHUDViewRefreshButtonText forState:UIControlStateNormal];
    
    // border
    self.refreshButton.layer.cornerRadius = 6;
    self.refreshButton.layer.borderWidth = 1;
    self.refreshButton.layer.borderColor = kACMaskHUDViewRefreshButtonTextActionColor.CGColor;
    
    // border color changing
    [self.refreshButton addTarget:self
                           action:@selector(refreshButtonBorderColorHighlighted)
                 forControlEvents:UIControlEventTouchDown];
    
    [self.refreshButton addTarget:self
                           action:@selector(refreshButtonBorderColorNormal)
                 forControlEvents:UIControlEventTouchUpOutside];
    
    // action
    [self.refreshButton addTarget:self action:@selector(refreshButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.refreshButton];
    
    self.isShowingRefreshHUD = NO;
    
    // hidden at the beginning
    self.refreshLabel.hidden = YES;
    self.refreshButton.hidden = YES;
    
    // testing rect
    //self.refreshLabel.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - Notice HUD

- (void)createNoticeHUD
{
    self.noticeTitleLabel = [[UILabel alloc] init];
    self.noticeTitleLabel.frame = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.noticeTitleLabel.textColor = kACMaskHUDViewTextColor;
    self.noticeTitleLabel.font = kACMaskHUDViewNoticeTitleLabel_font;
    self.noticeTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.noticeTitleLabel.numberOfLines = 0;
    [self addSubview:self.noticeTitleLabel];
    
    self.noticeDetailLabel = [[UILabel alloc] init];
    self.noticeDetailLabel.frame = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.noticeDetailLabel.textColor = kACMaskHUDViewTextColor;
    self.noticeDetailLabel.font = kACMaskHUDViewNoticeDetailLabel_font;
    self.noticeDetailLabel.textAlignment = NSTextAlignmentCenter;
    self.noticeDetailLabel.numberOfLines = 0;
    [self addSubview:self.noticeDetailLabel];
    
    self.isShowingNoticeHUD = NO;
    
    // hidden at the beginning
    self.noticeTitleLabel.hidden = YES;
    self.noticeDetailLabel.hidden = YES;
    
    // testing rect
    //self.noticeTitleLabel.backgroundColor = [UIColor blueColor];
    //self.noticeDetailLabel.backgroundColor = [UIColor orangeColor];
}

@end
