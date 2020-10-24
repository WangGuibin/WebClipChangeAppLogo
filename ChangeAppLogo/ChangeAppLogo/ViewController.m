//
//  ViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/10/24.
//

#import "ViewController.h"
#import <GCDWebServer.h>
#import "GCDWebServerDataResponse.h"
#import <SafariServices/SafariServices.h>
#import "AppListViewController.h"
#import <UIButton+WebCache.h>
#import <TZImagePickerController.h>

//官方接口：
//1、通过appId获取信息
//https://itunes.apple.com/lookup?id=应用ID
//2、通过应用名称获取信息
//https://itunes.apple.com/search?term=你的应用程序名称&entity=software

@interface ViewController ()

@property (nonatomic, strong) GCDWebServer *webServer;

@property (weak, nonatomic) IBOutlet UITextField *appNameTextfield;
@property (weak, nonatomic) IBOutlet UIButton *selectAppBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectIconBtn;

@property (nonatomic, strong) AppInfoModel *currentModel;
@property (nonatomic, strong) UIImage *iconImg;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectAppBtn.layer.masksToBounds = YES;
    self.selectIconBtn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
    NSLog(@"%@",NSHomeDirectory());
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//获取APP信息
- (IBAction)getAppAction:(UIButton *)sender {
    AppListViewController *appVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AppListViewController"];
    [appVC setCallBack:^(AppInfoModel * _Nonnull model) {
        self.currentModel = model;
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
    if(!self.webServer.isRunning){
        [self.webServer startWithPort:8090 bonjourName:nil];
    }
    [self createConfigFile];
}


- (void)createConfigFile{
    NSString *appName = self.appNameTextfield.text? : self.currentModel.trackName;
    NSString *bundleId = self.currentModel.bundleId;
    
    
    NSData *iconData = UIImageJPEGRepresentation(self.iconImg, 0.7);
    NSString *base64Img = [iconData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    NSString *iconText = [NSString stringWithFormat:@"<key>Icon</key><data>%@</data>",base64Img];
    if (!base64Img.length) {
        iconText = @"";
    }

    NSString *uuid1 = [NSUUID UUID].UUIDString;
    NSString *uuid2 = [NSUUID UUID].UUIDString;
    NSString *isRemove = @"true";
    NSString *fileString = [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE plist PUBLIC '-//Apple//DTD PLIST 1.0//EN' 'http://www.apple.com/DTDs/PropertyList-1.0.dtd'><plist version='1.0'><dict><key>PayloadContent</key><array><dict><key>FullScreen</key><true/><key>IsRemovable</key><%@/>%@<key>Label</key><string>%@</string><key>PayloadDescription</key><string>Configures settings for a Web Clip</string><key>PayloadDisplayName</key><string>Web Clip</string><key>PayloadIdentifier</key><string>%@.apple.webClip.managed.%@</string><key>PayloadType</key><string>com.apple.webClip.managed</string><key>PayloadUUID</key><string>%@</string><key>PayloadVersion</key><real>1</real><key>Precomposed</key><true/><key>URL</key><string>未知</string>            <key>TargetApplicationBundleIdentifier</key><string>%@</string><key>Precomposed</key><true/></dict></array><key>PayloadDisplayName</key><string>%@描述文件</string><key>PayloadIdentifier</key><string>%@</string><key>PayloadRemovalDisallowed</key><false/><key>PayloadType</key><string>Configuration</string><key>PayloadUUID</key><string>%@</string><key>PayloadVersion</key><integer>1</integer></dict></plist>",isRemove,iconText,appName,uuid1,uuid1,uuid2,bundleId,appName,uuid2,uuid2];
    
        NSString *fileName = [NSString stringWithFormat:@"%@.mobileconfig",appName];
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] createFileAtPath:path contents:[fileString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }else{
            [fileString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }

    NSString *realStr = [fileName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:8090/%@",realStr];
    SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self presentViewController:webVC animated:YES completion:nil];
    [self cleanPage];
}

//重置页面数据
- (void)cleanPage{
    self.currentModel = nil;
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
