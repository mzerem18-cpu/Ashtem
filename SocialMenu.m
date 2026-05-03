#import <UIKit/UIKit.h>

// --- دیزاینی مۆدێرن و سەلامەت بۆ AshteMobile ---
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
    
    // شاشەکە بەتەواوی بێ سنوور دەکەین
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;

    // باکگراوندی تەڵخی مۆدێرن (Dark Blur)
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurView];

    // دروستکردنی کارتی شوشەیی (Dark Glass Card) - زۆر پڕۆفیشناڵتر
    self.glassCard = [[UIView alloc] init];
    self.glassCard.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.45]; // ڕەشییەکی شوشەیی جوان
    self.glassCard.layer.cornerRadius = 35;
    self.glassCard.layer.borderWidth = 1.0;
    self.glassCard.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
    self.glassCard.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.glassCard];
    
    self.glassCard.alpha = 0;

    [NSLayoutConstraint activateConstraints:@[
        [self.glassCard.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.glassCard.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.glassCard.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.88]
    ]];

    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 25;
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.glassCard addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor constant:30],
        [mainStack.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor constant:-30],
        [mainStack.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor constant:20],
        [mainStack.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor constant:-20]
    ]];

    // --- لۆگۆی کەسی ---
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 40; 
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
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

    // --- تایتڵ بە فۆنتێکی ئەستوورتر و جوانتر ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile";
    titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightBlack];
    titleLabel.textColor = [UIColor whiteColor];
    [mainStack addArrangedSubview:titleLabel];

    // --- سۆشیاڵ میدیا ---
    UIStackView *rowStack = [[UIStackView alloc] init];
    rowStack.axis = UILayoutConstraintAxisHorizontal;
    rowStack.spacing = 15;
    [mainStack addArrangedSubview:rowStack];

    // ڕەنگەکانم گۆڕیوە بۆ ڕەنگی ئۆرجیناڵی ئەپەکان
    UIButton *tgBtn = [self createModernButton:@"Telegram" color:[UIColor colorWithRed:0.15 green:0.65 blue:0.90 alpha:1.0] action:@selector(openTelegram)];
    UIButton *ttBtn = [self createModernButton:@"TikTok" color:[UIColor colorWithWhite:0.1 alpha:1.0] action:@selector(openTikTok)];
    
    [rowStack addArrangedSubview:tgBtn];
    [rowStack addArrangedSubview:ttBtn];

    UIButton *webBtn = [self createModernButton:@"Visit Website" color:[UIColor colorWithRed:0.95 green:0.2 blue:0.4 alpha:1.0] action:@selector(openWebsite)];
    [mainStack addArrangedSubview:webBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [webBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    // --- دوگمەی Get Started (سپی بە تێکستی ڕەش، زۆر شازە) ---
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor whiteColor];
    closeBtn.layer.cornerRadius = 20;
    [closeBtn setTitle:@"Get Started ➔" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightHeavy];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor multiplier:0.9],
        [closeBtn.heightAnchor constraintEqualToConstant:55]
    ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.glassCard.alpha = 1.0;
    }];
}

- (UIButton *)createModernButton:(NSString *)title color:(UIColor *)color action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 18;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [NSLayoutConstraint activateConstraints:@[
        [btn.heightAnchor constraintEqualToConstant:50],
        [btn.widthAnchor constraintGreaterThanOrEqualToConstant:120]
    ]];
    
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
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end

// --- بەشی ئینجێکتکردن ---
__attribute__((constructor)) static void showCustomWelcomeScreen() {
    // تێبینی: لێرەدا وشەی ئێرۆرەکە (Nonnull) سڕایەوە بۆ ئەوەی بێ کێشە بێت
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
