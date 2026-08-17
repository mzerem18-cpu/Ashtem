#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#include <dlfcn.h>
#include <stdlib.h>

#define MY_DYLIB_NAME "SocialMenu.dylib"

#pragma mark - Colors

static UIColor *AshteBlue(void) {
    return [UIColor colorWithRed:0.10 green:0.48 blue:1.00 alpha:1.0];
}

static UIColor *AshteCyan(void) {
    return [UIColor colorWithRed:0.05 green:0.78 blue:1.00 alpha:1.0];
}

#pragma mark - Premium Gradient Background

@interface AshteGradientView : UIView
@end

@implementation AshteGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *gradient = (CAGradientLayer *)self.layer;

        gradient.colors = @[
            (id)[UIColor colorWithRed:0.01 green:0.03 blue:0.08 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.02 green:0.08 blue:0.18 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.00 green:0.01 blue:0.04 alpha:1.0].CGColor
        ];

        gradient.startPoint = CGPointMake(0.0, 0.0);
        gradient.endPoint = CGPointMake(1.0, 1.0);
    }
    return self;
}

@end

#pragma mark - Welcome Controller

@interface AshteWelcomeViewController : UIViewController
@property(nonatomic,strong) UIView *glassCard;
@property(nonatomic,strong) UIImageView *logoView;
@property(nonatomic,strong) UIVisualEffectView *backgroundBlur;

- (void)openTelegram;
- (void)openTikTok;
- (void)openWebsite;
- (void)closeTapped;
- (void)playHaptic;

- (void)loadAndCacheImage:(NSString *)urlStr
            forImageView:(UIImageView *)imgView
             placeholder:(NSString *)sysName;

- (UIButton *)createModernBlockButton:(NSString *)url
                          placeholder:(NSString *)ph
                               action:(SEL)action;
@end

