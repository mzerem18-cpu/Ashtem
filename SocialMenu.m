#import <UIKit/UIKit.h>

@interface AshteWelcomeViewController : UIViewController
@property (nonatomic, strong) UIView *glassCard;
@property (nonatomic, strong) UIImageView *logoView; 
- (void)openTelegram;
- (void)openSecondTelegram;
- (void)openWebsite;
- (void)closeTapped;
- (void)playHaptic;
- (void)loadAndCacheImage:(NSString *)urlStr forImageView:(UIImageView *)imgView placeholder:(NSString *)sysName;
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;

    // باکگراوندی تەڵخی سەرتاسەری
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurView];

    // کارتی سەرەکی (پڕۆفیشناڵ و مۆدێرن)
    self.glassCard = [[UIView alloc] init];
    self.glassCard.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.06 alpha:0.75];
    self.glassCard.layer.cornerRadius = 32; // خڕکردنی زیاتر بۆ ستایلی نوێ
    self.glassCard.layer.borderWidth = 1.0;
    self.glassCard.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
    self.glassCard.translatesAutoresizingMaskIntoConstraints = NO;
    self.glassCard.alpha = 0; 
    
    // سێبەری کارتەکە
    self.glassCard.layer.shadowColor = [UIColor blackColor].CGColor;
    self.glassCard.layer.shadowOffset = CGSizeMake(0, 10);
    self.glassCard.layer.shadowRadius = 20;
    self.glassCard.layer.shadowOpacity = 0.5;

    [self.view addSubview:self.glassCard];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.glassCard.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.glassCard.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.glassCard.widthAnchor constraintEqualToConstant:320]
    ]];

    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 22;
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.glassCard addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor constant:28],
        [mainStack.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor constant:-28],
        [mainStack.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor constant:20],
        [mainStack.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor constant:-20]
    ]];

    // --- بەشی سەرەوە (لۆگۆ و ناو) ---
    UIView *logoContainer = [[UIView alloc] init];
    logoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:logoContainer];
    
    [NSLayoutConstraint activateConstraints:@[
        [logoContainer.widthAnchor constraintEqualToConstant:64],
        [logoContainer.heightAnchor constraintEqualToConstant:64]
    ]];

    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoView.layer.cornerRadius = 32; 
    self.logoView.clipsToBounds = YES;
    self.logoView.layer.borderWidth = 2.0;
    self.logoView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    self.logoView.frame = CGRectMake(0, 0, 64, 64); 
    [logoContainer addSubview:self.logoView];

    [self loadAndCacheImage:@"https://ashtemobile.tututweak.com/a.png" forImageView:self.logoView placeholder:@"person.circle.fill"];

    UIStackView *titleStack = [[UIStackView alloc] init];
    titleStack.axis = UILayoutConstraintAxisVertical;
    titleStack.spacing = 4;
    titleStack.alignment = UIStackViewAlignmentCenter;
    [mainStack addArrangedSubview:titleStack];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile FREE"; 
    titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBlack];
    titleLabel.textColor = [UIColor whiteColor];
    [titleStack addArrangedSubview:titleLabel];

    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = @"Premium Mod Menu";
    subLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    subLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [titleStack addArrangedSubview:subLabel];

    // --- ناوچەی (Floating Dock) بۆ سۆشیاڵ میدیاکان ---
    UIView *dockView = [[UIView alloc] init];
    dockView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    dockView.layer.cornerRadius = 24; // شێوەی حەب (Pill shape)
    dockView.layer.borderWidth = 1.0;
    dockView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.05].CGColor;
    dockView.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:dockView];

    UIStackView *dockStack = [[UIStackView alloc] init];
    dockStack.axis = UILayoutConstraintAxisHorizontal;
    dockStack.spacing = 15;
    dockStack.alignment = UIStackViewAlignmentCenter;
    dockStack.translatesAutoresizingMaskIntoConstraints = NO;
    [dockView addSubview:dockStack];

    [NSLayoutConstraint activateConstraints:@[
        [dockStack.topAnchor constraintEqualToAnchor:dockView.topAnchor constant:10],
        [dockStack.bottomAnchor constraintEqualToAnchor:dockView.bottomAnchor constant:-10],
        [dockStack.leadingAnchor constraintEqualToAnchor:dockView.leadingAnchor constant:20],
        [dockStack.trailingAnchor constraintEqualToAnchor:dockView.trailingAnchor constant:-20]
    ]];

    // دروستکردنی دوگمەکان (تێلیگرام، وێبسایت، تێلیگرام)
    UIButton *tgBtn1 = [self createDockButton:@"https://img.icons8.com/color/100/telegram-app.png" placeholder:@"paperplane.fill" action:@selector(openTelegram)];
    UIButton *webBtn = [self createDockButton:@"https://img.icons8.com/color/100/safari--v1.png" placeholder:@"safari.fill" action:@selector(openWebsite)];
    UIButton *tgBtn2 = [self createDockButton:@"https://img.icons8.com/color/100/telegram-app.png" placeholder:@"paperplane.fill" action:@selector(openSecondTelegram)];

    [dockStack addArrangedSubview:tgBtn1];
    [dockStack addArrangedSubview:webBtn];
    [dockStack addArrangedSubview:tgBtn2];

    // --- دوگمەی Start Game ---
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn.backgroundColor = [UIColor whiteColor];
    startBtn.layer.cornerRadius = 20; // خڕتر بۆ جوانی
    [startBtn setTitle:@"Start Game" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
    
    // سێبەری سپی بۆ دوگمەکە
    startBtn.layer.shadowColor = [UIColor whiteColor].CGColor;
    startBtn.layer.shadowOffset = CGSizeMake(0, 0);
    startBtn.layer.shadowRadius = 8;
    startBtn.layer.shadowOpacity = 0.3;
    
    [startBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:startBtn];

    [NSLayoutConstraint activateConstraints:@[
        [startBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor],
        [startBtn.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // ئەنیمەیشنی هاتنە ژوورەوە وەک نەرمەزەنجیر (Spring)
    self.glassCard.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.glassCard.alpha = 1.0;
        self.glassCard.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    // ئەنیمەیشنی (لێدانی دڵ) بۆ لۆگۆکە وەک خۆی
    [UIView animateWithDuration:1.2
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.logoView.transform = CGAffineTransformMakeScale(1.08, 1.08);
                     } completion:nil];
}

- (void)loadAndCacheImage:(NSString *)urlStr forImageView:(UIImageView *)imgView placeholder:(NSString *)sysName {
    if (sysName) {
        imgView.image = [UIImage systemImageNamed:sysName];
        imgView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    }
    
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *safeName = [[urlStr componentsSeparatedByString:@"/"] lastObject];
    NSString *cachePath = [docDir stringByAppendingPathComponent:safeName];
    
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

// فەنکشنی نوێ بۆ دوگمەکانی ناو (Dock)
- (UIButton *)createDockButton:(NSString *)url placeholder:(NSString *)ph action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    UIImageView *icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addSubview:icon];

    [NSLayoutConstraint activateConstraints:@[
        [btn.widthAnchor constraintEqualToConstant:38],
        [btn.heightAnchor constraintEqualToConstant:38],
        
        [icon.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor],
        [icon.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
        [icon.widthAnchor constraintEqualToConstant:34],
        [icon.heightAnchor constraintEqualToConstant:34]
    ]];

    [self loadAndCacheImage:url forImageView:icon placeholder:ph];

    return btn;
}

- (void)playHaptic {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [gen impactOccurred];
}

// لینکی تێلیگرامی یەکەم
- (void)openTelegram { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil]; }

// لینکی وێبسایتە نوێیەکەت
- (void)openWebsite { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ashtemobile.site"] options:@{} completionHandler:nil]; }

// لینکی تێلیگرامی دووەم
- (void)openSecondTelegram { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil]; }

- (void)closeTapped {
    [self playHaptic];
    [UIView animateWithDuration:0.3 animations:^{
        self.glassCard.transform = CGAffineTransformMakeScale(0.8, 0.8);
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
