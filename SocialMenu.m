#import <UIKit/UIKit.h>

// دروستکردنی گۆڕاوێک بۆ پەنجەرە تایبەتەکەی خۆت
static UIWindow *ashteWindow = nil;

@interface AshteWelcomeViewController : UIViewController
- (void)openTelegram;
- (void)openTikTok;
- (void)openWebsite;
- (void)closeTapped;
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 28;
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [mainStack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];

    // --- لۆگۆی کەسی ---
    UIView *iconShadowContainer = [[UIView alloc] init];
    iconShadowContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    iconShadowContainer.layer.shadowOpacity = 0.15;
    iconShadowContainer.layer.shadowOffset = CGSizeMake(0, 8);
    iconShadowContainer.layer.shadowRadius = 15;
    [mainStack addArrangedSubview:iconShadowContainer];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 24; 
    imageView.clipsToBounds = YES;
    [iconShadowContainer addSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:115],
        [imageView.heightAnchor constraintEqualToConstant:115],
        [imageView.topAnchor constraintEqualToAnchor:iconShadowContainer.topAnchor],
        [imageView.bottomAnchor constraintEqualToAnchor:iconShadowContainer.bottomAnchor],
        [imageView.leadingAnchor constraintEqualToAnchor:iconShadowContainer.leadingAnchor],
        [imageView.trailingAnchor constraintEqualToAnchor:iconShadowContainer.trailingAnchor]
    ]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/4K8boi7.jpeg"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });

    // --- دەقی پێشوازی ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile";
    titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor labelColor];
    [mainStack addArrangedSubview:titleLabel];

    // --- سۆشیاڵ میدیا دوگمەکان ---
    UIStackView *buttonsVStack = [[UIStackView alloc] init];
    buttonsVStack.axis = UILayoutConstraintAxisVertical;
    buttonsVStack.spacing = 15;
    buttonsVStack.alignment = UIStackViewAlignmentCenter;
    [mainStack addArrangedSubview:buttonsVStack];

    UIStackView *topHStack = [[UIStackView alloc] init];
    topHStack.axis = UILayoutConstraintAxisHorizontal;
    topHStack.spacing = 15;
    [buttonsVStack addArrangedSubview:topHStack];

    // ١. تێلیگرام
    UIButton *tgBtn = [self createPillButton:@"Telegram"
                                       color:[UIColor colorWithRed:0.0 green:0.55 blue:1.0 alpha:1.0]
                                    iconName:@"paperplane.fill" 
                                     urlIcon:nil
                                      action:@selector(openTelegram)];

    // ٢. تیکتۆک
    UIButton *ttBtn = [self createPillButton:@"TikTok"
                                       color:[UIColor blackColor]
                                    iconName:nil
                                     urlIcon:@"https://img.icons8.com/ios-filled/100/ffffff/tiktok.png"
                                      action:@selector(openTikTok)];

    [topHStack addArrangedSubview:tgBtn];
    [topHStack addArrangedSubview:ttBtn];

    // ٣. وێبسایت
    UIButton *webBtn = [self createPillButton:@"Website"
                                       color:[UIColor colorWithRed:0.9 green:0.25 blue:0.45 alpha:1.0] 
                                    iconName:@"safari.fill" 
                                     urlIcon:nil
                                      action:@selector(openWebsite)];
    
    [buttonsVStack addArrangedSubview:webBtn];

    // --- بۆشایی ---
    UIView *spacer = [[UIView alloc] init];
    [spacer.heightAnchor constraintEqualToConstant:15].active = YES;
    [mainStack addArrangedSubview:spacer];

    // --- دوگمەی Get Started ---
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.04 green:0.47 blue:0.80 alpha:1.0];
    closeBtn.layer.cornerRadius = 18;
    
    closeBtn.layer.shadowColor = closeBtn.backgroundColor.CGColor;
    closeBtn.layer.shadowOpacity = 0.4;
    closeBtn.layer.shadowOffset = CGSizeMake(0, 8);
    closeBtn.layer.shadowRadius = 15;
    
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor],
        [closeBtn.heightAnchor constraintEqualToConstant:60]
    ]];

    UIStackView *closeStack = [[UIStackView alloc] init];
    closeStack.axis = UILayoutConstraintAxisHorizontal;
    closeStack.spacing = 12;
    closeStack.alignment = UIStackViewAlignmentCenter;
    closeStack.translatesAutoresizingMaskIntoConstraints = NO;
    closeStack.userInteractionEnabled = NO; 
    [closeBtn addSubview:closeStack];

    [NSLayoutConstraint activateConstraints:@[
        [closeStack.centerXAnchor constraintEqualToAnchor:closeBtn.centerXAnchor],
        [closeStack.centerYAnchor constraintEqualToAnchor:closeBtn.centerYAnchor]
    ]];

    UILabel *closeLabel = [[UILabel alloc] init];
    closeLabel.text = @"Get Started";
    closeLabel.textColor = [UIColor whiteColor];
    closeLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    [closeStack addArrangedSubview:closeLabel];

    UIImageView *closeIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"arrow.right.circle.fill"]];
    closeIcon.tintColor = [UIColor whiteColor];
    closeIcon.contentMode = UIViewContentModeScaleAspectFit;
    [closeStack addArrangedSubview:closeIcon];

    [NSLayoutConstraint activateConstraints:@[
        [closeIcon.widthAnchor constraintEqualToConstant:26],
        [closeIcon.heightAnchor constraintEqualToConstant:26]
    ]];
}

