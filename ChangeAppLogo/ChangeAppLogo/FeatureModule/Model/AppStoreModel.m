//
//  AppStoreModel.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/10/24.
//

#import "AppStoreModel.h"

@implementation AppInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"desc"  : @"description"
             };
}

@end

@implementation AppStoreModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"results" : [AppInfoModel class]
    };
}


// 搜索🔍APP 获取APP数据
+ (void)getAppInfoFromAppStoreWithAppName:(NSString *)appName
                                 callBack:(void(^)(AppStoreModel *AppModel))callBack{
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&entity=software&country=cn",appName];
    NSString *realStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:realStr];
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"POST";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                AppStoreModel *model = [AppStoreModel yy_modelWithDictionary:dic];
                !callBack? : callBack(model);
            }else{
                NSLog(@"%@",error);
            }
        });
    }];
    [task resume];
}

@end
