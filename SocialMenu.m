#import <UIKit/UIKit.h>

// --- دیزاینی مۆدێرن و پڕۆفیشناڵی نوێ (Bottom Sheet Style) ---
@interface AshteWelcomeViewController : UIViewController
@property (nonatomic, strong) UIView *bottomCard;
@property (nonatomic, strong) UIVisualEffectView *blurView;
- (void)openTelegram;
- (void)openTikTok;
- (void)openWebsite;
- (void)closeTapped;
- (void)playHaptic;
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // شاشەکە بێ سنوور
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;

    // باکگراوندی تەڵخی مۆدێرن (Blur)
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = self.view.bounds;
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.blurView.alpha = 0; // بۆ ئەنیمەیشنی سەرەتا
    [self.view addSubview:self.blurView];

    // --- کارتی سەرەکی لە خوارەوە (Modern Bottom Sheet) ---
    self.bottomCard = [[UIView alloc] init];
    self.bottomCard.backgroundColor = [UIColor colorWithWhite:0.08 alpha:0.95]; // ڕەنگێکی ڕەشی زۆر مۆدێرن
    self.bottomCard.layer.cornerRadius = 35;
    self.bottomCard.layer.borderWidth = 1.0;
    self.bottomCard.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    
    // سێبەری پڕۆفیشناڵ (Shadow)
    self.bottomCard.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomCard.layer.shadowOffset = CGSizeMake(0, 15);
    self.bottomCard.layer.shadowRadius = 25;
    self.bottomCard.layer.shadowOpacity = 0.6;
    
    self.bottomCard.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bottomCard];

    // جێگیرکردنی کارتەکە لە خوارەوەی شاشەکە
    [NSLayoutConstraint activateConstraints:@[
        [self.bottomCard.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.bottomCard.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-40],
        [self.bottomCard.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.92]
    ]];

    // ڕیزکردنی ناوەڕۆک (StackView)
    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.axis = UILayoutConstraintAxisVertical;
    contentStack.spacing = 15;
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomCard addSubview:contentStack];

    [NSLayoutConstraint activateConstraints:@[
        [contentStack.topAnchor constraintEqualToAnchor:self.bottomCard.topAnchor constant:30],
        [contentStack.bottomAnchor constraintEqualToAnchor:self.bottomCard.bottomAnchor constant:-30],
        [contentStack.leadingAnchor constraintEqualToAnchor:self.bottomCard.leadingAnchor constant:25],
        [contentStack.trailingAnchor constraintEqualToAnchor:self.bottomCard.trailingAnchor constant:-25]
    ]];

    // --- هێدەری سەرەوە (لۆگۆ و تایتڵ بەیەکەوە) ---
    UIStackView *headerStack = [[UIStackView alloc] init];
    headerStack.axis = UILayoutConstraintAxisHorizontal;
    headerStack.spacing = 15;
    headerStack.alignment = UIStackViewAlignmentCenter;
    [contentStack addArrangedSubview:headerStack];

    // لۆگۆ
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    logoView.layer.cornerRadius = 25; // خڕکردنی لۆگۆ
    logoView.clipsToBounds = YES;
    logoView.layer.borderWidth = 1.5;
    logoView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [logoView.widthAnchor constraintEqualToConstant:60],
        [logoView.heightAnchor constraintEqualToConstant:60]
    ]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/a.png"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                logoView.image = [UIImage imageWithData:data];
            });
        }
    });
    [headerStack addArrangedSubview:logoView];

    // تایتڵ و سەبتایتڵ
    UIStackView *titleStack = [[UIStackView alloc] init];
    titleStack.axis = UILayoutConstraintAxisVertical;
    titleStack.spacing = 2;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile";
    titleLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightHeavy];
    titleLabel.textColor = [UIColor whiteColor];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"Premium Mod Menu";
    subTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    subTitleLabel.textColor = [UIColor colorWithRed:0.0 green:0.6 blue:1.0 alpha:1.0]; // ڕەنگی شینی مۆدێرن
    
    [titleStack addArrangedSubview:titleLabel];
    [titleStack addArrangedSubview:subTitleLabel];
    [headerStack addArrangedSubview:titleStack];

    // هێڵی جیاکەرەوە
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    [divider.heightAnchor constraintEqualToConstant:1].active = YES;
    [contentStack addArrangedSubview:divider];

    // --- دوگمەکان ---
    UIButton *tgBtn = [self createModernButton:@"Join Telegram" color:[UIColor colorWithRed:0.0 green:0.55 blue:0.95 alpha:1.0] action:@selector(openTelegram)];
    UIButton *ttBtn = [self createModernButton:@"Follow on TikTok" color:[UIColor colorWithWhite:0.15 alpha:1.0] action:@selector(openTikTok)];
    UIButton *webBtn = [self createModernButton:@"Official Website" color:[UIColor colorWithRed:0.9 green:0.15 blue:0.35 alpha:1.0] action:@selector(openWebsite)];
    
    [contentStack addArrangedSubview:tgBtn];
    [contentStack addArrangedSubview:ttBtn];
    [contentStack addArrangedSubview:webBtn];

    // بۆشایی پێش دوگمەی کۆتایی
    UIView *spacer = [[UIView alloc] init];
    [spacer.heightAnchor constraintEqualToConstant:5].active = YES;
    [contentStack addArrangedSubview:spacer];

    // --- دوگمەی سەرەکی بۆ داپۆشین (Start Game) ---
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn.backgroundColor = [UIColor whiteColor];
    startBtn.layer.cornerRadius = 20;
    [startBtn setTitle:@"Start Game" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // ڕەنگی پێچەوانە بۆ جیاوازی
    startBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [startBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [startBtn.heightAnchor constraintEqualToConstant:55].active = YES;
    
    // سێبەری بچووک بۆ دوگمەی خوارەوە
    startBtn.layer.shadowColor = [UIColor whiteColor].CGColor;
    startBtn.layer.shadowOffset = CGSizeMake(0, 0);
    startBtn.layer.shadowRadius = 10;
    startBtn.layer.shadowOpacity = 0.3;
    
    [contentStack addArrangedSubview:startBtn];

    // ئامادەکردنی کارتەکە بۆ ئەنیمەیشن (لە خوارەوە دەست پێدەکات)
    self.bottomCard.transform = CGAffineTransformMakeTranslation(0, 700);
}

// ئەنیمەیشنی زۆر جوانی Spring
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // هێنانی باکگراوندەکە
    [UIView animateWithDuration:0.3 animations:^{
        self.blurView.alpha = 1.0;
    }];
    
    // هێنانە سەرەوەی کارتەکە
    [UIView animateWithDuration:0.6 delay:0.1 usingSpringWithDamping:0.75 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomCard.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (UIButton *)createModernButton:(NSString *)title color:(UIColor *)color action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 16;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn.heightAnchor constraintEqualToConstant:50].active = YES;
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
    // ئەنیمەیشنی داخستن
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomCard.transform = CGAffineTransformMakeTranslation(0, 700);
        self.blurView.alpha = 0;
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
                    
                    welcomeVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    
                    [topController presentViewController:welcomeVC animated:NO completion:nil];
                }
            });
        });
    }];
}
