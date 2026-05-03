#import <UIKit/UIKit.h>

@interface AshteWelcomeViewController : UIViewController
- (void)openTelegram;
- (void)openTikTok;
- (void)openWebsite;
- (void)closeTapped;
@end

@implementation AshteWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ١. شاشەکە بەتەواوی بێ سنوور دەکەین
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    // ٢. باکگراوندێکی تەڵخی یەک پارچە بۆ هەموو شاشەکە (بێ بۆشایی)
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurView];

    // ٣. ڕێکخستنی پێکهاتەکان ڕاستەوخۆ لە ناوەڕاستی شاشە
    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 25;
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [mainStack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [mainStack.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.85]
    ]];

    // --- لۆگۆی ئەشتە مۆبایل ---
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 22; 
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [mainStack addArrangedSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:90],
        [imageView.heightAnchor constraintEqualToConstant:90]
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
    titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightHeavy];
    titleLabel.textColor = [UIColor whiteColor];
    [mainStack addArrangedSubview:titleLabel];

    // --- سۆشیاڵ میدیا ---
    UIStackView *rowStack = [[UIStackView alloc] init];
    rowStack.axis = UILayoutConstraintAxisHorizontal;
    rowStack.spacing = 15;
    rowStack.distribution = UIStackViewDistributionFillEqually;
    [mainStack addArrangedSubview:rowStack];

    [NSLayoutConstraint activateConstraints:@[
        [rowStack.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    UIButton *tgBtn = [self createModernButton:@"Telegram" color:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] action:@selector(openTelegram)];
    UIButton *ttBtn = [self createModernButton:@"TikTok" color:[UIColor whiteColor] action:@selector(openTikTok)];
    
    [rowStack addArrangedSubview:tgBtn];
    [rowStack addArrangedSubview:ttBtn];

    UIButton *webBtn = [self createModernButton:@"Visit Official Website" color:[UIColor colorWithRed:1.0 green:0.2 blue:0.4 alpha:1.0] action:@selector(openWebsite)];
    [mainStack addArrangedSubview:webBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [webBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    // --- دوگمەی خوارەوە (Get Started) ---
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.45 blue:0.9 alpha:1.0];
    closeBtn.layer.cornerRadius = 18;
    [closeBtn setTitle:@"Get Started ➔" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor],
        [closeBtn.heightAnchor constraintEqualToConstant:55]
    ]];
}

// فەنکشنی دروستکردنی دوگمە شوشەییەکان
- (UIButton *)createModernButton:(NSString *)title color:(UIColor *)color action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.12];
    btn.layer.cornerRadius = 15;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn.heightAnchor constraintEqualToConstant:50].active = YES;
    return btn;
}

- (void)openTelegram { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openTikTok { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tiktok.com/@ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openWebsite { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/"] options:@{} completionHandler:nil]; }

- (void)closeTapped {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end

// ئینجێکتکردنی خێرا بێ هیچ بۆشاییەک لە سەرەوە
__attribute__((constructor)) static void startAshteMobile() {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIWindow *keyWindow = nil;
                for (UIWindow *window in [UIApplication sharedApplication].windows) {
                    if (window.isKeyWindow) { keyWindow = window; break; }
                }
                if (keyWindow && keyWindow.rootViewController) {
                    UIViewController *top = keyWindow.rootViewController;
                    while (top.presentedViewController) { top = top.presentedViewController; }
                    AshteWelcomeViewController *vc = [[AshteWelcomeViewController alloc] init];
                    
                    // ئەمە وادەکات شاشەکە هەموو شوێنێک بگرێت بێ سنوور
                    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [top presentViewController:vc animated:NO completion:nil];
                }
            });
        });
    }];
}
