#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <dlfcn.h> 
#include <stdlib.h>

// ناوی فایلی دیایلیب بۆ پاراستن
#define MY_DYLIB_NAME "SocialMenu.dylib"

@interface AshteWelcomeViewController : UIViewController
@property (nonatomic, strong) UIView *glassCard;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // 1. پاشبنەمای لێڵ (Full Screen Blur)
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = self.view.bounds;
    self.blurView.alpha = 0;
    [self.view addSubview:self.blurView];

    // 2. دروستکردنی کارتی شووشەیی (The Glass Card)
    self.glassCard = [[UIView alloc] init];
    self.glassCard.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    self.glassCard.layer.cornerRadius = 35;
    self.glassCard.layer.borderWidth = 1.5;
    self.glassCard.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
    self.glassCard.translatesAutoresizingMaskIntoConstraints = NO;
    self.glassCard.transform = CGAffineTransformMakeScale(0.8, 0.8); // بۆ ئەنیمەیشن
    self.glassCard.alpha = 0;
    
    // سێبەری کارتەکە
    self.glassCard.layer.shadowColor = [UIColor blackColor].CGColor;
    self.glassCard.layer.shadowOffset = CGSizeMake(0, 20);
    self.glassCard.layer.shadowRadius = 30;
    self.glassCard.layer.shadowOpacity = 0.5;
    
    [self.view addSubview:self.glassCard];

    // ئەد کردنی کارتەکە بۆ ناوەندی شاشە
    [NSLayoutConstraint activateConstraints:@[
        [self.glassCard.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.glassCard.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.glassCard.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.82],
        [self.glassCard.heightAnchor constraintGreaterThanOrEqualToConstant:380]
    ]];

    // ناوەڕۆکی ناو کارتەکە (StackView)
    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.axis = UILayoutConstraintAxisVertical;
    contentStack.spacing = 22;
    contentStack.alignment = UIStackViewAlignmentCenter;
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.glassCard addSubview:contentStack];

    [NSLayoutConstraint activateConstraints:@[
        [contentStack.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor constant:30],
        [contentStack.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor constant:20],
        [contentStack.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor constant:-20],
        [contentStack.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor constant:-30]
    ]];

    // لۆگۆ
    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoView.layer.cornerRadius = 22;
    self.logoView.clipsToBounds = YES;
    self.logoView.layer.borderWidth = 2;
    self.logoView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.6].CGColor;
    [self.logoView.heightAnchor constraintEqualToConstant:85].active = YES;
    [self.logoView.widthAnchor constraintEqualToConstant:85].active = YES;
    [contentStack addArrangedSubview:self.logoView];
    [self loadAndCacheImage:@"https://ashtemobile.site/a.png" forImageView:self.logoView];

    // تایتڵەکان
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"ASHTE MOBILE";
    titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
    titleLabel.textColor = [UIColor whiteColor];
    [contentStack addArrangedSubview:titleLabel];

    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"The Ultimate iOS Experience";
    descLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    descLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    [contentStack addArrangedSubview:descLabel];

    // هێڵی جیاکەرەوە
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    [line.heightAnchor constraintEqualToConstant:1].active = YES;
    [line.widthAnchor constraintEqualToAnchor:contentStack.widthAnchor].active = YES;
    [contentStack addArrangedSubview:line];

    // دوگمە کۆمەڵایەتییەکان
    UIStackView *socialStack = [[UIStackView alloc] init];
    socialStack.axis = UILayoutConstraintAxisHorizontal;
    socialStack.spacing = 18;
    socialStack.distribution = UIStackViewDistributionFillEqually;
    [contentStack addArrangedSubview:socialStack];

    [socialStack addArrangedSubview:[self createSocialBtn:@"https://img.icons8.com/fluency/100/telegram-app.png" action:@selector(openTelegram)]];
    [socialStack addArrangedSubview:[self createSocialBtn:@"https://img.icons8.com/fluency/100/safari.png" action:@selector(openWebsite)]];
    [socialStack addArrangedSubview:[self createSocialBtn:@"https://img.icons8.com/fluency/100/tiktok.png" action:@selector(openTikTok)]];

    // دوگمەی سەرەکی (OPEN)
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn.backgroundColor = [UIColor systemBlueColor];
    startBtn.layer.cornerRadius = 18;
    [startBtn setTitle:@"LAUNCH MENU" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [startBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [contentStack addArrangedSubview:startBtn];
    [NSLayoutConstraint activateConstraints:@[
        [startBtn.widthAnchor constraintEqualToAnchor:contentStack.widthAnchor],
        [startBtn.heightAnchor constraintEqualToConstant:55]
    ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // ئەنیمەیشنی هاتنە ناوەوەی کارتەکە
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.glassCard.alpha = 1.0;
        self.glassCard.transform = CGAffineTransformIdentity;
        self.blurView.alpha = 1.0;
    } completion:nil];
    
    // ئەنیمەیشنی لەرینەوە بۆ لۆگۆکە
    [self addPulseToLogo];
}

- (void)addPulseToLogo {
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.duration = 1.2;
    pulse.fromValue = @(1.0);
    pulse.toValue = @(1.05);
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.autoreverses = YES;
    pulse.repeatCount = HUGE_VALF;
    [self.logoView.layer addAnimation:pulse forKey:@"pulse"];
}

- (UIButton *)createSocialBtn:(NSString *)url action:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.05];
    btn.layer.cornerRadius = 20;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addSubview:icon];
    
    [NSLayoutConstraint activateConstraints:@[
        [btn.widthAnchor constraintEqualToConstant:65],
        [btn.heightAnchor constraintEqualToConstant:65],
        [icon.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor],
        [icon.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
        [icon.widthAnchor constraintEqualToConstant:32],
        [icon.heightAnchor constraintEqualToConstant:32]
    ]];
    
    [self loadAndCacheImage:url forImageView:icon];
    
    // زیادکردنی کاریگەری لێدان لە کاتی داگرتن
    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    return btn;
}

- (void)btnTouchDown:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{ sender.transform = CGAffineTransformMakeScale(0.9, 0.9); }];
}

- (void)btnTouchUp:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{ sender.transform = CGAffineTransformIdentity; }];
}

- (void)loadAndCacheImage:(NSString *)urlStr forImageView:(UIImageView *)imgView {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView.image = [UIImage imageWithData:data];
            });
        }
    });
}

- (void)playHaptic {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [gen impactOccurred];
}

- (void)openTelegram { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openWebsite { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ashtemobile.site"] options:@{} completionHandler:nil]; }
- (void)openTikTok   { [self playHaptic]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tiktok.com/@ashtemobile"] options:@{} completionHandler:nil]; }

- (void)closeTapped {
    [self playHaptic];
    [UIView animateWithDuration:0.4 animations:^{
        self.glassCard.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end

// --- ئینجێکتکردن ---
__attribute__((constructor)) static void initWelcome() {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            // دڵنیابوون لەوەی فایلەکە دەستکاری نەکراوە
            if (!dlopen(MY_DYLIB_NAME, RTLD_NOW)) exit(0);

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                if (window.rootViewController) {
                    UIViewController *top = window.rootViewController;
                    while (top.presentedViewController) top = top.presentedViewController;
                    
                    AshteWelcomeViewController *vc = [[AshteWelcomeViewController alloc] init];
                    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [top presentViewController:vc animated:NO completion:nil];
                }
            });
        });
    }];
}
