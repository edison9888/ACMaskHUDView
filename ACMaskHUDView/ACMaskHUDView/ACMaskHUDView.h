//
//  ACMaskHUDView.h
//  ACMaskHUDView
//
//  Created by Albert Chu on 14/7/29.
//  Copyright (c) 2014年 AC. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 刷新按钮代理 */
@protocol ACMaskHUDViewDelegate <NSObject>

- (void)refreshButtondidTap;

@end


@interface ACMaskHUDView : UIView

@property (nonatomic, assign) id<ACMaskHUDViewDelegate> delegate;

- (void)showActivityIndicatorHUD;
- (void)showActivityIndicatorHUDWithLabelText:(NSString *)string;
- (void)hideActivityIndicatorHUD;
- (void)hideActivityIndicatorHUDWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)showRefreshHUD;
- (void)showRefreshHUDWithLabelText:(NSString *)string;
- (void)hideRefreshHUD;
- (void)hideRefreshHUDWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)showNoticeHUDWithTitleText:(NSString *)titleString andDetailText:(NSString *)detailString;
- (void)hideNoticeHUD;
- (void)hideNoticeHUDWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

- (void)willChangeOrientation;

@end
