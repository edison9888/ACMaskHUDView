//
//  ACMaskHUDView.h
//  ACMaskHUDView
//
//  Created by Albert Chu on 14/7/29.
//  Copyright (c) 2014年 AC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACMaskHUDViewDelegate <NSObject>
- (void)refreshButtondidTap;
@end


@interface ACMaskHUDView : UIView

@property (nonatomic, assign) id<ACMaskHUDViewDelegate> delegate;

- (void)showActivityIndicatorHUD;
- (void)showActivityIndicatorHUDWithLabelText:(NSString *)string;

- (void)showRefreshHUD;
- (void)showRefreshHUDWithLabelText:(NSString *)string;

- (void)showNoticeHUDWithTitleText:(NSString *)titleString andDetailText:(NSString *)detailString;

- (void)hideHUD;
- (void)hideHUDWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

@end
