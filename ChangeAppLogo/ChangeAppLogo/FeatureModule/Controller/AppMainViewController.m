//
//  AppMainViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/6.
//

#import "AppMainViewController.h"
#import "CategoriesViewController.h"
#import "SFSymbolDatasource.h"
#import "OpenAppWithIDController.h"
#import "InstalledAppListViewController.h"
#import "InstalledAppManager.h"
#import "SGWiFiUploadManager.h"

@interface AppMainViewController ()<NSURLSessionDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic) BOOL isBackGround;
@property (nonatomic,assign) BOOL isStartUploadFileService;


@end

@implementation AppMainViewController
{
    UIBackgroundTaskIdentifier bgTask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加书签" style:(UIBarButtonItemStylePlain) target:self action:@selector(addBookMark)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}



- (void)addBookMark{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://run.mocky.io/v3/b2075aee-16d9-4187-9830-045d771362d0"] options:@{} completionHandler:^(BOOL success) {
        
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [SFSymbolDatasource setSelectMode:NO];
        CategoriesViewController *vc = [CategoriesViewController new];
        UINavigationController *nvc = [UINavigationController.alloc initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }
    
    if(indexPath.row == 4){
        [self.navigationController pushViewController:[OpenAppWithIDController new] animated:YES];
    }
    
    if(indexPath.row == 5){
        if([InstalledAppManager share].isLoaded){
            [self.navigationController pushViewController:[InstalledAppListViewController new] animated:YES];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请稍等,应用数据还未加载完毕" preferredStyle:(UIAlertControllerStyleAlert)];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"OK👌" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
    
    if(indexPath.row == 6){
        [self setupServer];
    }
    
}

- (void)setupServer {
    self.isStartUploadFileService = YES;
    SGWiFiUploadManager *mgr = [SGWiFiUploadManager sharedManager];
    BOOL success = [mgr startHTTPServerAtPort:10086];
    //报存到Documents目录下
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    mgr.savePath = path;
    if (success) {
        [mgr setFileUploadStartCallback:^(NSString *fileName, NSString *savePath) {
            NSLog(@"File %@ Upload Start", fileName);
        }];
        [mgr setFileUploadProgressCallback:^(NSString *fileName, NSString *savePath, CGFloat progress) {
            NSLog(@"File %@ on progress %f", fileName, progress);
        }];
        [mgr setFileUploadFinishCallback:^(NSString *fileName, NSString *savePath) {
            NSLog(@"File Upload Finish %@ at %@", fileName, savePath);
        }];
    }
    [mgr showWiFiPageFrontViewController:self dismiss:^{
        [mgr stopHTTPServer];
        self.isStartUploadFileService = NO;
    }];
}


//进入前台
- (void)handleEnterForeground {
    self.isBackGround = NO;
    [[UIApplication sharedApplication] endBackgroundTask:self->bgTask];
    [self endBackgroundTask];
}

//进入后台
- (void)handleEnterBackground {
    self.isBackGround = YES;
    [self startBackgroundTask];
}

- (void)endBackgroundTask {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->bgTask != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:self->bgTask];
            self->bgTask = UIBackgroundTaskInvalid;
        }
    });
}


- (void)startBackgroundTask{
    if(!self.isStartUploadFileService){
        return;
    }
    // begin和end成对出现
    self->bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"后台任务超时了~ ");
            [self endBackgroundTask];
        }];
        
    //10秒之后打印一下还剩多长时间 实测只有30秒左右后台运行任务时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"还有 %f 秒后台任务时间 ",[UIApplication sharedApplication].backgroundTimeRemaining);
    });
    /*
     2023-04-02 19:44:37.733245+0800 ChangeAppLogo[50445:2495835] 还有 19.749675 秒后台任务时间
     2023-04-02 19:44:52.831116+0800 ChangeAppLogo[50445:2495835] 后台任务超时了~
     */
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 执行需要在后台进行的任务 执行完任务end掉这个任务
//            [self beginDownload];
        });
}


//后台任务
- (NSURLSession *)backgroundSession{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.ios.appId.BackgroundSession"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}
- (void)beginDownload{
    //弄个假地址 不耗流量重复请求
    NSURL *downloadURL = [NSURL URLWithString:@"downloadsString"];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    self.session = [self backgroundSession];
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{
    completionHandler();
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location{

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (self.isBackGround) {
        [self endBackgroundTask];//停止掉
        [self startBackgroundTask];//重新开
    }
}

@end