@implementation AshteWelcomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.clearColor;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self buildBackground];
    [self buildGlassCard];
    [self buildContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.view.alpha = 1.0;

    [UIView animateWithDuration:0.65
                          delay:0.05
         usingSpringWithDamping:0.78
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.glassCard.alpha = 1.0;
        self.glassCard.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark - Background

- (void)buildBackground {
    AshteGradientView *gradient = [[AshteGradientView alloc] init];
    gradient.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:gradient];

    [NSLayoutConstraint activateConstraints:@[
        [gradient.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [gradient.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [gradient.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [gradient.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];

    UIBlurEffect *blurEffect =
        [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterialDark];

    self.backgroundBlur =
        [[UIVisualEffectView alloc] initWithEffect:blurEffect];

    self.backgroundBlur.alpha = 0.88;
    self.backgroundBlur.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.backgroundBlur];

    [NSLayoutConstraint activateConstraints:@[
        [self.backgroundBlur.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.backgroundBlur.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.backgroundBlur.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.backgroundBlur.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];

    UIView *overlay = [[UIView alloc] init];
    overlay.backgroundColor = [UIColor colorWithWhite:0 alpha:0.28];
    overlay.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:overlay];

    [NSLayoutConstraint activateConstraints:@[
        [overlay.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [overlay.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [overlay.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [overlay.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
}

#pragma mark - Glass Card

- (void)buildGlassCard {
    self.glassCard = [[UIView alloc] init];
    self.glassCard.translatesAutoresizingMaskIntoConstraints = NO;

    self.glassCard.backgroundColor =
        [UIColor colorWithWhite:0.06 alpha:0.82];

    self.glassCard.layer.cornerRadius = 32.0;
    self.glassCard.layer.borderWidth = 1.0;
    self.glassCard.layer.borderColor =
        [UIColor colorWithWhite:1.0 alpha:0.14].CGColor;

    self.glassCard.layer.shadowColor = UIColor.blackColor.CGColor;
    self.glassCard.layer.shadowOpacity = 0.45;
    self.glassCard.layer.shadowRadius = 35.0;
    self.glassCard.layer.shadowOffset = CGSizeMake(0, 18);

    self.glassCard.alpha = 0.0;
    self.glassCard.transform = CGAffineTransformMakeScale(0.92, 0.92);

    [self.view addSubview:self.glassCard];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        [self.glassCard.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.glassCard.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.glassCard.leadingAnchor constraintGreaterThanOrEqualToAnchor:safe.leadingAnchor constant:18],
        [self.glassCard.trailingAnchor constraintLessThanOrEqualToAnchor:safe.trailingAnchor constant:-18],
        [self.glassCard.widthAnchor constraintLessThanOrEqualToConstant:370],
        [self.glassCard.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.88]
    ]];
}

#pragma mark - Content

- (void)buildContent {
    UIStackView *mainStack = [[UIStackView alloc] init];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 18.0;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.glassCard addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:self.glassCard.topAnchor constant:26],
        [mainStack.bottomAnchor constraintEqualToAnchor:self.glassCard.bottomAnchor constant:-26],
        [mainStack.leadingAnchor constraintEqualToAnchor:self.glassCard.leadingAnchor constant:22],
        [mainStack.trailingAnchor constraintEqualToAnchor:self.glassCard.trailingAnchor constant:-22]
    ]];

    UIStackView *header = [[UIStackView alloc] init];
    header.axis = UILayoutConstraintAxisHorizontal;
    header.spacing = 15;
    header.alignment = UIStackViewAlignmentCenter;
    [mainStack addArrangedSubview:header];

    UIView *logoContainer = [[UIView alloc] init];
    logoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    logoContainer.layer.cornerRadius = 20;
    logoContainer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.06];
    logoContainer.layer.borderWidth = 1.0;
    logoContainer.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.14].CGColor;
    logoContainer.layer.shadowColor = AshteBlue().CGColor;
    logoContainer.layer.shadowOpacity = 0.35;
    logoContainer.layer.shadowRadius = 12;
    logoContainer.layer.shadowOffset = CGSizeZero;

    [header addArrangedSubview:logoContainer];

    [NSLayoutConstraint activateConstraints:@[
        [logoContainer.widthAnchor constraintEqualToConstant:70],
        [logoContainer.heightAnchor constraintEqualToConstant:70]
    ]];

    self.logoView = [[UIImageView alloc] init];
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoView.layer.cornerRadius = 18;
    self.logoView.clipsToBounds = YES;
    [logoContainer addSubview:self.logoView];

    [NSLayoutConstraint activateConstraints:@[
        [self.logoView.topAnchor constraintEqualToAnchor:logoContainer.topAnchor constant:4],
        [self.logoView.bottomAnchor constraintEqualToAnchor:logoContainer.bottomAnchor constant:-4],
        [self.logoView.leadingAnchor constraintEqualToAnchor:logoContainer.leadingAnchor constant:4],
        [self.logoView.trailingAnchor constraintEqualToAnchor:logoContainer.trailingAnchor constant:-4]
    ]];

    [self loadAndCacheImage:@"https://ashtemobile.site/a.png"
               forImageView:self.logoView
                placeholder:@"app.fill"];

    UIStackView *titleStack = [[UIStackView alloc] init];
    titleStack.axis = UILayoutConstraintAxisVertical;
    titleStack.spacing = 4;
    [header addArrangedSubview:titleStack];

    UILabel *title = [[UILabel alloc] init];
    title.text = @"AshteMobile";
    title.textColor = UIColor.whiteColor;
    title.font = [UIFont systemFontOfSize:23 weight:UIFontWeightBold];
    [titleStack addArrangedSubview:title];

    UILabel *subtitle = [[UILabel alloc] init];
    subtitle.text = @"Premium iOS Experience";
    subtitle.textColor = AshteCyan();
    subtitle.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    [titleStack addArrangedSubview:subtitle];

    UILabel *description = [[UILabel alloc] init];
    description.text = @"Welcome to AshteMobile";
    description.textColor = [UIColor colorWithWhite:1 alpha:0.58];
    description.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    description.textAlignment = NSTextAlignmentCenter;
    [mainStack addArrangedSubview:description];

    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor colorWithWhite:1 alpha:0.09];
    [divider.heightAnchor constraintEqualToConstant:1].active = YES;
    [mainStack addArrangedSubview:divider];

    UIStackView *socialStack = [[UIStackView alloc] init];
    socialStack.axis = UILayoutConstraintAxisHorizontal;
    socialStack.spacing = 10;
    socialStack.distribution = UIStackViewDistributionFillEqually;
    [mainStack addArrangedSubview:socialStack];

    UIButton *telegram =
        [self createModernBlockButton:@"https://img.icons8.com/color/100/telegram-app.png"
                          placeholder:@"paperplane.fill"
                               action:@selector(openTelegram)];

    UIButton *website =
        [self createModernBlockButton:@"https://img.icons8.com/color/100/safari--v1.png"
                          placeholder:@"safari.fill"
                               action:@selector(openWebsite)];

    UIButton *tiktok =
        [self createModernBlockButton:@"https://img.icons8.com/fluency/100/tiktok.png"
                          placeholder:@"play.tv.fill"
                               action:@selector(openTikTok)];

    [socialStack addArrangedSubview:telegram];
    [socialStack addArrangedSubview:website];
    [socialStack addArrangedSubview:tiktok];

    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeSystem];
    openButton.translatesAutoresizingMaskIntoConstraints = NO;
    openButton.backgroundColor = AshteBlue();
    openButton.layer.cornerRadius = 17.0;

    openButton.layer.shadowColor = AshteBlue().CGColor;
    openButton.layer.shadowOpacity = 0.35;
    openButton.layer.shadowRadius = 14;
    openButton.layer.shadowOffset = CGSizeMake(0, 7);

    [openButton setTitle:@"OPEN ASHTEMOBILE" forState:UIControlStateNormal];
    [openButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    openButton.titleLabel.font =
        [UIFont systemFontOfSize:16 weight:UIFontWeightBold];

    [openButton addTarget:self
                   action:@selector(closeTapped)
         forControlEvents:UIControlEventTouchUpInside];

    [mainStack addArrangedSubview:openButton];
    [openButton.heightAnchor constraintEqualToConstant:54].active = YES;

    UILabel *footer = [[UILabel alloc] init];
    footer.text = @"Designed for AshteMobile";
    footer.textColor = [UIColor colorWithWhite:1 alpha:0.30];
    footer.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    footer.textAlignment = NSTextAlignmentCenter;
    [mainStack addArrangedSubview:footer];
}

#pragma mark - Image Cache

- (void)loadAndCacheImage:(NSString *)urlStr
            forImageView:(UIImageView *)imgView
             placeholder:(NSString *)sysName {

    if (sysName) {
        imgView.image = [UIImage systemImageNamed:sysName];
        imgView.tintColor = [UIColor colorWithWhite:1 alpha:0.35];
    }

    NSString *fileName =
        [[urlStr componentsSeparatedByString:@"/"] lastObject];

    if (fileName.length == 0) return;

    NSString *cacheDir =
        NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                            NSUserDomainMask,
                                            YES).firstObject;

    NSString *cachePath =
        [cacheDir stringByAppendingPathComponent:fileName];

    NSData *cached =
        [NSData dataWithContentsOfFile:cachePath];

    if (cached.length > 0) {
        UIImage *image = [UIImage imageWithData:cached];

        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView.image = image;
            });
            return;
        }
    }

    NSURL *url = [NSURL URLWithString:urlStr];
    if (!url) return;

    NSURLSessionDataTask *task =
        [[NSURLSession sharedSession]
         dataTaskWithURL:url
         completionHandler:^(NSData *data,
                             NSURLResponse *response,
                             NSError *error) {

        if (error || data.length == 0) return;

        UIImage *image = [UIImage imageWithData:data];
        if (!image) return;

        [data writeToFile:cachePath atomically:YES];

        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:imgView
                              duration:0.25
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                imgView.image = image;
            } completion:nil];
        });
    }];

    [task resume];
}

