## ACMaskHUDView

A simply HUDView 


## Installing

```
Drag ACMaskHUDView folder into your project. 
```

```objective-c
#import "ACMaskHUDView.h  
```


## Usage

* Initialization

```objective-c
// set delegate to your class
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
[self.maskHUDView showActivityIndicatorHUDWithText:@"your loading string"];
```
<img src="https://github.com/albertgh/ACMaskHUDView/raw/master/screenshot/loading_hud.png"/>



* RefreshHUD

```objective-c
// show 
[self.maskHUDView showRefreshHUD];

// show with a describe label
[self.maskHUDView showRefreshHUDWithText:@"your refresh describe"];

#pragma mark - ACMaskHUDViewDelegate

- (void)refreshButtonTapped
{
    // refresh action
}
```
<img src="https://github.com/albertgh/ACMaskHUDView/raw/master/screenshot/refresh_hud.png"/>


* NoticeHUD

```objective-c
// Show NoticeHUD with title and detail string, or title only or detail only.
// If both text string is nil, will simply show a @"!" at center.
[self.maskHUDView showNoticeHUDWithTitleText:@"your notice title"
                                  detailText:@"your notice detail"];
```
<img src="https://github.com/albertgh/ACMaskHUDView/raw/master/screenshot/notice_hud.png"/>


* Hide HUD

```objective-c
// Whatever it is showing hide it immediately.
[self.maskHUDView hideHUD];

// Hide with a duration time to fadeout and with or without a completion block 
[self.maskHUDView hideHUDWithDuration:0.4f completion:nil];
```

* Rotation support

```
No need to do anything, it will fit CGRect automatically.
```

* Notice

```objective-c
// If you want to show another HUD when you are already showing one, 
// just call show function, no need to call hide function before.

// For example, when you are requesting some data from network, 
// you are showing the ActivityIndicatorHUD at first, 
// when request failed, you want to show a RefreshHUD instead. 
// Just call RefreshHUD show function will be enough.
[self.maskHUDView showActivityIndicatorHUDWithText:@"loading..."];
[self.maskHUDView showRefreshHUDWithText:@"Loading error, please try again."];

// Especially notice this, if you are using 'hideHUDWithDuration:completion:' ,
// and you are going to show another HUD, call show function in completion block
[self.maskHUDView hideHUDWithDuration:0.36f completion:^(BOOL finished) {
    [self.maskHUDView showNoticeHUDWithTitleText:nil
                                      detailText:nil];
}];
```


#### Requirements

* ARC

* iOS 7+


#### License

######WTFPL 


