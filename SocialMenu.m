#import <UIKit/UIKit.h>

// ناساندنی هەموو فەنکشنەکان بۆ ئەوەی گیت هاب ئیرۆری (Undeclared Selector) نەدات
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
    
    // باکگراوندی ڕوون و تەڵخ (Blur) کە زۆر مۆدێرنە و کێشە بۆ گیت هاب دروست ناکات
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];

    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 28; // بۆشایی نێوانیانم کەمێک زیادکرد بۆ جوانی
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [mainStack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [mainStack.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.85]
    ]];

    // --- لۆگۆی کەسی (مۆدێرن و گەورەتر) ---
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 42; // بازنەیی تەواو
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.9].CGColor;
    [mainStack addArrangedSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:84],
        [imageView.heightAnchor constraintEqualToConstant:84]
    ]];

    // هێنانی لۆگۆی تە
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/a.png"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });

    // --- دەقی پێشوازی (فۆنتی زەبەلاح و مۆدێرن) ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Welcome to\nAshteMobile";
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:34 weight:UIFontWeightHeavy]; // ستایلی نوێی ئەپڵ
    titleLabel.textColor = [UIColor whiteColor];
    [mainStack addArrangedSubview:titleLabel];

    // --- سۆشیاڵ میدیا ---
    UIStackView *socialStack = [[UIStackView alloc] init];
    socialStack.axis = UILayoutConstraintAxisVertical;
    socialStack.spacing = 16;
    socialStack.distribution = UIStackViewDistributionFillEqually;
    socialStack.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:socialStack];

    [NSLayoutConstraint activateConstraints:@[
        [socialStack.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    // دروستکردنی دوگمەکان
    UIButton *tgBtn = [self createSocialButtonWithTitle:@"Telegram" color:[UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0] imageUrl:@"https://img.icons8.com/color/96/telegram-app.png" action:@selector(openTelegram)];
    UIButton *ttBtn = [self createSocialButtonWithTitle:@"TikTok" color:[UIColor whiteColor] imageUrl:@"https://img.icons8.com/fluent/96/tiktok.png" action:@selector(openTikTok)];
    UIButton *webBtn = [self createSocialButtonWithTitle:@"Website" color:[UIColor colorWithRed:0.8 green:0.4 blue:1.0 alpha:1.0] imageUrl:@"https://img.icons8.com/fluency/96/web.png" action:@selector(openWebsite)];

    [socialStack addArrangedSubview:tgBtn];
    [socialStack addArrangedSubview:ttBtn];
    [socialStack addArrangedSubview:webBtn];

    // --- دوگمەی دەستپێکرن (Get Started بە سێبەر و ستایلی Capsule) ---
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.1 green:0.45 blue:0.95 alpha:1.0]; // شینێکی زۆر تایبەت
    closeBtn.layer.cornerRadius = 30; // شێوەی کەپسول (نیوەی بەرزییەکەی)
    [closeBtn setTitle:@"Get Started" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // زیادکردنی سێبەر بۆ دوگمەی سەرەکی
    closeBtn.layer.shadowColor = [UIColor colorWithRed:0.1 green:0.45 blue:0.95 alpha:1.0].CGColor;
    closeBtn.layer.shadowOpacity = 0.4;
    closeBtn.layer.shadowOffset = CGSizeMake(0, 5);
    closeBtn.layer.shadowRadius = 12;

    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor],
        [closeBtn.heightAnchor constraintEqualToConstant:60]
    ]];
}

// فەنکشنی دروستکردنی دوگمەی سۆشیاڵ میدیا بێ کێشە
- (UIButton *)createSocialButtonWithTitle:(NSString *)title color:(UIColor *)color imageUrl:(NSString *)imageUrl action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1]; // ڕوونتر
    btn.layer.cornerRadius = 18;
    
    // چوارچێوەیەکی زۆر تەنکی مۆدێرن بۆ جوانی
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.axis = UILayoutConstraintAxisHorizontal;
    contentStack.spacing = 14;
    contentStack.alignment = UIStackViewAlignmentCenter;
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    contentStack.userInteractionEnabled = NO;
    [btn addSubview:contentStack];
    
    [NSLayoutConstraint activateConstraints:@[
        [contentStack.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor],
        [contentStack.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
        [contentStack.heightAnchor constraintEqualToConstant:32]
    ]];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentStack addArrangedSubview:iconView];
    
    [NSLayoutConstraint activateConstraints:@[
        [iconView.widthAnchor constraintEqualToConstant:26],
        [iconView.heightAnchor constraintEqualToConstant:26]
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
    label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold]; // فۆنتی دوگمەکانم ئەستوورتر کرد
    [contentStack addArrangedSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [btn.heightAnchor constraintEqualToConstant:58]
    ]];
    return btn;
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

- (void)closeTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

// ------------------------------------------------------------------
// بەشێ ئینجێکتکرنێ 
// ------------------------------------------------------------------
__attribute__((constructor)) static void showCustomWelcomeScreen() {
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