#pragma mark - Social Buttons

- (UIButton *)createModernBlockButton:(NSString *)url
                          placeholder:(NSString *)ph
                               action:(SEL)action {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    button.backgroundColor = [UIColor colorWithWhite:1 alpha:0.065];
    button.layer.cornerRadius = 17;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.10].CGColor;

    button.layer.shadowColor = UIColor.blackColor.CGColor;
    button.layer.shadowOpacity = 0.20;
    button.layer.shadowRadius = 8;
    button.layer.shadowOffset = CGSizeMake(0, 4);

    [button addTarget:self
               action:action
     forControlEvents:UIControlEventTouchUpInside];

    UIImageView *icon = [[UIImageView alloc] init];
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [button addSubview:icon];

    [NSLayoutConstraint activateConstraints:@[
        [button.heightAnchor constraintEqualToConstant:62],
        [icon.centerXAnchor constraintEqualToAnchor:button.centerXAnchor],
        [icon.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [icon.widthAnchor constraintEqualToConstant:31],
        [icon.heightAnchor constraintEqualToConstant:31]
    ]];

    [self loadAndCacheImage:url
               forImageView:icon
                placeholder:ph];

    return button;
}

#pragma mark - Haptic

- (void)playHaptic {
    UIImpactFeedbackGenerator *generator =
        [[UIImpactFeedbackGenerator alloc]
         initWithStyle:UIImpactFeedbackStyleLight];

    [generator prepare];
    [generator impactOccurred];
}

