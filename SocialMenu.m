#import <UIKit/UIKit.h>

// ------------------------------------------------------------------
// شاشەی بەخێرهاتنی مۆدێرن (Modern Glassmorphism Welcome Screen) بێ ڕیکلام
// ------------------------------------------------------------------

@interface AshteWelcomeViewController : UIViewController
@property (nonatomic, strong) UIView *cardView; // بۆ دروستکردنی کارتە شوشەییەکە
- (void)openTelegram;
- (void)openTikTok;
- (void)openWebsite;
- (void)closeTapped;
- (UIButton *)createSocialButtonWithTitle:(NSString *)title color:(UIColor *)color imageUrl:(NSString *)imageUrl action:(SEL)action;
- (void)playHaptic; // فەنکشنی لەرینەوەی مۆبایل
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    // باکگراوندی تەڵخ (Dark Blur)
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];

    // دروستکردنی کارتی مۆدێرن (Glass Card) لە ناوەڕاستی شاشەکە
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1]; // شوشەیی ڕووناک
    self.cardView.layer.cornerRadius = 35; // قەراخە خڕەکان
    self.cardView.layer.borderWidth = 1.0;
    self.cardView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.75 blue:0.3 alpha:0.4].CGColor; // هێڵێکی تەنکی زێڕین/شاهانە
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // سێبەری کارتەکە (Shadow)
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOpacity = 0.4;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 10);
    self.cardView.layer.shadowRadius = 20;
    
    // ئامادەکردنی بۆ ئەنیمەیشن (سەرەتا شاردراوەتەوە)
    self.cardView.alpha = 0.0;
    self.cardView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.view addSubview:self.cardView];

    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.cardView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.cardView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.88]
    ]];

    // ڕێکخستنی شتەکانی ناو کارتەکە
    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 25;
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:35],
        [mainStack.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-35],
        [mainStack.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:20],
        [mainStack.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-20]
    ]];

    // --- لۆگۆی کەسی ---
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 40; 
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    [mainStack addArrangedSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:80],
        [imageView.heightAnchor constraintEqualToConstant:80]
    ]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/a.png"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });

    // --- دەقی پێشوازی ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Welcome to\nAshteMobile";
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightHeavy];
    titleLabel.textColor = [UIColor whiteColor];
    [mainStack addArrangedSubview:titleLabel];

    // --- سۆشیاڵ میدیا ---
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

    // --- دوگمەی دەستپێکرن (Get Started) ---
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.9 alpha:1.0];
    closeBtn.layer.cornerRadius = 20;
    [closeBtn setTitle:@"Get Started" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    
    closeBtn.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.9 alpha:1.0].CGColor;
    closeBtn.layer.shadowOpacity = 0.5;
    closeBtn.layer.shadowOffset = CGSizeMake(0, 5);
    closeBtn.layer.shadowRadius = 10;
    
    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor],
        [closeBtn.heightAnchor constraintEqualToConstant:60]
    ]];
}

// پێکردنی ئەنیمەیشن کاتێک شاشەکە دەردەکەوێت
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.cardView.alpha = 1.0;
        self.cardView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

// فەنکشنی دروستکردنی دوگمە
- (UIButton *)createSocialButtonWithTitle:(NSString *)title color:(UIColor *)color imageUrl:(NSString *)imageUrl action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.12]; 
    btn.layer.cornerRadius = 18; 
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.axis = UILayoutConstraintAxisHorizontal;
    contentStack.spacing = 12;
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
    label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [contentStack addArrangedSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [btn.heightAnchor constraintEqualToConstant:58]
    ]];
    return btn;
}

// فەنکشنی لەرینەوە (Haptic Feedback)
- (void)playHaptic {
    UIImpactFeedbackGenerator *feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [feedback prepare];
    [feedback impactOccurred];
}

// کارکرنا لینکان لەگەڵ لەرینەوە
- (void)openTelegram {
    [self playHaptic];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil];
}

- (void)openTikTok {
    [self playHaptic];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tiktok.com/@ashtemobile"] options:@{} completionHandler:nil];
}

- (void)openWebsite {
    [self playHaptic];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/"] options:@{} completionHandler:nil];
}

- (void)closeTapped {
    [self playHaptic];
    [UIView animateWithDuration:0.3 animations:^{
        self.cardView.alpha = 0.0;
        self.cardView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end

// ------------------------------------------------------------------
// بەشێ ئینجێکتکرنێ بەبێ هیچ ڕیکلامێک
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
