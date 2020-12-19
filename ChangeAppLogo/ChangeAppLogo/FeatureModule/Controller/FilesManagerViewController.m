//
//  FilesManagerViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/10/24.
//

#import "FilesManagerViewController.h"
#import <SafariServices/SafariServices.h>

@interface FilesManagerViewController () <UITableViewDelegate, UITableViewDataSource,SFSafariViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *configs;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation FilesManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"已生成的描述文件";
    self.tableView.tableFooterView = [UIView new];

    NSString *rootPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray<NSString*> *pathArr = [manager contentsOfDirectoryAtPath:rootPath error:nil];
    for (NSString *path in pathArr) {
        if (![path hasPrefix:@"."]) {
            [self.configs addObject:path];
        }
    }
    [self.tableView reloadData];
    self.tipsLabel.frame = self.tableView.bounds;
    self.tipsLabel.hidden = self.configs.count;
}


//点击完成的时候
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
//    App-prefs:root=General&path=ManagedConfigurationList/PurgatoryInstallRequested
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-prefs:root=General&path=ManagedConfigurationList/PurgatoryInstallRequested"] options:@{} completionHandler:nil];
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.configs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"config"];
    cell.textLabel.text = self.configs[indexPath.row];
    return cell;
}

#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *path = self.configs[indexPath.row];
    NSString *realStr = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"http://127.0.0.1:8090/%@",realStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:url];
    sfVC.delegate = self;
    [self presentViewController:sfVC animated:YES completion:nil];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *path = self.configs[indexPath.row];
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",path]];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        [self.configs removeObject:path];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
        if (self.configs.count == 0) {
            [self.tableView reloadData];
            self.tipsLabel.hidden = NO;
        }
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tabY = UIApplication.sharedApplication.statusBarFrame.size.height+44;
        CGFloat safeHeight = 0;
        if (@available(iOS 11.0, *)) {
            safeHeight = self.view.safeAreaInsets.bottom;
        }

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tabY, self.view.bounds.size.width, self.view.bounds.size.height - tabY - safeHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (NSMutableArray *)configs {
    if (!_configs) {
        _configs = [[NSMutableArray alloc] init];
    }
    return _configs;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = [UIColor blackColor];
        _tipsLabel.font = [UIFont systemFontOfSize:15];
        _tipsLabel.text = @"暂无文件";
        [self.tableView addSubview:_tipsLabel];
    }
    return  _tipsLabel;
}

@end
