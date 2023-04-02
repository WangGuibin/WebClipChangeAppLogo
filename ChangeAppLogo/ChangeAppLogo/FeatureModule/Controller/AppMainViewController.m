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

@interface AppMainViewController ()

@end

@implementation AppMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加书签" style:(UIBarButtonItemStylePlain) target:self action:@selector(addBookMark)];
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
    
    
    
    
}

@end
