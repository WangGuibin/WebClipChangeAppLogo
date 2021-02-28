//
//  CustomLogoViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/6.
//

#import "CustomLogoViewController.h"
#import "CategoriesViewController.h"
#import "SFSymbolDatasource.h"
#import "GenerateAppLogoConfigViewController.h"
#import <TZImagePickerController.h>

@interface CustomLogoViewController ()<UIColorPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (nonatomic, copy) NSString *symoblName;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) BOOL isClickBgColorFlag;
@property (nonatomic, assign) UIImageSymbolWeight imgWeight;

@property (nonatomic, assign) BOOL isSFSymbols;
@property (nonatomic, strong) UIImage *iconImage;//相册所选图片

@end

@implementation CustomLogoViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kCallBackSymoblsResultNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isSFSymbols = YES;
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
    if (self.isSFSymbols) {
        UIImage *image = [UIImage systemImageNamed:self.symoblName withConfiguration:[UIImageSymbolConfiguration configurationWithWeight:self.imgWeight]];
        self.logoImageView.image = image;
    }else{
        self.logoImageView.image = self.iconImage;
    }
    self.logoImageView.tintColor = self.tintColor;
    self.logoImageView.backgroundColor = self.bgColor;
}

- (IBAction)selectLogoAction:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"操作提示" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *createLogoAction = [UIAlertAction actionWithTitle:@"从相册获取图标" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.isSFSymbols = NO;
        TZImagePickerController *pickerVC = [[TZImagePickerController alloc] init];
        pickerVC.maxImagesCount = 1;
        pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:pickerVC animated:YES completion:nil];
        [pickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.iconImage = photos.firstObject;
            [self previewLogoAction];
        }];
    }];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"从系统获取SF Symbols图标" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.isSFSymbols = YES;
        [SFSymbolDatasource setSelectMode:YES];
        CategoriesViewController *vc = [CategoriesViewController new];
        UINavigationController *nvc = [UINavigationController.alloc initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:createLogoAction];
    [alertVC addAction:saveAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];

}

- (IBAction)pickerThinBoldAction:(UIButton *)sender {
    self.imgWeight += 1;
    if (self.imgWeight > 9) {
        self.imgWeight = 0;
    }
    [self previewLogoAction];
}

- (IBAction)selectTintColorAction:(UIButton *)sender {
    self.isClickBgColorFlag = NO;
    UIColorPickerViewController *colorSelectVC = [UIColorPickerViewController new];
    colorSelectVC.delegate = self;
    [self presentViewController:colorSelectVC animated:YES completion:nil];
}

- (IBAction)selectBackgroundColorAction:(UIButton *)sender {
    self.isClickBgColorFlag = YES;
    UIColorPickerViewController *colorSelectVC = [UIColorPickerViewController new];
    colorSelectVC.delegate = self;
    [self presentViewController:colorSelectVC animated:YES completion:nil];
}
///MARK:- <UIColorPickerViewControllerDelegate>
/// Called when the `selectedColor` changes. 实时获取改变的颜色
- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController{
    
}
/// animate alongside the dismissal. 选择完成之后的颜色
- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController{
    if (self.isClickBgColorFlag) {
        self.bgColor = viewController.selectedColor;
    }else{
        self.tintColor = viewController.selectedColor;
    }
    [self previewLogoAction];
}


- (IBAction)generateConfigAction:(UIButton *)sender {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"操作提示" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *createLogoAction = [UIAlertAction actionWithTitle:@"去生成Logo配置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UIImage *image = [self snapshotImageWithView:self.logoImageView];
        GenerateAppLogoConfigViewController *configVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GenerateAppLogoConfigViewController"];
        configVC.iconImg = image;
        [self.navigationController pushViewController:configVC animated:YES];
    }];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存图标" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UIImage *image = [self snapshotImageWithView:self.logoImageView];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:createLogoAction];
    [alertVC addAction:saveAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
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
