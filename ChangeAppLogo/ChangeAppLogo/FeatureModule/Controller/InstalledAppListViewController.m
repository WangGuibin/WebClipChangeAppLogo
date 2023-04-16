//
//  InstalledAppListViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2022/11/19.
//

#import "InstalledAppListViewController.h"
#import "InstalledAppManager.h"

@interface InstalledAppListViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation InstalledAppListViewController


- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的应用";
    self.dataSource = [InstalledAppManager share].installedApps;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.dataSource.count){
        self.dataSource = [InstalledAppManager share].installedApps;
        [self.tableView reloadData];
    }
}


#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    }
    AppInfoModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ v%@",model.trackName,model.version];
    cell.detailTextLabel.text = model.bundleId;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppInfoModel *model = self.dataSource[indexPath.row];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"操作" message:@"拷贝bundleId或者打开应用" preferredStyle:(UIAlertControllerStyleAlert)];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拷贝bundleId" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
         [UIPasteboard generalPasteboard].string = model.bundleId;
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.label.text = @"拷贝成功!";
        [HUD hideAnimated:YES afterDelay:1.5];
    }]];

    [alertVC addAction:[UIAlertAction actionWithTitle:@"打开" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self openAppWithId:model.bundleId];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (BOOL)openAppWithId:(NSString *)bundleId{
    BOOL isOpen = [[InstalledAppManager share] openAppWithId:bundleId];
    if(!isOpen){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"您未安装该App或者bundleId不正确" preferredStyle:(UIAlertControllerStyleAlert)];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"我已知晓" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    return isOpen;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0f;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
