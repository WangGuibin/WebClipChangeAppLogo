//
//  GenerateAppLogoConfigViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/10/24.
//

#import "GenerateAppLogoConfigViewController.h"
#import <GCDWebServer.h>
#import "GCDWebServerDataResponse.h"
#import <SafariServices/SafariServices.h>
#import "AppListViewController.h"
#import <UIButton+WebCache.h>
#import <TZImagePickerController.h>
#import "FilesManagerViewController.h"
#import "ChageLogoMobileconfig.h"

//官方接口：
//1、通过appId获取信息
//https://itunes.apple.com/cn/lookup?id=应用ID
//2、通过应用名称获取信息
//https://itunes.apple.com/search?term=你的应用程序名称&entity=software

@interface GenerateAppLogoConfigViewController ()<SFSafariViewControllerDelegate>

@property (nonatomic, strong) GCDWebServer *webServer;


@property (weak, nonatomic) IBOutlet UITextField *bundleIdTextfield;
@property (weak, nonatomic) IBOutlet UITextField *URLTextfield;
@property (weak, nonatomic) IBOutlet UITextField *appNameTextfield;

@property (weak, nonatomic) IBOutlet UIButton *selectAppBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectIconBtn;
@property (weak, nonatomic) IBOutlet UISwitch *isRemoveSwitch;

@end

@implementation GenerateAppLogoConfigViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.webServer.isRunning){
        [self.webServer startWithPort:8090 bonjourName:nil];
    }
    self.selectAppBtn.layer.masksToBounds = YES;
    self.selectIconBtn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
    NSLog(@"%@",NSHomeDirectory());
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"文件" style:(UIBarButtonItemStylePlain) target:self action:@selector(skipFilesManagerPage)];
    if(self.iconImg){
        [self.selectIconBtn setBackgroundImage:self.iconImg forState:UIControlStateNormal];
        [self.selectIconBtn setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)skipFilesManagerPage{
    FilesManagerViewController *fileVC = [FilesManagerViewController new];
    [self.navigationController pushViewController:fileVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//获取APP信息
- (IBAction)getAppAction:(UIButton *)sender {
    AppListViewController *appVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AppListViewController"];
    [appVC setCallBack:^(AppInfoModel * _Nonnull model) {
        self.bundleIdTextfield.text = model.bundleId;
        self.appNameTextfield.text = model.trackName;
        [self.selectAppBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.artworkUrl512] forState:UIControlStateNormal];
        [self.selectAppBtn setTitle:@"" forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:appVC animated:YES];
    
}

//选择图标
- (IBAction)getIconDataAction:(UIButton *)sender {
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] init];
    pickerVC.maxImagesCount = 1;
    pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickerVC animated:YES completion:nil];
    [pickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.iconImg = photos.firstObject;
        [self.selectIconBtn setBackgroundImage:photos.firstObject forState:UIControlStateNormal];
        [self.selectIconBtn setTitle:@"" forState:UIControlStateNormal];
        
    }];
}


//生成描述文件并打开Safari
- (IBAction)createMobileConfig:(UIButton *)sender {
    [self.view endEditing:YES];
    [self createConfigFile];
}

- (void)createConfigFile{
    NSString *appName = self.appNameTextfield.text;
    NSString *bundleId = self.bundleIdTextfield.text;
    NSString *URL = [self.URLTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSData *iconData = UIImageJPEGRepresentation(self.iconImg, 0.7);
    NSString *base64Img = [iconData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    NSString *uuid1 = [NSUUID UUID].UUIDString;//随机1
    NSString *uuid2 = [NSUUID UUID].UUIDString;//随机2
    
    NSString *appconfigStr = [ChageLogoMobileconfig createOneAppConfigWithIcon:base64Img isRemoveFromDestop:self.isRemoveSwitch.on appName:appName uuid:uuid1 bundleId:bundleId URL:URL];
    NSString *fileString = [ChageLogoMobileconfig addConfigIntoGroupWithConfigs:appconfigStr appSetName:[NSString stringWithFormat:@"%@的桌面logo描述文件",appName] uuid:uuid2];

    NSString *fileName = [NSString stringWithFormat:@"%@.mobileconfig",appName];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:[fileString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }else{
        [fileString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSString *realStr = [fileName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:8090/%@",realStr];
    //这里只能是应用内访问 因为本地服务切到后台还要保活之类的 以及Safari能否访问沙盒犹未可知 大概是不行的 除非先把描述文件放到云端 然后打开Safari去访问云端那个地址
    SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    webVC.delegate = self;
    [self presentViewController:webVC animated:YES completion:nil];
    [self cleanPage];
}

//点击完成的时候 直接跳到设置去 URLScheme参考: https://gist.github.com/deanlyoung/368e274945a6929e0ea77c4eca345560
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-prefs:root=General&path=ManagedConfigurationList/PurgatoryInstallRequested"] options:@{} completionHandler:nil];
}

//重置页面数据
- (void)cleanPage{
    self.iconImg = nil;
    [self.selectAppBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.selectAppBtn setTitle:@"选取App" forState:UIControlStateNormal];
    [self.selectIconBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.selectIconBtn setTitle:@"选取图标" forState:UIControlStateNormal];
    self.appNameTextfield.text = nil;
}

- (GCDWebServer *)webServer {
    if (!_webServer) {
        _webServer = [[GCDWebServer alloc] init];
        [_webServer addGETHandlerForBasePath:@"/" directoryPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
    }
    return _webServer;
}

@end
