#import <UIKit/UIKit.h>

// --- دیزاینی مۆدێرن و شاهانە بۆ ئەشتە مۆبایل ---
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
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    // ١. باکگراوندی تەڵخی مۆدێرن
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurView];

    // ٢. دروستکردنی کارتی شوشەیی (Glass Card)
    self.glassCard = [[UIView alloc] init];
    self.glassCard.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.glassCard.layer.cornerRadius = 35;
    self.glassCard.layer.borderWidth = 1.0;
    self.glassCard.layer.borderColor = [UIColor colorWithRed:0.85 green:0.75 blue:0.3 alpha:0.4].CGColor; // هێڵی زێڕین
    self.glassCard.translatesAutoresizingMaskIntoConstraints = NO;
    
    // سێبەری کارتەکە
    self.glassCard.layer.shadowColor = [UIColor blackColor].CGColor;
    self.glassCard.layer.shadowOpacity = 0.3;
    self.glassCard.layer.shadowOffset = CGSizeMake(0, 10);
    self.glassCard.layer.shadowRadius = 20;
    
    [self.view addSubview:self.glassCard];
    
    // ئامادەکردنی کارتەکە بۆ ئەنیمەیشن
    self.glassCard.transform = CGAffineTransformMakeTranslation(0, 300);
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
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/4K8boi7.jpeg"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });

    // --- تایتڵ ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile";
    titleLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightHeavy];
    titleLabel.textColor = [UIColor whiteColor];
    [mainStack addArrangedSubview:titleLabel];

    // --- دوگمەکان ---
    UIStackView *rowStack = [[UIStackView alloc] init];
    rowStack.axis = UILayoutConstraintAxisHorizontal;
    rowStack.spacing = 15;
    [mainStack addArrangedSubview:rowStack];

    UIButton *tgBtn = [self createModernButton:@"Telegram" color:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] icon:@"paperplane.fill" action:@selector(openTelegram)];
    UIButton *ttBtn = [self createModernButton:@"TikTok" color:[UIColor whiteColor] icon:@"music.note" action:@selector(openTikTok)];
    
    [rowStack addArrangedSubview:tgBtn];
    [rowStack addArrangedSubview:ttBtn];

    UIButton *webBtn = [self createModernButton:@"Visit Website" color:[UIColor colorWithRed:0.9 green:0.2 blue:0.4 alpha:1.0] icon:@"safari.fill" action:@selector(openWebsite)];
    [mainStack addArrangedSubview:webBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [webBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    // --- دوگمەی Get Started ---
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.45 blue:0.9 alpha:1.0];
    closeBtn.layer.cornerRadius = 20;
    [closeBtn setTitle:@"Get Started ➔" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor multiplier:0.9],
        [closeBtn.heightAnchor constraintEqualToConstant:55]
    ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // ئەنیمەیشنی دەرکەوتن
    [UIView animateWithDuration:0.7 delay:0.1 usingSpringWithDamping:0.75 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.glassCard.transform = CGAffineTransformIdentity;
        self.glassCard.alpha = 1.0;
    } completion:nil];
}

- (UIButton *)createModernButton:(NSString *)title color:(UIColor *)color icon:(NSString *)icon action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.12];
    btn.layer.cornerRadius = 18;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 8;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.userInteractionEnabled = NO;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addSubview:stack];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:icon]];
    imgView.tintColor = color;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [stack addArrangedSubview:imgView];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = title;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [stack addArrangedSubview:lbl];
    
    [NSLayoutConstraint activateConstraints:@[
        [stack.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor],
        [stack.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
        [imgView.widthAnchor constraintEqualToConstant:20],
        [imgView.heightAnchor constraintEqualToConstant:20],
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
    [UIView animateWithDuration:0.4 animations:^{
        self.glassCard.transform = CGAffineTransformMakeTranslation(0, 500);
        self.glassCard.alpha = 0;
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end

// --- بەشی ئینجێکتکردن ---
__attribute__((constructor)) static void showCustomWelcomeScreen() {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
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
                    [topController presentViewController:welcomeVC animated:NO completion:nil];
                }
            });
        });
    }];
}
