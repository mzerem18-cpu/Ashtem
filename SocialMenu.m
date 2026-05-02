#import <UIKit/UIKit.h>

// دروستکرنا شاشەیەکا تایبەت (Custom View Controller) بۆ ئەشتە مۆبایل
@interface AshteWelcomeViewController : UIViewController
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // شێوازێ پێشکەفتی (Full Screen Presentation) کو هەموو شاشەکە دگریت
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    // --- دیزاینی پاشبنەما (Background Design) ---

    // کاریگەری تەڵخ (Blur Effect) بۆ پاشبنەمای مۆدێرن
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];

    // "Gradient"ی مۆدێرن لە شین بۆ سەوز لە سەر پاشبنەما
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0.2 green:0.3 blue:0.9 alpha:0.3].CGColor, (__bridge id)[UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:0.3].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];

    // --- ڕێکخستنی پێکهاتەکان (View Setup) ---

    // دروستکرنا StackView سەرەکی بۆ ڕێکخستنا هەمی تشتان ب سەر یەکڤە بۆ تاقیگە (قیە)
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

    // --- 1. بەشی لۆگۆی کەسی (Avatar Section) ---

    // لۆگۆی کەسی (avatar) لە لینکێ `a.png`
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill; // بۆ باشتر کردنی قیاس
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 35; // بۆ خڕکرنا قەراخێن وێنەی وەکو لۆگۆی مۆدێرن
    imageView.clipsToBounds = YES;
    
    // چوارچێوەیەکی تەنک و مۆدێرن بۆ لۆگۆ
    imageView.layer.borderWidth = 1.5;
    imageView.layer.borderColor = [UIColor secondaryLabelColor].CGColor;
    [mainStack addArrangedSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:70],
        [imageView.heightAnchor constraintEqualToConstant:70]
    ]];

    // ئینانا وێنەی ژ لینکێ تە ب شێوەیێ خێرا (Async)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"https://ashtemobile.tututweak.com/a.png"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    } );

    // --- 2. بەشی دەقی پێشوازی (Welcome Text Section) ---

    // ناڤێ تە (تایتڵ) بە فونتی مۆدێرن و گەورە
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Welcome to\nAshteMobile";
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1 weight:UIFontWeightBold]; // مۆدێرن
    [mainStack addArrangedSubview:titleLabel];

    // دەقی ژێرە بۆ ڕوونکردنەوە
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"Your all-in-one iOS app sideloading solution";
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody]; // مۆدێرن
    [mainStack addArrangedSubview:subtitleLabel];

    // --- 3. بەشی سۆشیاڵ میدیا و دوگمەکان (Social Buttons Section) ---

    // کۆمکرنا دوگمەیێن سۆشیاڵ میدیا ب شێوازێ مۆدێرن
    UIStackView *socialStack = [[UIStackView alloc] init];
    socialStack.axis = UILayoutConstraintAxisVertical;
    socialStack.spacing = 15;
    socialStack.distribution = UIStackViewDistributionFillEqually;
    socialStack.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:socialStack];

    [NSLayoutConstraint activateConstraints:@[
        [socialStack.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    // فەنکشنەکا بچویک بۆ دروستکرنا دوگمەیێن مۆدێرن (بۆ هەر لینکەکێ) لەگەڵ لۆگۆی ڕەسەن
    UIButton* (^createSocialButton)(NSString*, UIColor*, NSString*, SEL) = ^UIButton*(NSString *title, UIColor *color, NSString *imageUrl, SEL action) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = [UIColor secondarySystemBackgroundColor]; // ڕەنگێ باکگراوندێ مۆدێرن
        btn.layer.cornerRadius = 15; // قەراخێن خڕ
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
        // دروستکردنی StackView ئاسۆیی بۆ لۆگۆ و دەق لە ناو دوگمە
        UIStackView *contentStack = [[UIStackView alloc] init];
        contentStack.axis = UILayoutConstraintAxisHorizontal;
        contentStack.spacing = 10;
        contentStack.alignment = UIStackViewAlignmentCenter;
        contentStack.translatesAutoresizingMaskIntoConstraints = NO;
        [btn addSubview:contentStack];
        
        [NSLayoutConstraint activateConstraints:@[
            [contentStack.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor],
            [contentStack.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
            [contentStack.heightAnchor constraintEqualToConstant:30]
        ]];
        
        // لۆگۆی سۆشیاڵ میدیا
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentStack addArrangedSubview:iconView];
        
        [NSLayoutConstraint activateConstraints:@[
            [iconView.widthAnchor constraintEqualToConstant:25],
            [iconView.heightAnchor constraintEqualToConstant:25]
        ]];
        
        // ئینانا لۆگۆ ژ لینکێ تە
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    iconView.image = [UIImage imageWithData:data];
                });
            }
        } );
        
        // دەقی دوگمە
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

    // لینکەکێن لۆگۆکانی ڕەسەن و مۆدێرن (بۆ تێلیگرام، تیک تۆک، وێبسایت)
    NSString *telegramIconUrl = @"https://img.icons8.com/color/96/telegram-app.png"; // لۆگۆی تێلیگرام ڕەسەن
    NSString *tiktokIconUrl = @"https://img.icons8.com/fluent/96/tiktok.png";       // لۆگۆی تیک تۆک ڕەسەن
    NSString *websiteIconUrl = @"https://img.icons8.com/fluency/96/web.png";          // لۆگۆی مۆدێرن بۆ وێبسایت

    // دروستکرنا دوگمەیان
    UIButton *tgBtn = createSocialButton(@"Telegram", [UIColor systemBlueColor], telegramIconUrl, @selector(openTelegram));
    UIButton *ttBtn = createSocialButton(@"TikTok", [UIColor blackColor], tiktokIconUrl, @selector(openTikTok));
    UIButton *webBtn = createSocialButton(@"Website", [UIColor systemPurpleColor], websiteIconUrl, @selector(openWebsite));

    [socialStack addArrangedSubview:tgBtn];
    [socialStack addArrangedSubview:ttBtn];
    [socialStack addArrangedSubview:webBtn];

    // --- 4. بەشی دوگمەی دەستپێکرن (Start Button Section) ---

    // دوگمەیا دەستپێکرنێ (Get Started) گەورە و جوان وەک وێنەی سەرەکی
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.4 green:0.46 blue:0.98 alpha:1.0]; // ڕەنگێ شینێ ڤەکری وەک وێنەی سەرەکی
    
    // دروستکردنی StackView ئاسۆیی بۆ دەق و ئایکۆن
    UIStackView *contentStack2 = [[UIStackView alloc] init];
    contentStack2.axis = UILayoutConstraintAxisHorizontal;
    contentStack2.spacing = 10;
    contentStack2.alignment = UIStackViewAlignmentCenter;
    contentStack2.translatesAutoresizingMaskIntoConstraints = NO;
    [closeBtn addSubview:contentStack2];
    
    [NSLayoutConstraint activateConstraints:@[
        [contentStack2.centerXAnchor constraintEqualToAnchor:closeBtn.centerXAnchor],
        [contentStack2.centerYAnchor constraintEqualToAnchor:closeBtn.centerYAnchor]
    ]];
    
    UILabel *closeLabel = [[UILabel alloc] init];
    closeLabel.text = @"Get Started";
    closeLabel.textColor = [UIColor whiteColor];
    closeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline weight:UIFontWeightBold];
    [contentStack2 addArrangedSubview:closeLabel];
    
    UIImageView *closeIcon = [[UIImageView alloc] init];
    closeIcon.image = [UIImage systemImageNamed:@"arrow.right.circle.fill"]; // ئایکۆنی ڕاستێ پێشکەفتی
    closeIcon.tintColor = [UIColor whiteColor];
    closeIcon.contentMode = UIViewContentModeScaleAspectFit;
    [contentStack2 addArrangedSubview:closeIcon];
    
    [NSLayoutConstraint activateConstraints:@[
        [closeIcon.widthAnchor constraintEqualToConstant:20],
        [closeIcon.heightAnchor constraintEqualToConstant:20]
    ]];
    
    closeBtn.layer.cornerRadius = 20; // قەراخێن خڕکرنا مۆدێرن
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
// بەشێ ئینجێکتکرنێ (Injection) بۆ ڤەکرنا ڤێ شاشەیێ ئۆتۆماتیکی
// ------------------------------------------------------------------
__attribute__((constructor)) static void showCustomWelcomeScreen() {
    // ١ چرکە چاڤەڕێ دکەت تا ئەپ ب جوانی ڤەدبیت
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
            // دیتنا بەرزترین شاشە (Top View Controller) بۆ ئەوەی بێ ئاریشە شاشەیا مە ڤەبیت
            UIViewController *topController = rootViewController;
            while (topController.presentedViewController) {
                topController = topController.presentedViewController;
            }
            
            AshteWelcomeViewController *welcomeVC = [[AshteWelcomeViewController alloc] init];
            
            // نیشاندانا شاشە بە شێوەیێ (Full Screen Modal)
            [topController presentViewController:welcomeVC animated:YES completion:nil];
        }
    });
}
