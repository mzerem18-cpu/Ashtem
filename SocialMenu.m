#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> // زیادکراوە بۆ ئەنیمەیشنی لۆگۆکە بەبێ ئێرۆر

@interface AshteWelcomeViewController : UIViewController
@property (nonatomic, strong) UIView *glassCard;
- (void)openTelegram;
- (void)openTikTok;
- (void)openWebsite;
- (void)closeTapped;
- (void)playHaptic;
- (void)loadAndCacheImage:(NSString *)urlStr forImageView:(UIImageView *)imgView;
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurView];

    self.glassCard = [[UIView alloc] init];
    self.glassCard.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.09 alpha:0.85];
    self.glassCard.layer.cornerRadius = 24;
    self.glassCard.layer.borderWidth = 1.0;
    self.glassCard.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    self.glassCard.translatesAutoresizingMaskIntoConstraints = NO;
    self.glassCard.alpha = 0; 
    
    [self.view addSubview:self.glassCard];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.glassCard.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.glassCard.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.glassCard.widthAnchor constraintEqualToConstant:320]
    ]];

    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 20;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.glassCard addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor constant:24],
        [mainStack.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor constant:-24],
        [mainStack.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor constant:24],
        [mainStack.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor constant:-24]
    ]];

    // --- هێدەر ---
    UIStackView *headerStack = [[UIStackView alloc] init];
    headerStack.axis = UILayoutConstraintAxisHorizontal;
    headerStack.spacing = 15;
    headerStack.alignment = UIStackViewAlignmentCenter;
    [mainStack addArrangedSubview:headerStack];

    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    logoView.layer.cornerRadius = 22; 
    logoView.clipsToBounds = YES;
    logoView.layer.borderWidth = 1.5;
    logoView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [headerStack addArrangedSubview:logoView];

    [NSLayoutConstraint activateConstraints:@[
        [logoView.widthAnchor constraintEqualToConstant:44],
        [logoView.heightAnchor constraintEqualToConstant:44]
    ]];

    // هێنانی لۆگۆی خۆت بە سیستەمی کاش
    [self loadAndCacheImage:@"https://ashtemobile.tututweak.com/a.png" forImageView:logoView];

    // === ئەنیمەیشنی (لێدانی دڵ) تەنها بۆ لۆگۆکەت ===
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = 1.2; // خێرایی گەورەبوونەکە
    pulseAnimation.toValue = @1.08; // کەمێک گەورە دەبێت
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES; // ئۆتۆماتیکی دەگەڕێتەوە باری خۆی
    pulseAnimation.repeatCount = HUGE_VALF; // بۆ هەمیشە و بێ وەستان دووبارە دەبێتەوە
    [logoView.layer addAnimation:pulseAnimation forKey:@"pulse"];
    // ===============================================

    UIStackView *titleStack = [[UIStackView alloc] init];
    titleStack.axis = UILayoutConstraintAxisVertical;
    titleStack.spacing = 2;
    [headerStack addArrangedSubview:titleStack];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile";
    titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor whiteColor];
    [titleStack addArrangedSubview:titleLabel];

    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = @"Premium Mod Menu";
    subLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    subLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [titleStack addArrangedSubview:subLabel];

    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    [divider.heightAnchor constraintEqualToConstant:1].active = YES;
    [mainStack addArrangedSubview:divider];

    // --- دوگمەی سۆشیاڵ میدیاکان ---
    UIStackView *socialStack = [[UIStackView alloc] init];
    socialStack.axis = UILayoutConstraintAxisHorizontal;
    socialStack.spacing = 15;
    socialStack.distribution = UIStackViewDistributionFillEqually;
    [mainStack addArrangedSubview:socialStack];

    UIButton *tgBtn = [self createSquareSocialButton:@"https://img.icons8.com/color/100/telegram-app.png" action:@selector(openTelegram)];
    UIButton *ttBtn = [self createSquareSocialButton:@"https://img.icons8.com/fluency/100/tiktok.png" action:@selector(openTikTok)];
    UIButton *webBtn = [self createSquareSocialButton:@"https://img.icons8.com/color/100/safari--v1.png" action:@selector(openWebsite)];

    [socialStack addArrangedSubview:tgBtn];
    [socialStack addArrangedSubview:ttBtn];
    [socialStack addArrangedSubview:webBtn];

    [socialStack.heightAnchor constraintEqualToConstant:55].active = YES;

    // --- دوگمەی Start Game ---
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn.backgroundColor = [UIColor whiteColor];
    startBtn.layer.cornerRadius = 14;
    [startBtn setTitle:@"Start Game" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [startBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:startBtn];

    [startBtn.heightAnchor constraintEqualToConstant:48].active = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.4 animations:^{
        self.glassCard.alpha = 1.0;
    }];
}

// سیستەمی خەزنکردن و خێراکردنی لۆگۆکان
- (void)loadAndCacheImage:(NSString *)urlStr forImageView:(UIImageView *)imgView {
    NSString *cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[urlStr lastPathComponent]];
    NSData *cachedData = [NSData dataWithContentsOfFile:cachePath];
    
    if (cachedData) {
        imgView.image = [UIImage imageWithData:cachedData];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            if (data) {
                [data writeToFile:cachePath atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView.image = [UIImage imageWithData:data];
                });
            }
        });
    }
}

- (UIButton *)createSquareSocialButton:(NSString *)url action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.06];
    btn.layer.cornerRadius = 14;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.05].CGColor;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    UIImageView *icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addSubview:icon];

    [NSLayoutConstraint activateConstraints:@[
        [icon.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor],
        [icon.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
        [icon.widthAnchor constraintEqualToConstant:28],
        [icon.heightAnchor constraintEqualToConstant:28]
    ]];

    [self loadAndCacheImage:url forImageView:icon];

    return btn;
}

- (void)playHaptic {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [gen impactOccurred];
}

- (void)openTelegram { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openTikTok { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tiktok.com/@ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openWebsite { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/"] options:@{} completionHandler:nil]; }

- (void)closeTapped {
    [self playHaptic];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end

// --- بەشی ئینجێکتکردن ---
__attribute__((constructor)) static void showCustomWelcomeScreen() {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIWindow *keyWindow = nil;
                for (UIWindow *window in [UIApplication sharedApplication].windows) {
                    if (window.isKeyWindow) { keyWindow = window; break; }
                }
                if (keyWindow && keyWindow.rootViewController) {
                    UIViewController *topController = keyWindow.rootViewController;
                    while (topController.presentedViewController) { topController = topController.presentedViewController; }
                    AshteWelcomeViewController *welcomeVC = [[AshteWelcomeViewController alloc] init];
                    
                    welcomeVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    
                    [topController presentViewController:welcomeVC animated:NO completion:nil];
                }
            });
        });
    }];
}
