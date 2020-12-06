//
//  CustomLogoViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/6.
//

#import "CustomLogoViewController.h"
#import "CategoriesViewController.h"
#import "SFSymbolDatasource.h"
#import "SelectColorViewController.h"

@interface CustomLogoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (nonatomic, copy) NSString *symoblName;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) UIImageSymbolWeight imgWeight;

@end

@implementation CustomLogoViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kCallBackSymoblsResultNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.symoblName = @"sunrise.fill";
    self.imgWeight = UIImageSymbolWeightHeavy;
    self.tintColor = [UIColor greenColor];
    self.bgColor = [UIColor cyanColor];
    [self previewLogoAction];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLogoNote:) name:@"kCallBackSymoblsResultNotification" object:nil];
}

///MARK:- 选取图标结果
- (void)getLogoNote:(NSNotification *)note{
    self.symoblName = note.object;
    self.imgWeight = preferredImageSymbolWeight();
    [self previewLogoAction];
}

///MARK:- 预览
- (void)previewLogoAction{
    UIImage *image = [UIImage systemImageNamed:self.symoblName withConfiguration:[UIImageSymbolConfiguration configurationWithWeight:self.imgWeight]];
    self.logoImageView.tintColor = self.tintColor;
    self.logoImageView.backgroundColor = self.bgColor;
    self.logoImageView.image = image;
}

- (IBAction)selectLogoAction:(UIButton *)sender {
    CategoriesViewController *vc = [CategoriesViewController new];
    UINavigationController *nvc = [UINavigationController.alloc initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)pickerThinBoldAction:(UIButton *)sender {
    self.imgWeight += 1;
    if (self.imgWeight > 9) {
        self.imgWeight = 0;
    }
    [self previewLogoAction];
}

- (IBAction)selectTintColorAction:(UIButton *)sender {
    SelectColorViewController *selectColorVC = [SelectColorViewController new];
    [self presentViewController:selectColorVC animated:YES completion:nil];
    [selectColorVC setCallBackBlock:^(UIColor *color) {
        self.tintColor = color;
        [self previewLogoAction];
    }];
}

- (IBAction)selectBackgroundColorAction:(UIButton *)sender {
    SelectColorViewController *selectColorVC = [SelectColorViewController new];
    [self presentViewController:selectColorVC animated:YES completion:nil];
    [selectColorVC setCallBackBlock:^(UIColor *color) {
        self.bgColor = color;
        [self previewLogoAction];
    }];
}

- (IBAction)generateConfigAction:(UIButton *)sender {
    UIImage *image = [self snapshotImageWithView:self.logoImageView];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
   MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (error) {
        HUD.label.text = error.localizedDescription;
    }else{
        HUD.label.text = @"已成功保存至相册!";
    }
    [HUD hideAnimated:YES afterDelay:1.5];
}


- (UIImage *)snapshotImageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end
