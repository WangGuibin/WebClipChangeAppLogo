//
//  CoreValuesToolViewController.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/12/19.
//

#import "CoreValuesToolViewController.h"
#import <WebKit/WebKit.h>
//社会主义核心价值观 (开源项目地址 https://github.com/sym233/core-values-encoder)

@interface CoreValuesToolViewController ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView1;
@property (weak, nonatomic) IBOutlet UITextView *textView2;
@property (nonatomic, strong) WKWebView *webView;


@end

@implementation CoreValuesToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.frame = self.view.bounds;
    self.webView.hidden = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"values-encoder/index.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"clickEncode"];
     [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"clickDecode"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self.webView configuration].userContentController  removeScriptMessageHandlerForName:@"clickEncode"];
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"clickDecode"];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

///MARK:- 编码
- (IBAction)encodeAction:(id)sender {
    // 参考源码的 index.html 和 /src/index.js  https://github.com/sym233/core-values-encoder
//    decoded-area 原文文本框  encoded-area 密文文本框
    // encode-btn 编码按钮  decode-btn 解码按钮
    // 前端项目hook到它的js对按钮操作 动态模拟它已有的操作 比如文本输入按钮点击等  类似爬虫行为
//    document.getElementById('encoded-area').value='值'; 设置或获取输入框的值
//    document.getElementById('encode-btn').click(); 模拟点击按钮 主动点击按钮
    NSString *js = [NSString stringWithFormat:@"document.getElementById('decoded-area').value='%@';document.getElementById('encode-btn').click();clickEncode()",self.textView1.text];
    [self.webView evaluateJavaScript:js completionHandler:^(id obj, NSError * _Nullable error) {
        
        
    }];
}

///MARK:- 解码
- (IBAction)decodeAction:(id)sender {
    NSString *js = [NSString stringWithFormat:@"document.getElementById('encoded-area').value='%@';document.getElementById('decode-btn').click();clickDecode()",self.textView2.text];
    [self.webView evaluateJavaScript:js completionHandler:^(id obj, NSError * _Nullable error) {
        
    }];
}


- (IBAction)copyCodeAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = sender.tag == 1? self.textView2.text : self.textView1.text;
}


- (IBAction)cleanAction:(UIButton *)sender {
    if (sender.tag == 1) {
        self.textView2.text = nil;
    }else{
        self.textView1.text = nil;
    }
}



- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

///JS执行window.webkit.messageHandlers.<方法名>.postMessage(<数据>).
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"方法名是message.name = %@ \n 参数message.body = %@",message.name,message.body);
    if ([message.name isEqualToString:@"clickEncode"]) {
        self.textView2.text = message.body;
    }
    
    if ([message.name isEqualToString:@"clickDecode"]) {
        self.textView1.text = message.body;
    }

}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
