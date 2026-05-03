#import <UIKit/UIKit.h>

// --- دیزاینی پڕۆفیشناڵ بە گونجان بۆ بەرنامە (درێژی) و یاری (پانی) ---
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
    
    // شاشەکە بەتەواوی بێ سنوور
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;

    // باکگراوندی تەڵخی مۆدێرن (Dark Blur)
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurView];

    // دروستکردنی کارتی سەرەکی بە ستایلی (Premium Glass)
    self.glassCard = [[UIView alloc] init];
    self.glassCard.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.65];
    self.glassCard.layer.cornerRadius = 35;
    self.glassCard.layer.borderWidth = 1.0;
    self.glassCard.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    self.glassCard.translatesAutoresizingMaskIntoConstraints = NO;
    self.glassCard.alpha = 0;
    
    [self.view addSubview:self.glassCard];

    // --- لێرەدایە چارەسەری کێشەی (بەرنامە و یاری) ---
    NSLayoutConstraint *widthConstraint = [self.glassCard.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.90];
    widthConstraint.priority = UILayoutPriorityDefaultHigh; // ڕێگە دەدات ئۆتۆماتیکی بێت
    
    [NSLayoutConstraint activateConstraints:@[
        [self.glassCard.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.glassCard.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        
        // لە بەرنامەکان ٩٠٪ی شاشەیە، بەڵام لە یارییەکان ڕێگری دەکات زۆر پان بێت
        widthConstraint,
        [self.glassCard.widthAnchor constraintLessThanOrEqualToConstant:420],
        
        // لە یارییەکان ڕێگری دەکات کارتەکە لە شاشەکە دەربچێت
        [self.glassCard.heightAnchor constraintLessThanOrEqualToAnchor:self.view.heightAnchor multiplier:0.85]
    ]];

    // --- دانانی سکڕۆڵ بۆ ئەوەی لە یارییەکاندا نەبڕێت ---
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.showsVerticalScrollIndicator = NO;
    [self.glassCard addSubview:scroll];

    [NSLayoutConstraint activateConstraints:@[
        [scroll.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor],
        [scroll.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor]
    ]];

    // ڕیزکردنی ناوەڕۆک لەناو سکڕۆڵەکەدا
    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 25;
    mainStack.alignment = UIStackViewAlignmentFill;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [scroll addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:scroll.topAnchor constant:30],
        [mainStack.bottomAnchor constraintEqualToAnchor:scroll.bottomAnchor constant:-30],
        [mainStack.leadingAnchor constraintEqualToAnchor:scroll.leadingAnchor constant:20],
        [mainStack.trailingAnchor constraintEqualToAnchor:scroll.trailingAnchor constant:-20],
        [mainStack.widthAnchor constraintEqualToAnchor:scroll.widthAnchor constant:-40] // بۆشایی تەنیشتەکان
    ]];

    // --- بەشی هێدەر (لۆگۆ و تایتڵ) ---
    UIStackView *headerStack = [[UIStackView alloc] init];
    headerStack.axis = UILayoutConstraintAxisVertical;
    headerStack.spacing = 10;
    headerStack.alignment = UIStackViewAlignmentCenter;
    [mainStack addArrangedSubview:headerStack];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 45; 
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    [headerStack addArrangedSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:90],
        [imageView.heightAnchor constraintEqualToConstant:90]
    ]];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/a.png"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{ imageView.image = [UIImage imageWithData:data]; });
        }
    });

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile";
    titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBlack];
    titleLabel.textColor = [UIColor whiteColor];
    [headerStack addArrangedSubview:titleLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"Premium Mod Menu";
    subtitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    subtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [headerStack addArrangedSubview:subtitleLabel];

    // --- بەشی دوگمەکان (لۆگۆی ڕەسەن) ---
    UIStackView *buttonsStack = [[UIStackView alloc] init];
    buttonsStack.axis = UILayoutConstraintAxisVertical;
    buttonsStack.spacing = 12;
    [mainStack addArrangedSubview:buttonsStack];

    UIView *tgBtn = [self createPremiumSocialButton:@"Official Telegram" iconURL:@"https://img.icons8.com/color/512/telegram-app.png" action:@selector(openTelegram)];
    UIView *ttBtn = [self createPremiumSocialButton:@"Follow on TikTok" iconURL:@"https://img.icons8.com/color/512/tiktok.png" action:@selector(openTikTok)];
    UIView *webBtn = [self createPremiumSocialButton:@"Visit Website" iconURL:@"https://img.icons8.com/color/512/safari.png" action:@selector(openWebsite)];
    
    [buttonsStack addArrangedSubview:tgBtn];
    [buttonsStack addArrangedSubview:ttBtn];
    [buttonsStack addArrangedSubview:webBtn];

    // --- دوگمەی داخستن (Start Game) ---
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor whiteColor];
    closeBtn.layer.cornerRadius = 20;
    [closeBtn setTitle:@"Start Game" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.heightAnchor constraintEqualToConstant:55]
    ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.4 animations:^{
        self.glassCard.alpha = 1.0;
    }];
}

// فەنکشنی دروستکردنی دوگمەی پڕۆفیشناڵ لەگەڵ لۆگۆی ڕەسەن
- (UIView *)createPremiumSocialButton:(NSString *)title iconURL:(NSString *)url action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    btn.layer.cornerRadius = 18;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn.heightAnchor constraintEqualToConstant:60].active = YES;

    // لۆگۆی ڕەسەن
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addSubview:iconView];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if(d) {
            dispatch_async(dispatch_get_main_queue(), ^{
                iconView.image = [UIImage imageWithData:d];
            });
        }
    });

    // تێکستی دوگمەکە
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = title;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    lbl.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addSubview:lbl];

    // تیری لای ڕاست
    UIImageView *chevron = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right"]];
    chevron.tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    chevron.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addSubview:chevron];

    [NSLayoutConstraint activateConstraints:@[
        [iconView.leadingAnchor constraintEqualToAnchor:btn.leadingAnchor constant:18],
        [iconView.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
        [iconView.widthAnchor constraintEqualToConstant:28],
        [iconView.heightAnchor constraintEqualToConstant:28],

        [lbl.leadingAnchor constraintEqualToAnchor:iconView.trailingAnchor constant:15],
        [lbl.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],

        [chevron.trailingAnchor constraintEqualToAnchor:btn.trailingAnchor constant:-18],
        [chevron.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
        [chevron.widthAnchor constraintEqualToConstant:14],
        [chevron.heightAnchor constraintEqualToConstant:14]
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
