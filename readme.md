## ACMaskHUDView

A simply HUDView 


## Installing

    Drag ACMaskHUDView folder into your project. 
	
```objective-c
#import "ACMaskHUDView.h  
```


## Usage

* Initialization

```objective-c
//set delegate to your class
@interface YourViewController () <ACMaskHUDViewDelegate>

// add to your view
self.maskHUDView = [[ACMaskHUDView alloc] initWithFrame:self.view.bounds];
self.maskHUDView.delegate = self;
[self.view addSubview:self.maskHUDView];
```

* ActivityIndicatorHUD

```objective-c
// show
[self.maskHUDView showActivityIndicatorHUD];

// show with text
[self.maskHUDView showActivityIndicatorHUDWithLabelText:@"your loading string"];
```
<img src="https://github.com/albertgh/ACMaskHUDView/raw/master/screenshot/loading_hud.png"/>



* RefreshHUD

```objective-c
// show 
[self.maskHUDView showRefreshHUD];

// show with a describe label
[self.maskHUDView showRefreshHUDWithLabelText:@"your refresh describe"];

#pragma mark - ACMaskHUDViewDelegate

- (void)refreshButtondidTap
{
    // refresh action
}
```
<img src="https://github.com/albertgh/ACMaskHUDView/raw/master/screenshot/refresh_hud.png"/>



* NoticeHUD

```objective-c
// Show NoticeHUD with title and detail string, or title only or detail only.
// If both text string is nil, will simply show a @"!" at center.
[self.maskHUDView showNoticeHUDWithTitleText:@"No network"
                               andDetailText:@"Please check your network"];
```
<img src="https://github.com/albertgh/ACMaskHUDView/raw/master/screenshot/notice_hud.png"/>



* Hide HUD

```objective-c
// Whatever it is showing hide it immediately.
[self.maskHUDView hideHUD];

// Hide with a duration time to fadeout and with or without a completion block 
[self.maskHUDView hideHUDWithDuration:0.4 completion:nil];

// Especially notice this, if you want to show another HUD when you are already showing one, 
// just call show function, no need to call hide function befroe.
// For example, when you are requesting some data from network, you are showing the ActivityIndicatorHUD, 
// when it failed, you want to show a RefreshHUD instead. Just call RefreshHUD show function will be enough.
[self.maskHUDView showActivityIndicatorHUDWithLabelText:@"loading..."];
[self.maskHUDView showRefreshHUDWithLabelText:@"Loading error, please try again."];
```

* Rotation support

No need to do anything now, it will fit CGRect automatically.

~~// If you are going to support interface rotation, Just tell ACMaskHUDView.~~

~~-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {~~

~~[self.maskHUDView willChangeOrientation];~~

~~}~~


#### Requirements

* ARC

* iOS 7+


#### License

######WTFPL 


