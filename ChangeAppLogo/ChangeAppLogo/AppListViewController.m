//
//  AppListViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/10/24.
//

#import "AppListViewController.h"
#import <UIImageView+WebCache.h>

@interface AppCell : UITableViewCell

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *appNameLabel;

@end


@implementation AppCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.logoImgView.layer.cornerRadius = 5.0f;
        self.logoImgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.logoImgView];
        [self.contentView addSubview:self.appNameLabel];
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout {
    CGFloat cellW = UIScreen.mainScreen.bounds.size.width;
    self.logoImgView.frame = CGRectMake(10, 10, 60 , 60);
    self.appNameLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImgView.frame) + 10, 25, cellW - 100 , 30);
    
}

- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] initWithImage:nil];
        _logoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImgView.clipsToBounds = YES;
    }
    return _logoImgView;
}

- (UILabel *)appNameLabel {
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _appNameLabel.textAlignment = NSTextAlignmentLeft;
        _appNameLabel.textColor = [UIColor blackColor];
        _appNameLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return  _appNameLabel;
}

@end


@interface AppListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *appNameTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AppStoreModel *bigModel;

@end

@implementation AppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[AppCell class] forCellReuseIdentifier:NSStringFromClass([AppCell class])];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)searchAction:(id)sender {
    [self.view endEditing:YES];
    if (!self.appNameTF.text.length) {
        return;
    }
    [AppStoreModel getAppInfoFromAppStoreWithAppName:self.appNameTF.text callBack:^(AppStoreModel * _Nonnull AppModel) {
        self.bigModel = AppModel;
        self.appNameTF.text = nil;
        [self.tableView reloadData];
    }];
}

#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bigModel.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([AppCell class])];
    AppInfoModel *model = self.bigModel.results[indexPath.row];
    cell.appNameLabel.text = model.trackName;
    [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:model.artworkUrl60] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
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
