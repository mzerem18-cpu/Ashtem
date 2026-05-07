#import <UIKit/UIKit.h>

@interface AshteWelcomeViewController : UIViewController
@property (nonatomic, strong) UIView *glassCard;
@property (nonatomic, strong) UIImageView *logoView; 
- (void)openTelegram;
- (void)openSecondTelegram; // تێلیگرامی دووەم
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

    UIView *logoContainer = [[UIView alloc] init];
    logoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [headerStack addArrangedSubview:logoContainer];
    [NSLayoutConstraint activateConstraints:@[
        [logoContainer.widthAnchor constraintEqualToConstant:48],
        [logoContainer.heightAnchor constraintEqualToConstant:48]
    ]];

    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoView.layer.cornerRadius = 22; 
    self.logoView.clipsToBounds = YES;
    self.logoView.layer.borderWidth = 1.5;
    self.logoView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    self.logoView.frame = CGRectMake(2, 2, 44, 44); 
    [logoContainer addSubview:self.logoView];

    [self loadAndCacheImage:@"https://raw.githubusercontent.com/kurd4u1/serverfree/refs/heads/main/KURD4U_App.png" forImageView:self.logoView placeholder:@"person.circle.fill"];

    UIStackView *titleStack = [[UIStackView alloc] init];
    titleStack.axis = UILayoutConstraintAxisVertical;
    titleStack.spacing = 2;
    [headerStack addArrangedSubview:titleStack];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Kurd4U"; 
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

    // دروستکردنی دوگمەکان
    UIButton *tgBtn1 = [self createSquareSocialButton:@"https://img.icons8.com/color/100/telegram-app.png" placeholder:@"paperplane.fill" action:@selector(openTelegram)];
    UIButton *webBtn = [self createSquareSocialButton:@"https://img.icons8.com/color/100/safari--v1.png" placeholder:@"safari.fill" action:@selector(openWebsite)];
    UIButton *tgBtn2 = [self createSquareSocialButton:@"https://img.icons8.com/color/100/telegram-app.png" placeholder:@"paperplane.fill" action:@selector(openSecondTelegram)];

    // ڕیزکردن بەپێی داواکارییەکەت (تێلیگرام، وێبسایت، تێلیگرام)
    [socialStack addArrangedSubview:tgBtn1];
    [socialStack addArrangedSubview:webBtn];
    [socialStack addArrangedSubview:tgBtn2];

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
    
    [UIView animateWithDuration:1.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.logoView.frame = CGRectMake(0, 0, 48, 48);
                         self.logoView.layer.cornerRadius = 24;
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

- (UIButton *)createSquareSocialButton:(NSString *)url placeholder:(NSString *)ph action:(SEL)action {
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

    [self loadAndCacheImage:url forImageView:icon placeholder:ph];

    return btn;
}

- (void)playHaptic {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [gen impactOccurred];
}

// لینکی تێلیگرامی یەکەم
- (void)openTelegram { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/kurd4uapk"] options:@{} completionHandler:nil]; }

// لینکی تێلیگرامی دووەم
- (void)openSecondTelegram { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/kurd4ufeedback"] options:@{} completionHandler:nil]; }

- (void)openWebsite { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://kurd4u.com"] options:@{} completionHandler:nil]; }

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
