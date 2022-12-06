//
//  OpenAppWithIDController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2022/11/19.
//

#import "OpenAppWithIDController.h"
#import "AppListViewController.h"

@interface OpenAppWithIDController ()

@end

@implementation OpenAppWithIDController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"打开指定应用";
    
    [self createButtonWithY:100 buttonTitle:@"选择App" action:@selector(selectApp)];
    [self createButtonWithY:160 buttonTitle:@"自行输入bundleId" action:@selector(openApp)];
    [self createButtonWithY:220 buttonTitle:@"打开微信" action:@selector(openWeChat)];
    [self createButtonWithY:280 buttonTitle:@"打开支付宝" action:@selector(openAliPay)];
    [self createButtonWithY:340 buttonTitle:@"打开抖音" action:@selector(openDouyin)];
}


- (void)selectApp{
    AppListViewController *appVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AppListViewController"];
    [appVC setCallBack:^(AppInfoModel * _Nonnull model) {
        [self openAppWithId:model.bundleId];
    }];
    [self.navigationController pushViewController:appVC animated:YES];
}

- (void)openApp{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"输入BundleId打开App" message:@"请输入bundleId" preferredStyle:(UIAlertControllerStyleAlert)];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入应用bundleId";
    }];

    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"打开" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString *bundleID = [[alertVC.textFields.firstObject text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self openAppWithId:bundleID];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)openWeChat{
    [self openAppWithId:@"com.tencent.xin"];
}
- (void)openAliPay{
    [self openAppWithId:@"com.alipay.iphoneclient"];
}
- (void)openDouyin{
    [self openAppWithId:@"com.ss.iphone.ugc.Aweme"];
}

- (void)createButtonWithY:(CGFloat)offsetY buttonTitle:(NSString *)btnTitle action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(50, offsetY, 200, 44);
    button.backgroundColor = [UIColor blackColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:btnTitle forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (BOOL)openAppWithId:(NSString *)bundleId{
    Class LSApplicationWorkspace  = NSClassFromString(@"LSApplicationWorkspace");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSObject * workspace = [LSApplicationWorkspace performSelector:@selector(defaultWorkspace)];
    BOOL isopen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:bundleId];
#pragma clang diagnostic pop
    
    if(!isopen){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"您未安装该App或者bundleId不正确" preferredStyle:(UIAlertControllerStyleAlert)];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"我已知晓" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    return isopen;
}

@end
