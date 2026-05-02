#import <UIKit/UIKit.h>

@interface AshteWelcomeViewController : UIViewController
- (void)openTelegram;
- (void)openTikTok;
- (void)openWebsite;
- (void)closeTapped;
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // باکگراوندی خاوێن وەک وێنەکە (لە لایت مۆد سپییە، لە دارک مۆد ڕەشە)
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.modalPresentationStyle = UIModalPresentationFullScreen;

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

    // --- لۆگۆی کەسی (وەک ئەپ بە چوارگۆشەی خڕ و سێبەرەوە) ---
    UIView *iconShadowContainer = [[UIView alloc] init];
    iconShadowContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    iconShadowContainer.layer.shadowOpacity = 0.15;
    iconShadowContainer.layer.shadowOffset = CGSizeMake(0, 8);
    iconShadowContainer.layer.shadowRadius = 15;
    [mainStack addArrangedSubview:iconShadowContainer];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 24; // خڕکردنی لێوارەکان وەک ئەپ
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
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/a.png"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });

    // --- دەقی پێشوازی (وەک وێنەکە) ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile";
    titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor labelColor];
    [mainStack addArrangedSubview:titleLabel];

    // --- سۆشیاڵ میدیا دوگمەکان (ڕێک وەک وێنەکە بریقەدار و خڕ) ---
    UIStackView *buttonsVStack = [[UIStackView alloc] init];
    buttonsVStack.axis = UILayoutConstraintAxisVertical;
    buttonsVStack.spacing = 15;
    buttonsVStack.alignment = UIStackViewAlignmentCenter;
    [mainStack addArrangedSubview:buttonsVStack];

    UIStackView *topHStack = [[UIStackView alloc] init];
    topHStack.axis = UILayoutConstraintAxisHorizontal;
    topHStack.spacing = 15;
    [buttonsVStack addArrangedSubview:topHStack];

    // ١. دوگمەی تێلیگرام
    UIButton *tgBtn = [self createPillButton:@"Telegram"
                                       color:[UIColor colorWithRed:0.0 green:0.55 blue:1.0 alpha:1.0]
                                    iconName:@"paperplane.fill" // ئایکۆنی ناوەکی ئەپڵ
                                     urlIcon:nil
                                      action:@selector(openTelegram)];

    // ٢. دوگمەی تیکتۆک (لە تەنیشت تێلیگرام)
    UIButton *ttBtn = [self createPillButton:@"TikTok"
                                       color:[UIColor blackColor]
                                    iconName:nil
                                     urlIcon:@"https://img.icons8.com/ios-filled/100/ffffff/tiktok.png" // ئایکۆنی سپی
                                      action:@selector(openTikTok)];

    [topHStack addArrangedSubview:tgBtn];
    [topHStack addArrangedSubview:ttBtn];

    // ٣. دوگمەی وێبسایت (لە خوارەوەیان)
    UIButton *webBtn = [self createPillButton:@"Website"
                                       color:[UIColor colorWithRed:0.9 green:0.25 blue:0.45 alpha:1.0] // ڕەنگێکی جوانی سوور/پەمەیی
                                    iconName:@"safari.fill" // ئایکۆنی ناوەکی ئەپڵ
                                     urlIcon:nil
                                      action:@selector(openWebsite)];
    
    [buttonsVStack addArrangedSubview:webBtn];

    // --- بۆشایی و دوگمەی چوونە ناو ئەپ ---
    UIView *spacer = [[UIView alloc] init];
    [spacer.heightAnchor constraintEqualToConstant:20].active = YES;
    [mainStack addArrangedSubview:spacer];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"Continue to App ➔" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor systemGrayColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:closeBtn];
}

// فەنکشنی دروستکردنی دوگمەکانی وێنەکە (Pill Shape لەگەڵ Glow)
- (UIButton *)createPillButton:(NSString *)title color:(UIColor *)color iconName:(NSString *)iconName urlIcon:(NSString *)urlIcon action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 25; // Capsule shape

    // سێبەری ڕەنگاوڕەنگ وەک وێنەکە (Glow)
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
    iconView.tintColor = [UIColor whiteColor]; // ئایکۆنی سپی
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
    label.textColor = [UIColor whiteColor]; // دەقی سپی
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
- (void)closeTapped { [self dismissViewControllerAnimated:YES completion:nil]; }

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
