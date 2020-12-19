//
//  AppMainViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/6.
//

#import "AppMainViewController.h"
#import "CategoriesViewController.h"
#import "SFSymbolDatasource.h"

@interface AppMainViewController ()

@end

@implementation AppMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [SFSymbolDatasource setSelectMode:NO];
        CategoriesViewController *vc = [CategoriesViewController new];
        UINavigationController *nvc = [UINavigationController.alloc initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }
    
}

@end
