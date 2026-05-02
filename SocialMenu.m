#import <UIKit/UIKit.h>

// دروستکرنا شاشەیەکا تایبەت (Custom View Controller)
@interface AshteWelcomeViewController : UIViewController
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // شێوازێ مۆدێرن (Page Sheet) کو نیڤا شاشەیێ دگریت یان شاشەیا تەمام
    self.modalPresentationStyle = UIModalPresentationPageSheet; 

    // دروستکرنا StackView سەرەکی بۆ ڕێکخستنا هەمی تشتان ب سەر یەکڤە
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

    // 1. وێنە (لۆگۆیێ تە)
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 22; // بۆ خڕکرنا قەراخێن وێنەی
    imageView.clipsToBounds = YES;
    [mainStack addArrangedSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:110],
        [imageView.heightAnchor constraintEqualToConstant:110]
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
    });

    // 2. ناڤێ تە (تایتڵ)
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Welcome to\nAshteMobile";
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
    [mainStack addArrangedSubview:titleLabel];

    // 3. کۆمکرنا دوگمەیێن سۆشیاڵ میدیا
    UIStackView *socialStack = [[UIStackView alloc] init];
    socialStack.axis = UILayoutConstraintAxisVertical;
    socialStack.spacing = 15;
    socialStack.distribution = UIStackViewDistributionFillEqually;
    socialStack.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:socialStack];

    [NSLayoutConstraint activateConstraints:@[
        [socialStack.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    // فەنکشنەکا بچویک بۆ دروستکرنا دوگمەیێن مۆدێرن (بۆ هەر لینکەکێ)
    UIButton* (^createSocialButton)(NSString*, UIColor*, SEL) = ^UIButton*(NSString *title, UIColor *color, SEL action) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = [color colorWithAlphaComponent:0.1]; // ڕەنگێ باکگراوندێ سڤک
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:color forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        btn.layer.cornerRadius = 12; // قەراخێن خڕ
        
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
        [NSLayoutConstraint activateConstraints:@[
            [btn.heightAnchor constraintEqualToConstant:55]
        ]];
        return btn;
    };

    // دروستکرنا دوگمەیان
    UIButton *tgBtn = createSocialButton(@"📱 Telegram", [UIColor systemBlueColor], @selector(openTelegram));
    UIButton *ttBtn = createSocialButton(@"🎵 TikTok", [UIColor blackColor], @selector(openTikTok));
    UIButton *webBtn = createSocialButton(@"🌐 Website", [UIColor systemPurpleColor], @selector(openWebsite));

    [socialStack addArrangedSubview:tgBtn];
    [socialStack addArrangedSubview:ttBtn];
    [socialStack addArrangedSubview:webBtn];

    // 4. دوگمەیا دەستپێکرنێ (Get Started)
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.4 green:0.46 blue:0.98 alpha:1.0]; // ڕەنگێ شینێ ڤەکری وەک وێنەی
    [closeBtn setTitle:@"Get Started ➔" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    closeBtn.layer.cornerRadius = 15;
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
    // ٢ چرکە چاڤەڕێ دکەت تا ئەپ ب جوانی ڤەدبیت
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
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
            
            // ئەگەر ئای ئۆ ئێس ١٥ و بەرەڤ ژۆر بیت، شاشە دێ وەکی پەڕەیەکێ جوان هێتە پێش (Sheet Presentation)
            if (@available(iOS 15.0, *)) {
                if (welcomeVC.sheetPresentationController) {
                    welcomeVC.sheetPresentationController.detents = @[[UISheetPresentationControllerDetent mediumDetent], [UISheetPresentationControllerDetent largeDetent]];
                    welcomeVC.sheetPresentationController.prefersGrabberVisible = YES;
                }
            }
            
            [topController presentViewController:welcomeVC animated:YES completion:nil];
        }
    });
}
