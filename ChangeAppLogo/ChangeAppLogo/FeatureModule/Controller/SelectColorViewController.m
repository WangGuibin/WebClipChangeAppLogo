//
//  SelectColorViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/6.
//

#import "SelectColorViewController.h"
#import <LSLHSBColorPickerView.h>

@interface SelectColorViewController ()

@end

@implementation SelectColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    LSLHSBColorPickerView *pickerView = [[LSLHSBColorPickerView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:pickerView];
    [pickerView colorSelectedBlock:^(UIColor *color, BOOL isConfirm) {
        !self.callBackBlock? : self.callBackBlock(color);
    }];
}

@end
