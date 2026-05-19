#import <UIKit/UIKit.h>

@interface AshteWelcomeViewController : UIViewController
@property (nonatomic, strong) UIView *glassCard;
@property (nonatomic, strong) UIImageView *logoView; 
@property (nonatomic, strong) UIView *glowView;
- (void)openTelegram;
- (void)openTikTok;
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

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurView];

    self.glassCard = [[UIView alloc] init];
    self.glassCard.backgroundColor = [UIColor clearColor];
    self.glassCard.layer.cornerRadius = 36;
    self.glassCard.layer.borderWidth = 1.0;
    self.glassCard.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
    self.glassCard.clipsToBounds = YES; 
    self.glassCard.translatesAutoresizingMaskIntoConstraints = NO;
    self.glassCard.alpha = 0; 
    
    [self.view addSubview:self.glassCard];
    
    UIBlurEffect *cardBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent]; 
    UIVisualEffectView *cardBlurView = [[UIVisualEffectView alloc] initWithEffect:cardBlurEffect];
    cardBlurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.glassCard addSubview:cardBlurView];

    UIView *cardOverlay = [[UIView alloc] init];
    cardOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6]; 
    cardOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    [self.glassCard addSubview:cardOverlay];

    [NSLayoutConstraint activateConstraints:@[
        [self.glassCard.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.glassCard.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.glassCard.widthAnchor constraintEqualToConstant:320],
        
        [cardBlurView.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor],
        [cardBlurView.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor],
        [cardBlurView.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor],
        [cardBlurView.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor],
        
        [cardOverlay.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor],
        [cardOverlay.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor],
        [cardOverlay.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor],
        [cardOverlay.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor]
    ]];

    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 24;
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.glassCard addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor constant:30],
        [mainStack.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor constant:-30],
        [mainStack.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor constant:24],
        [mainStack.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor constant:-24]
    ]];

    // --- بەشی سەرەوە ---
    UIView *logoContainer = [[UIView alloc] init];
    logoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:logoContainer];
    
    [NSLayoutConstraint activateConstraints:@[
        [logoContainer.widthAnchor constraintEqualToConstant:72],
        [logoContainer.heightAnchor constraintEqualToConstant:72]
    ]];

    self.glowView = [[UIView alloc] init];
    self.glowView.backgroundColor = [UIColor systemBlueColor];
    self.glowView.layer.cornerRadius = 36;
    self.glowView.translatesAutoresizingMaskIntoConstraints = NO;
    self.glowView.layer.shadowColor = [UIColor systemBlueColor].CGColor;
    self.glowView.layer.shadowOffset = CGSizeMake(0, 0);
    self.glowView.layer.shadowRadius = 15;
    self.glowView.layer.shadowOpacity = 1.0;
    [logoContainer addSubview:self.glowView];

    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoView.layer.cornerRadius = 32; 
    self.logoView.clipsToBounds = YES;
    self.logoView.layer.borderWidth = 2.0;
    self.logoView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [logoContainer addSubview:self.logoView];

    [NSLayoutConstraint activateConstraints:@[
        [self.glowView.centerXAnchor constraintEqualToAnchor:logoContainer.centerXAnchor],
        [self.glowView.centerYAnchor constraintEqualToAnchor:logoContainer.centerYAnchor],
        [self.glowView.widthAnchor constraintEqualToConstant:64],
        [self.glowView.heightAnchor constraintEqualToConstant:64],
        
        [self.logoView.centerXAnchor constraintEqualToAnchor:logoContainer.centerXAnchor],
        [self.logoView.centerYAnchor constraintEqualToAnchor:logoContainer.centerYAnchor],
        [self.logoView.widthAnchor constraintEqualToConstant:64],
        [self.logoView.heightAnchor constraintEqualToConstant:64]
    ]];

    [self loadAndCacheImage:@"https://ashtemobile.tututweak.com/a.png" forImageView:self.logoView placeholder:@"person.circle.fill"];

    UIStackView *titleStack = [[UIStackView alloc] init];
    titleStack.axis = UILayoutConstraintAxisVertical;
    titleStack.spacing = 6;
    titleStack.alignment = UIStackViewAlignmentCenter;
    [mainStack addArrangedSubview:titleStack];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile FREE"; 
    titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBlack];
    titleLabel.textColor = [UIColor whiteColor];
    [titleStack addArrangedSubview:titleLabel];

    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = @"Premium iOS Experience";
    subLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    subLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    [titleStack addArrangedSubview:subLabel];

    // --- سۆشیاڵ میدیا ---
    UIStackView *dockStack = [[UIStackView alloc] init];
    dockStack.axis = UILayoutConstraintAxisHorizontal;
    dockStack.spacing = 20;
    dockStack.alignment = UIStackViewAlignmentCenter;
    dockStack.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:dockStack];

    UIButton *tgBtn = [self createCircleSocialButton:@"https://img.icons8.com/color/100/telegram-app.png" placeholder:@"paperplane.fill" action:@selector(openTelegram)];
    UIButton *webBtn = [self createCircleSocialButton:@"https://img.icons8.com/color/100/safari--v1.png" placeholder:@"safari.fill" action:@selector(openWebsite)];
    UIButton *ttBtn = [self createCircleSocialButton:@"https://img.icons8.com/fluency/100/tiktok.png" placeholder:@"play.tv.fill" action:@selector(openTikTok)];

    [dockStack addArrangedSubview:tgBtn];
    [dockStack addArrangedSubview:webBtn];
    [dockStack addArrangedSubview:ttBtn];

    // --- دوگمەی کراوە و ئاسایی (OPEN) ---
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn.backgroundColor = [UIColor systemBlueColor];
    startBtn.layer.cornerRadius = 24; 
    [startBtn setTitle:@"OPEN" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
    
    startBtn.layer.shadowColor = [UIColor systemBlueColor].CGColor;
    startBtn.layer.shadowOffset = CGSizeMake(0, 0);
    startBtn.layer.shadowRadius = 8;
    startBtn.layer.shadowOpacity = 0.6;
    
    [startBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:startBtn];

    [NSLayoutConstraint activateConstraints:@[
        [startBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor],
        [startBtn.heightAnchor constraintEqualToConstant:48]
    ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.glassCard.alpha = 1.0;
    } completion:nil];
    
    [UIView animateWithDuration:1.5
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.glowView.alpha = 0.2; 
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

- (UIButton *)createCircleSocialButton:(NSString *)url placeholder:(NSString *)ph action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1]; 
    btn.layer.cornerRadius = 24; 
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    UIImageView *icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addSubview:icon];

    [NSLayoutConstraint activateConstraints:@[
        [btn.widthAnchor constraintEqualToConstant:48],
        [btn.heightAnchor constraintEqualToConstant:48],
        
        [icon.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor],
        [icon.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
        [icon.widthAnchor constraintEqualToConstant:26],
        [icon.heightAnchor constraintEqualToConstant:26]
    ]];

    [self loadAndCacheImage:url forImageView:icon placeholder:ph];

    return btn;
}

- (void)playHaptic {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [gen impactOccurred];
}

- (void)openTelegram { 
    [self playHaptic]; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil]; 
}

- (void)openWebsite { 
    [self playHaptic]; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ashtemobile.site"] options:@{} completionHandler:nil]; 
}

- (void)openTikTok { 
    [self playHaptic]; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tiktok.com/@ashtemobile"] options:@{} completionHandler:nil]; 
}

- (void)closeTapped {
    [self playHaptic];
    
    // ڕاستەوخۆ دادەخرێت بەبێ هیچ مەرجێک
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
