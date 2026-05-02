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
    
    // شاشەکە هەمووی دەگرێت و باکگراوەندەکەی سپی ستانداردە
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 30;
    mainStack.alignment = UIStackViewAlignmentCenter;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [mainStack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [mainStack.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.9]
    ]];

    // --- لۆگۆی ئەشتە مۆبایل ---
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 25; 
    imageView.clipsToBounds = YES;
    [mainStack addArrangedSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:100],
        [imageView.heightAnchor constraintEqualToConstant:100]
    ]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/4K8boi7.jpeg"]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });

    // --- ناوی پڕۆژە ---
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AshteMobile";
    titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor labelColor];
    [mainStack addArrangedSubview:titleLabel];

    // --- سۆشیاڵ میدیا دوگمەکان (لۆگۆی ڕەسەن) ---
    UIStackView *buttonStack = [[UIStackView alloc] init];
    buttonStack.axis = UILayoutConstraintAxisVertical;
    buttonStack.spacing = 15;
    buttonStack.alignment = UIStackViewAlignmentFill;
    buttonStack.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStack addArrangedSubview:buttonStack];

    [NSLayoutConstraint activateConstraints:@[
        [buttonStack.widthAnchor constraintEqualToAnchor:mainStack.widthAnchor]
    ]];

    // دروستکردنی دوگمەکان بە لۆگۆی دەرەکی بۆ ئەوەی ئیرۆر نەدات
    UIButton *tgBtn = [self createBtn:@"Telegram" color:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] img:@"https://img.icons8.com/color/96/telegram-app.png" sel:@selector(openTelegram)];
    UIButton *ttBtn = [self createBtn:@"TikTok" color:[UIColor blackColor] img:@"https://img.icons8.com/color/96/tiktok--v1.png" sel:@selector(openTikTok)];
    UIButton *webBtn = [self createBtn:@"Website" color:[UIColor systemGrayColor] img:@"https://img.icons8.com/fluency/96/domain.png" sel:@selector(openWebsite)];

    [buttonStack addArrangedSubview:tgBtn];
    [buttonStack addArrangedSubview:ttBtn];
    [buttonStack addArrangedSubview:webBtn];

    // --- دوگمەی Get Started ---
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.47 blue:0.8 alpha:1.0];
    closeBtn.layer.cornerRadius = 15;
    [closeBtn setTitle:@"Get Started ➔" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainStack addArrangedSubview:closeBtn];

    [NSLayoutConstraint activateConstraints:@[
        [closeBtn.widthAnchor constraintEqualToAnchor:buttonStack.widthAnchor],
        [closeBtn.heightAnchor constraintEqualToConstant:55]
    ]];
}

- (UIButton *)createBtn:(NSString *)t color:(UIColor *)c img:(NSString *)url sel:(SEL)s {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.backgroundColor = [UIColor secondarySystemBackgroundColor];
    b.layer.cornerRadius = 12;
    [b setTitle:t forState:UIControlStateNormal];
    [b setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [b addTarget:self action:s forControlEvents:UIControlEventTouchUpInside];
    
    [NSLayoutConstraint activateConstraints:@[[b.heightAnchor constraintEqualToConstant:50]]];
    return b;
}

- (void)openTelegram { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openTikTok { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tiktok.com/@ashtemobile"] options:@{} completionHandler:nil]; }
- (void)openWebsite { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ashtemobile.tututweak.com/"] options:@{} completionHandler:nil]; }
- (void)closeTapped { [self dismissViewControllerAnimated:NO completion:nil]; }

@end

// ئینجێکتکردنی خێرا
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
                    UIViewController *top = keyWindow.rootViewController;
                    while (top.presentedViewController) { top = top.presentedViewController; }
                    AshteWelcomeViewController *vc = [[AshteWelcomeViewController alloc] init];
                    [top presentViewController:vc animated:NO completion:nil];
                }
            });
        });
    }];
}
