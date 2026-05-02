#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h> // پێویستە بۆ کارپێکردنی ڕیکلامەکە

// ------------------------------------------------------------------
// ١. شاشەی بەخێرهاتن (Welcome Screen) و سۆشیاڵ میدیا
// ------------------------------------------------------------------

@interface AshteWelcomeViewController : UIViewController
- (void)openTelegram;
- (void)openTikTok;
- (void)openWebsite;
- (void)closeTapped;
- (UIButton *)createSocialButtonWithTitle:(NSString *)title color:(UIColor *)color imageUrl:(NSString *)imageUrl action:(SEL)action;
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];

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

    // لۆگۆی کەسی
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 35;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 1.5;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [mainStack addArrangedSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:70],
        [imageView.heightAnchor constraintEqualToConstant:70]
    ]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/a.png"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });

    // تایتڵ
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Welcome to\nAshteMobile";
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor whiteColor];
    [mainStack addArrangedSubview:titleLabel];

    // سۆشیاڵ میدیا
    UIStackView *socialStack = [[UIStackView alloc] init];
    socialStack.axis = UILayoutConstraintAxisVertical;
    socialStack.spacing = 15;
    socialStack.distribution = UIStackViewDistributionFillEqually;
    socialStack.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:socialStack];

    [NSLayoutConstraint activateConstraints:@[
        [socialStack.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    UIButton *tgBtn = [self createSocialButtonWithTitle:@"Telegram" color:[UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0] imageUrl:@"https://img.icons8.com/color/96/telegram-app.png" action:@selector(openTelegram)];
    UIButton *ttBtn = [self createSocialButtonWithTitle:@"TikTok" color:[UIColor whiteColor] imageUrl:@"https://img.icons8.com/fluent/96/tiktok.png" action:@selector(openTikTok)];
    UIButton *webBtn = [self createSocialButtonWithTitle:@"Website" color:[UIColor colorWithRed:0.8 green:0.4 blue:1.0 alpha:1.0] imageUrl:@"https://img.icons8.com/fluency/96/web.png" action:@selector(openWebsite)];

    [socialStack addArrangedSubview:tgBtn];
    [socialStack addArrangedSubview:ttBtn];
    [socialStack addArrangedSubview:webBtn];

    // دوگمەی دەستپێکرن
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.4 green:0.46 blue:0.98 alpha:1.0];
    closeBtn.layer.cornerRadius = 20;
    [closeBtn setTitle:@"Get Started" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor],
        [closeBtn.heightAnchor constraintEqualToConstant:60]
    ]];
}

- (UIButton *)createSocialButtonWithTitle:(NSString *)title color:(UIColor *)color imageUrl:(NSString *)imageUrl action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];
    btn.layer.cornerRadius = 15;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.axis = UILayoutConstraintAxisHorizontal;
    contentStack.spacing = 10;
    contentStack.alignment = UIStackViewAlignmentCenter;
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    contentStack.userInteractionEnabled = NO;
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
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
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
}

- (void)openTelegram { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openTikTok { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tiktok.com/@ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openWebsite { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/"] options:@{} completionHandler:nil]; }
- (void)closeTapped { [self dismissViewControllerAnimated:YES completion:nil]; }

@end

// ------------------------------------------------------------------
// ٢. بەشی ڕیکلام (Ad Banner)
// ------------------------------------------------------------------
static void showAdBanner() {
    // ٤ چرکە چاوەڕێ دەکات پاشان ڕیکلامەکە دەخاتە سەر شاشەکە
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
        
        if (keyWindow) {
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat bannerHeight = 60; // بەرزی ڕیکلامەکە
            
            // جێگیرکردنی لە خوارەوەی شاشەکە
            CGRect bannerFrame = CGRectMake(0, screenHeight - bannerHeight - 30, screenWidth, bannerHeight);
            
            WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
            WKWebView *adWebView = [[WKWebView alloc] initWithFrame:bannerFrame configuration:config];
            adWebView.scrollView.scrollEnabled = NO;
            adWebView.backgroundColor = [UIColor clearColor];
            adWebView.opaque = NO;
            adWebView.layer.zPosition = 9999; // هەمیشە لە سەرەوە بێت
            
            // کۆدی ڕیکلامەکەی تۆ
            NSString *adHTML = @"<html><body style='margin:0;padding:0;background-color:transparent;display:flex;justify-content:center;align-items:center;'><script src='https://pl28698373.profitablecpmratenetwork.com/d5/77/a5/d577a550908069c0ee7dce0a3adedeed.js'></script></body></html>";
            
            [adWebView loadHTMLString:adHTML baseURL:nil];
            [keyWindow addSubview:adWebView];
        }
    });
}

// ------------------------------------------------------------------
// ٣. بەشی سەرەکی و کارپێکردنی هەردووکیان پێکەوە
// ------------------------------------------------------------------
__attribute__((constructor)) static void startAshteMobileTweaks() {
    
    // یەکەم: ئامادەکردنی ڕیکلامەکە
    showAdBanner();

    // دووەم: نیشاندانی شاشەی بەخێرهاتن
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
        
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
