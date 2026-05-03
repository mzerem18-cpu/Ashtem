#import <UIKit/UIKit.h>

@interface AshteWelcomeViewController : UIViewController
@property (nonatomic, strong) UIView *glassCard;
- (void)openTelegram;
- (void)openTikTok;
- (void)openWebsite;
- (void)closeTapped;
- (void)playHaptic;
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
    self.glassCard.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.12];
    self.glassCard.layer.cornerRadius = 20;
    self.glassCard.layer.borderWidth = 1.0;
    self.glassCard.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    self.glassCard.translatesAutoresizingMaskIntoConstraints = NO;
    self.glassCard.alpha = 0;
    
    [self.view addSubview:self.glassCard];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.glassCard.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.glassCard.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.glassCard.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.85],
        [self.glassCard.widthAnchor constraintLessThanOrEqualToConstant:320] // قەبارەی گونجاو بۆ یاری
    ]];

    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 10;
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.glassCard addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor constant:15],
        [mainStack.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor constant:-15],
        [mainStack.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor constant:20],
        [mainStack.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor constant:-20]
    ]];

    // --- لۆگۆی کەسی ---
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 25; 
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [mainStack addArrangedSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:50],
        [imageView.heightAnchor constraintEqualToConstant:50]
    ]];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/a.png"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });

    // --- تایتڵ ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile";
    titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightHeavy];
    titleLabel.textColor = [UIColor whiteColor];
    [mainStack addArrangedSubview:titleLabel];

    // --- سۆشیاڵ میدیا و وێبسایت بە لۆگۆوە لەژێر یەکتر ---
    UIStackView *buttonsStack = [[UIStackView alloc] init];
    buttonsStack.axis = UILayoutConstraintAxisVertical;
    buttonsStack.spacing = 8; // بۆشایی کەم بۆ ئەوەی جێی بێتەوە
    buttonsStack.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:buttonsStack];
    
    [NSLayoutConstraint activateConstraints:@[
        [buttonsStack.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    UIButton *tgBtn = [self createIconButton:@"Telegram" iconURL:@"https://img.icons8.com/color/100/telegram-app.png" color:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.8] action:@selector(openTelegram)];
    UIButton *ttBtn = [self createIconButton:@"TikTok" iconURL:@"https://img.icons8.com/fluency/100/tiktok.png" color:[UIColor colorWithWhite:0.3 alpha:0.9] action:@selector(openTikTok)];
    UIButton *webBtn = [self createIconButton:@"Website" iconURL:@"https://img.icons8.com/color/100/domain--v1.png" color:[UIColor colorWithRed:0.9 green:0.2 blue:0.4 alpha:0.8] action:@selector(openWebsite)];
    
    [buttonsStack addArrangedSubview:tgBtn];
    [buttonsStack addArrangedSubview:ttBtn];
    [buttonsStack addArrangedSubview:webBtn];

    // --- دوگمەی Get Started ---
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.45 blue:0.9 alpha:1.0];
    closeBtn.layer.cornerRadius = 16;
    [closeBtn setTitle:@"Get Started ➔" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor],
        [closeBtn.heightAnchor constraintEqualToConstant:42]
    ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.4 animations:^{
        self.glassCard.alpha = 1.0;
    }];
}

// فەنکشنی نوێ بۆ دروستکردنی دوگمە بە لۆگۆ و ناوی سپییەوە
- (UIButton *)createIconButton:(NSString *)title iconURL:(NSString *)url color:(UIColor *)bgColor action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = bgColor;
    btn.layer.cornerRadius = 14;
    
    // تێکستی سپی بۆ هەموویان
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [NSLayoutConstraint activateConstraints:@[
        [btn.heightAnchor constraintEqualToConstant:38] // بەرزییەکی زۆر گونجاو
    ]];
    
    // هێنانی لۆگۆکە
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (d) {
            UIImage *img = [UIImage imageWithData:d];
            // قەبارەی لۆگۆکە ڕێکدەخەین
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 22), NO, 0.0);
            [img drawInRect:CGRectMake(0, 0, 22, 22)];
            UIImage *resizedImg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setImage:[resizedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                // بۆشایی خستنە نێوان لۆگۆکە و ناوەکە
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            });
        }
    });
    
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
    [UIView animateWithDuration:0.3 animations:^{ self.view.alpha = 0; } completion:^(BOOL finished) {
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
