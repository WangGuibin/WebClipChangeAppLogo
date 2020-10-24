//
//  AppListViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/10/24.
//

#import "AppListViewController.h"
#import <UIImageView+WebCache.h>
@interface AppListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *appNameTF;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) AppStoreModel *bigModel;

@end

@implementation AppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (IBAction)searchAction:(id)sender {
    if (!self.appNameTF.text.length) {
        return;
    }
    [AppStoreModel getAppInfoFromAppStoreWithAppName:self.appNameTF.text callBack:^(AppStoreModel * _Nonnull AppModel) {
        self.bigModel = AppModel;
        self.appNameTF.text = nil;
        [self.tableview reloadData];
    }];
}

#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bigModel.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    AppInfoModel *model = self.bigModel.results[indexPath.row];
    cell.textLabel.text = model.trackName;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.artworkUrl100] placeholderImage:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppInfoModel *model = self.bigModel.results[indexPath.row];
    !self.callBack? : self.callBack(model);
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

@end