#pragma mark - Links

- (void)openTelegram {
    [self playHaptic];

    NSURL *url =
        [NSURL URLWithString:@"https://t.me/ashtemobile"];

    [[UIApplication sharedApplication]
        openURL:url
        options:@{}
        completionHandler:nil];
}

- (void)openWebsite {
    [self playHaptic];

    NSURL *url =
        [NSURL URLWithString:@"https://ashtemobile.site"];

    [[UIApplication sharedApplication]
        openURL:url
        options:@{}
        completionHandler:nil];
}

- (void)openTikTok {
    [self playHaptic];

    NSURL *url =
        [NSURL URLWithString:@"https://www.tiktok.com/@ashtemobile"];

    [[UIApplication sharedApplication]
        openURL:url
        options:@{}
        completionHandler:nil];
}

#pragma mark - Close

- (void)closeTapped {
    [self playHaptic];

    [UIView animateWithDuration:0.30
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.glassCard.alpha = 0.0;
        self.glassCard.transform = CGAffineTransformMakeScale(0.94, 0.94);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end

#pragma mark - Injection

__attribute__((constructor))
static void showCustomWelcomeScreen(void) {

    dispatch_async(dispatch_get_main_queue(), ^{

        [[NSNotificationCenter defaultCenter]
            addObserverForName:UIApplicationDidBecomeActiveNotification
            object:nil
            queue:[NSOperationQueue mainQueue]
            usingBlock:^(NSNotification *note) {

            static dispatch_once_t onceToken;

            dispatch_once(&onceToken, ^{

                dispatch_after(
                    dispatch_time(DISPATCH_TIME_NOW,
                                  (int64_t)(0.6 * NSEC_PER_SEC)),
                    dispatch_get_main_queue(), ^{

                    /*
                     * Verify the dylib is loaded.
                     * Do not terminate the host application if the
                     * runtime loader cannot resolve a relative name.
                     */
                    void *handle = dlopen(MY_DYLIB_NAME, RTLD_NOW);

                    if (!handle) {
                        return;
                    }

                    UIWindow *keyWindow = nil;

                    if (@available(iOS 13.0, *)) {

                        for (UIScene *scene
                             in [UIApplication sharedApplication].connectedScenes) {

                            if (scene.activationState !=
                                UISceneActivationStateForegroundActive) {
                                continue;
                            }

                            if (![scene isKindOfClass:[UIWindowScene class]]) {
                                continue;
                            }

                            UIWindowScene *windowScene =
                                (UIWindowScene *)scene;

                            for (UIWindow *window in windowScene.windows) {
                                if (window.isKeyWindow) {
                                    keyWindow = window;
                                    break;
                                }
                            }

                            if (keyWindow) break;
                        }

                    } else {

                        for (UIWindow *window
                             in [UIApplication sharedApplication].windows) {

                            if (window.isKeyWindow) {
                                keyWindow = window;
                                break;
                            }
                        }
                    }

                    if (!keyWindow.rootViewController) {
                        return;
                    }

                    UIViewController *topController =
                        keyWindow.rootViewController;

                    while (topController.presentedViewController) {
                        topController =
                            topController.presentedViewController;
                    }

                    if ([topController
                         isKindOfClass:[AshteWelcomeViewController class]]) {
                        return;
                    }

                    AshteWelcomeViewController *welcomeVC =
                        [[AshteWelcomeViewController alloc] init];

                    welcomeVC.modalPresentationStyle =
                        UIModalPresentationOverFullScreen;

                    welcomeVC.modalTransitionStyle =
                        UIModalTransitionStyleCrossDissolve;

                    [topController
                        presentViewController:welcomeVC
                        animated:NO
                        completion:nil];
                });
            });
        }];
    });
}