// فەنکشنی دروستکردنی دوگمەکان
- (UIButton *)createPillButton:(NSString *)title color:(UIColor *)color iconName:(NSString *)iconName urlIcon:(NSString *)urlIcon action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 25; 

    btn.layer.shadowColor = color.CGColor;
    btn.layer.shadowOpacity = 0.5;
    btn.layer.shadowOffset = CGSizeMake(0, 5);
    btn.layer.shadowRadius = 10;

    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.axis = UILayoutConstraintAxisHorizontal;
    contentStack.spacing = 8;
    contentStack.alignment = UIStackViewAlignmentCenter;
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    contentStack.userInteractionEnabled = NO;
    [btn addSubview:contentStack];

    [NSLayoutConstraint activateConstraints:@[
        [contentStack.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor],
        [contentStack.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor]
    ]];

    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.tintColor = [UIColor whiteColor]; 
    [contentStack addArrangedSubview:iconView];

    [NSLayoutConstraint activateConstraints:@[
        [iconView.widthAnchor constraintEqualToConstant:22],
        [iconView.heightAnchor constraintEqualToConstant:22]
    ]];

    if (iconName) {
        iconView.image = [UIImage systemImageNamed:iconName];
    } else if (urlIcon) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlIcon]];
            if (data) {
                UIImage *img = [[UIImage imageWithData:data] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                dispatch_async(dispatch_get_main_queue(), ^{
                    iconView.image = img;
                });
            }
        });
    }

    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [contentStack addArrangedSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [btn.widthAnchor constraintEqualToConstant:145],
        [btn.heightAnchor constraintEqualToConstant:50]
    ]];

    return btn;
}

// کارکرنا لینکان
- (void)openTelegram { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openTikTok { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tiktok.com/@ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openWebsite { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/"] options:@{} completionHandler:nil]; }

// سڕینەوەی پەنجەرەکە کاتێک کلیک لە دوگمەکە دەکرێت بۆ ئەوەی یارییەکە دەربکەوێت
- (void)closeTapped { 
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        ashteWindow.hidden = YES;
        ashteWindow = nil;
    }];
}

@end

// ------------------------------------------------------------------
// بەشێ ئینجێکتکرنێ (سیستەمی نوێ بۆ بلۆککردنی ئەپەکە سەرەتا)
// ------------------------------------------------------------------
__attribute__((constructor)) static void showCustomWelcomeScreen() {
    // چاودێری دەکەین هەر کە ئەپەکە چالاک بوو (Active) یەکسەر شاشەی تۆ نیشان دەدەین بێ چاوەڕوانکردن
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        // ئەمە دڵنیایی دەدات کە تەنها یەک جار ئەمە ڕوودەدات نەک هەموو جارێک کە ئەپەکە دێتە خوارەوە
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            // دروستکردنی پەنجەرەیەکی سەربەخۆ لە سەرووی یارییەکە/ئەپەکەوە
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                    if (scene.activationState == UISceneActivationStateForegroundActive) {
                        ashteWindow = [[UIWindow alloc] initWithWindowScene:scene];
                        break;
                    }
                }
            }
            
            if (!ashteWindow) {
                ashteWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            }
            
            // UIWindowLevelAlert مانای وایە ئەمە لە سەرووی هەموو شتێکەوەیە تەنانەت ئاگادارکردنەوەکانیش
            ashteWindow.windowLevel = UIWindowLevelAlert + 1;
            ashteWindow.backgroundColor = [UIColor clearColor];
            
            AshteWelcomeViewController *welcomeVC = [[AshteWelcomeViewController alloc] init];
            ashteWindow.rootViewController = welcomeVC;
            [ashteWindow makeKeyAndVisible]; // یەکسەر دەیهێنێتە سەر شاشەکە
        });
    }];
}
