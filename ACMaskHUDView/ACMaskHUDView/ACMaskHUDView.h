//
//  ACMaskHUDView.h
//  ACMaskHUDView
//
//  Created by Albert Chu on 14/7/29.
//  Copyright (c) 2014年 AC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACMaskHUDViewDelegate <NSObject>
- (void)refreshButtonTapped;
@end


@interface ACMaskHUDView : UIView

@property (nonatomic, assign) id<ACMaskHUDViewDelegate> delegate;

- (void)showActivityIndicatorHUD;
- (void)showActivityIndicatorHUDWithText:(NSString *)string;

- (void)showRefreshHUD;
- (void)showRefreshHUDWithText:(NSString *)string;

- (void)showNoticeHUDWithTitleText:(NSString *)titleString detailText:(NSString *)detailString;

- (void)hideHUD;
- (void)hideHUDWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

@end
