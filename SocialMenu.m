#import <UIKit/UIKit.h>

// دروستکرنا شاشەیەکا تایبەت (Custom View Controller) بۆ ئەشتە مۆبایل
@interface AshteWelcomeViewController : UIViewController
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    // --- دیزاینی پاشبنەما (Background Design) ---
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0.2 green:0.3 blue:0.9 alpha:0.3].CGColor, (__bridge id)[UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:0.3].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];

    // --- ڕێکخستنی پێکهاتەکان ---
    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 25;
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [mainStack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [mainStack.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.85]
    ]];

    // --- 1. بەشی لۆگۆی کەسی ---
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 35;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 1.5;
    imageView.layer.borderColor = [UIColor secondaryLabelColor].CGColor;
    [mainStack addArrangedSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:70],
        [imageView.heightAnchor constraintEqualToConstant:70]
    ]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"https://ashtemobile.tututweak.com/a.png"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });

    // --- 2. بەشی دەقی پێشوازی ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Welcome to\nAshteMobile";
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightBold];
    [mainStack addArrangedSubview:titleLabel];

    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"Your all-in-one iOS app sideloading solution";
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [mainStack addArrangedSubview:subtitleLabel];

    // --- 3. بەشی سۆشیاڵ میدیا ---
    UIStackView *socialStack = [[UIStackView alloc] init];
    socialStack.axis = UILayoutConstraintAxisVertical;
    socialStack.spacing = 15;
    socialStack.distribution = UIStackViewDistributionFillEqually;
    socialStack.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:socialStack];

    [NSLayoutConstraint activateConstraints:@[
        [socialStack.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    // چارەسەرکردنی کێشەی بلۆک بۆ ئەوەی کۆمپایلەر گیر نەکات
    __weak typeof(self) weakSelf = self;
    UIButton* (^createSocialButton)(NSString*, UIColor*, NSString*, SEL) = ^UIButton*(NSString *title, UIColor *color, NSString *imageUrl, SEL action) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = [UIColor secondarySystemBackgroundColor];
        btn.layer.cornerRadius = 15;
        [btn addTarget:weakSelf action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIStackView *contentStack = [[UIStackView alloc] init];
        contentStack.axis = UILayoutConstraintAxisHorizontal;
        contentStack.spacing = 10;
        contentStack.alignment = UIStackViewAlignmentCenter;
        contentStack.translatesAutoresizingMaskIntoConstraints = NO;
        contentStack.userInteractionEnabled = NO; // گرنگە بۆ ئەوەی دوگمەکە کلیک ببێت
        [btn addSubview:contentStack];
        
        [NSLayoutConstraint activateConstraints:@[
            [contentStack.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor],
            [contentStack.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
            [contentStack.heightAnchor constraintEqualToConstant:30]
        ]];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentStack addArrangedSubview:iconView];
        
        [NSLayoutConstraint activateConstraints:@[
            [iconView.widthAnchor constraintEqualToConstant:25],
            [iconView.heightAnchor constraintEqualToConstant:25]
        ]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    iconView.image = [UIImage imageWithData:data];
                });
            }
        });
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.textColor = color;
        label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        [contentStack addArrangedSubview:label];
        
        [NSLayoutConstraint activateConstraints:@[
            [btn.heightAnchor constraintEqualToConstant:55]
        ]];
        return btn;
    };

    NSString *telegramIconUrl = @"https://img.icons8.com/color/96/telegram-app.png";
    NSString *tiktokIconUrl = @"https://img.icons8.com/fluent/96/tiktok.png";
    NSString *websiteIconUrl = @"https://img.icons8.com/fluency/96/web.png";

    UIButton *tgBtn = createSocialButton(@"Telegram", [UIColor systemBlueColor], telegramIconUrl, @selector(openTelegram));
    // ڕەنگەکەم گۆڕی بۆ labelColor بۆ ئەوەی لە دارک مۆدیش جوان دەربکەوێت
    UIButton *ttBtn = createSocialButton(@"TikTok", [UIColor labelColor], tiktokIconUrl, @selector(openTikTok));
    UIButton *webBtn = createSocialButton(@"Website", [UIColor systemPurpleColor], websiteIconUrl, @selector(openWebsite));

    [socialStack addArrangedSubview:tgBtn];
    [socialStack addArrangedSubview:ttBtn];
    [socialStack addArrangedSubview:webBtn];

    // --- 4. بەشی دوگمەی دەستپێکرن ---
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.4 green:0.46 blue:0.98 alpha:1.0];
    
    UIStackView *contentStack2 = [[UIStackView alloc] init];
    contentStack2.axis = UILayoutConstraintAxisHorizontal;
    contentStack2.spacing = 10;
    contentStack2.alignment = UIStackViewAlignmentCenter;
    contentStack2.translatesAutoresizingMaskIntoConstraints = NO;
    contentStack2.userInteractionEnabled = NO;
    [closeBtn addSubview:contentStack2];
    
    [NSLayoutConstraint activateConstraints:@[
        [contentStack2.centerXAnchor constraintEqualToAnchor:closeBtn.centerXAnchor],
        [contentStack2.centerYAnchor constraintEqualToAnchor:closeBtn.centerYAnchor]
    ]];
    
    UILabel *closeLabel = [[UILabel alloc] init];
    closeLabel.text = @"Get Started";
    closeLabel.textColor = [UIColor whiteColor];
    closeLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [contentStack2 addArrangedSubview:closeLabel];
    
    UIImageView *closeIcon = [[UIImageView alloc] init];
    closeIcon.image = [UIImage systemImageNamed:@"arrow.right.circle.fill"];
    closeIcon.tintColor = [UIColor whiteColor];
    closeIcon.contentMode = UIViewContentModeScaleAspectFit;
    [contentStack2 addArrangedSubview:closeIcon];
    
    [NSLayoutConstraint activateConstraints:@[
        [closeIcon.widthAnchor constraintEqualToConstant:20],
        [closeIcon.heightAnchor constraintEqualToConstant:20]
    ]];
    
    closeBtn.layer.cornerRadius = 20;
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor],
        [closeBtn.heightAnchor constraintEqualToConstant:60]
    ]];
}

// کارکرنا لینکان
- (void)openTelegram {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil];
}

- (void)openTikTok {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tiktok.com/@ashtemobile"] options:@{} completionHandler:nil];
}

- (void)openWebsite {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/"] options:@{} completionHandler:nil];
}

// داخستنا شاشەیێ
- (void)closeTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

// ------------------------------------------------------------------
// بەشێ ئینجێکتکرنێ 
// ------------------------------------------------------------------
__attribute__((constructor)) static void showCustomWelcomeScreen() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *keyWindow = nil;
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.isKeyWindow) {
                keyWindow = window;
                break;
            }
        }
        
        UIViewController *rootViewController = keyWindow.rootViewController;
        if (rootViewController) {
            UIViewController *topController = rootViewController;
            while (topController.presentedViewController) {
                topController = topController.presentedViewController;
            }
            
            AshteWelcomeViewController *welcomeVC = [[AshteWelcomeViewController alloc] init];
            [topController presentViewController:welcomeVC animated:YES completion:nil];
        }
    });
}
