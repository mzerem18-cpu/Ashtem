#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <dlfcn.h> 
#include <stdlib.h>

#define MY_DYLIB_NAME "SocialMenu.dylib"

@interface AshteWelcomeViewController : UIViewController
@property (nonatomic, strong) UIView *glassCard;
@property (nonatomic, strong) UIImageView *logoView; 
- (void)openTelegram;
- (void)openTikTok;
- (void)openWebsite;
- (void)closeTapped;
- (void)playHaptic;
- (void)loadAndCacheImage:(NSString *)urlStr forImageView:(UIImageView *)imgView placeholder:(NSString *)sysName;
- (UIButton *)createModernBlockButton:(NSString *)url placeholder:(NSString *)ph action:(SEL)action;
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;

    // باکگراوندی پشتەوە (تەڵخێکی نەرمی تاریک بۆ ئەوەی کارتە ڕووناکەکە دەربکەوێت)
    UIBlurEffect *bgBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bgBlurView = [[UIVisualEffectView alloc] initWithEffect:bgBlur];
    bgBlurView.frame = self.view.bounds;
    bgBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bgBlurView.alpha = 0.6; // کەمێک ڕووناکتر بۆ ئەوەی زۆر تاریک نەبێت
    [self.view addSubview:bgBlurView];

    // دروستکردنی کارتی سەرەکی بە شێوازی (Apple Native Glass)
    self.glassCard = [[UIView alloc] init];
    self.glassCard.backgroundColor = [UIColor clearColor];
    
    // سێبەری پرۆفیشناڵ
    self.glassCard.layer.shadowColor = [UIColor blackColor].CGColor;
    self.glassCard.layer.shadowOpacity = 0.15;
    self.glassCard.layer.shadowOffset = CGSizeMake(0, 12);
    self.glassCard.layer.shadowRadius = 30;
    self.glassCard.translatesAutoresizingMaskIntoConstraints = NO;
    self.glassCard.alpha = 0; 
    self.glassCard.transform = CGAffineTransformMakeScale(0.85, 0.85); 
    
    [self.view addSubview:self.glassCard];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.glassCard.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.glassCard.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.glassCard.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.85],
        [self.glassCard.widthAnchor constraintLessThanOrEqualToConstant:350]
    ]];

    // ئیفێکتی شوشەیی ڕووناک (Thin Material Light) بۆ ناو کارتەکە
    UIBlurEffect *cardBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialLight];
    UIVisualEffectView *cardBlurView = [[UIVisualEffectView alloc] initWithEffect:cardBlur];
    cardBlurView.translatesAutoresizingMaskIntoConstraints = NO;
    cardBlurView.layer.cornerRadius = 28;
    if (@available(iOS 13.0, *)) {
        cardBlurView.layer.cornerCurve = kCACornerCurveContinuous; // چەماوەیی سافتری ئەپڵ
    }
    cardBlurView.clipsToBounds = YES;
    cardBlurView.layer.borderWidth = 1.0;
    cardBlurView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor; // هێڵێکی سپی زۆر تەنک
    [self.glassCard addSubview:cardBlurView];

    [NSLayoutConstraint activateConstraints:@[
        [cardBlurView.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor],
        [cardBlurView.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor],
        [cardBlurView.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor],
        [cardBlurView.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor]
    ]];

    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 26;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.glassCard addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor constant:30],
        [mainStack.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor constant:-30],
        [mainStack.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor constant:24],
        [mainStack.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor constant:-24]
    ]];

    UIStackView *headerStack = [[UIStackView alloc] init];
    headerStack.axis = UILayoutConstraintAxisHorizontal;
    headerStack.spacing = 16;
    headerStack.alignment = UIStackViewAlignmentCenter;
    [mainStack addArrangedSubview:headerStack];

    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoView.layer.cornerRadius = 16; 
    if (@available(iOS 13.0, *)) { self.logoView.layer.cornerCurve = kCACornerCurveContinuous; }
    self.logoView.clipsToBounds = YES;
    self.logoView.layer.borderWidth = 1.5;
    self.logoView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    
    // سێبەر بۆ لۆگۆ
    self.logoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.logoView.layer.shadowOpacity = 0.1;
    self.logoView.layer.shadowOffset = CGSizeMake(0, 4);
    self.logoView.layer.shadowRadius = 8;
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [headerStack addArrangedSubview:self.logoView];

    [NSLayoutConstraint activateConstraints:@[
        [self.logoView.widthAnchor constraintEqualToConstant:65],
        [self.logoView.heightAnchor constraintEqualToConstant:65]
    ]];

    [self loadAndCacheImage:@"https://ashtemobile.site/a.png" forImageView:self.logoView placeholder:@"app.fill"];

    UIStackView *titleStack = [[UIStackView alloc] init];
    titleStack.axis = UILayoutConstraintAxisVertical;
    titleStack.spacing = 4;
    [headerStack addArrangedSubview:titleStack];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile"; 
    titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBlack];
    titleLabel.textColor = [UIColor blackColor]; 
    [titleStack addArrangedSubview:titleLabel];

    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = @"Premium iOS Mod";
    subLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    subLabel.textColor = [UIColor systemBlueColor]; 
    [titleStack addArrangedSubview:subLabel];

    // هێڵی جیاکەرەوە
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.06];
    [divider.heightAnchor constraintEqualToConstant:1].active = YES;
    [mainStack addArrangedSubview:divider];

    // چوارچێوەی سۆشیاڵەکان
    UIStackView *dockStack = [[UIStackView alloc] init];
    dockStack.axis = UILayoutConstraintAxisHorizontal;
    dockStack.spacing = 16;
    dockStack.distribution = UIStackViewDistributionFillEqually;
    [mainStack addArrangedSubview:dockStack];

    [NSLayoutConstraint activateConstraints:@[
        [dockStack.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    UIButton *tgBtn = [self createModernBlockButton:@"https://img.icons8.com/color/100/telegram-app.png" placeholder:@"paperplane.fill" action:@selector(openTelegram)];
    UIButton *webBtn = [self createModernBlockButton:@"https://img.icons8.com/color/100/safari--v1.png" placeholder:@"safari.fill" action:@selector(openWebsite)];
    UIButton *ttBtn = [self createModernBlockButton:@"https://img.icons8.com/fluency/100/tiktok.png" placeholder:@"play.tv.fill" action:@selector(openTikTok)];

    [dockStack addArrangedSubview:tgBtn];
    [dockStack addArrangedSubview:webBtn];
    [dockStack addArrangedSubview:ttBtn];

    // دوگمەی OPEN
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0]; // شینێکی جوانتری ئەپڵ
    startBtn.layer.cornerRadius = 16; 
    if (@available(iOS 13.0, *)) { startBtn.layer.cornerCurve = kCACornerCurveContinuous; }
    [startBtn setTitle:@"OPEN" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    
    startBtn.layer.shadowColor = [UIColor systemBlueColor].CGColor;
    startBtn.layer.shadowOpacity = 0.35;
    startBtn.layer.shadowOffset = CGSizeMake(0, 6);
    startBtn.layer.shadowRadius = 12;
    
    [startBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:startBtn];

    [NSLayoutConstraint activateConstraints:@[
        [startBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor],
        [startBtn.heightAnchor constraintEqualToConstant:56] 
    ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.glassCard.alpha = 1.0;
        self.glassCard.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)loadAndCacheImage:(NSString *)urlStr forImageView:(UIImageView *)imgView placeholder:(NSString *)sysName {
    if (sysName) {
        imgView.image = [UIImage systemImageNamed:sysName];
        imgView.tintColor = [UIColor colorWithWhite:0.0 alpha:0.4];
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

- (UIButton *)createModernBlockButton:(NSString *)url placeholder:(NSString *)ph action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6]; // باکگراوندی ڕووناک و جوان
    btn.layer.cornerRadius = 16; 
    if (@available(iOS 13.0, *)) { btn.layer.cornerCurve = kCACornerCurveContinuous; }
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    
    // کەمێک سێبەری نەرم بۆ دوگمەکان
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOpacity = 0.05;
    btn.layer.shadowOffset = CGSizeMake(0, 3);
    btn.layer.shadowRadius = 5;
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    UIImageView *icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addSubview:icon];

    [NSLayoutConstraint activateConstraints:@[
        [btn.heightAnchor constraintEqualToConstant:65], 
        [icon.centerXAnchor constraintEqualToAnchor:btn.centerXAnchor],
        [icon.centerYAnchor constraintEqualToAnchor:btn.centerYAnchor],
        [icon.widthAnchor constraintEqualToConstant:34],
        [icon.heightAnchor constraintEqualToConstant:34]
    ]];

    [self loadAndCacheImage:url forImageView:icon placeholder:ph];

    return btn;
}

- (void)playHaptic {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
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
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0.0; 
        self.glassCard.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end

__attribute__((constructor)) static void showCustomWelcomeScreen() {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                void *handle = dlopen(MY_DYLIB_NAME, RTLD_NOW);
                if (!handle) {
                    exit(0);
                }
                
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
