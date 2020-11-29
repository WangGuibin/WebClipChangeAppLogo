//
//  SocialValuesEncoderDecoder.m
//  ChangeAppLogo
//
//  Created by 王贵彬 on 2020/11/29.
//

#import "SocialValuesEncoderDecoder.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface SocialValuesEncoderDecoder ()<WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *resultText;

@end

@implementation SocialValuesEncoderDecoder
static SocialValuesEncoderDecoder *_coder = nil;
+ (SocialValuesEncoderDecoder *)shareCoder{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _coder = [[SocialValuesEncoderDecoder alloc] init];
    });
    return _coder;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"values-encoder/index.html" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:req];
        [self addDelegate];
    }
    return self;
}

- (void)addDelegate{
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"clickEncode"];
     [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"clickDecode"];
}

- (void)removeDelegate{
    [[self.webView configuration].userContentController  removeScriptMessageHandlerForName:@"clickEncode"];
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"clickDecode"];
}

- (void)setIsEncode:(BOOL)isEncode{
    _isEncode = isEncode;
}

- (void)sendCovertJS{
    if (self.isEncode) {
        [self sendEncodeJS];
    }else{
        [self sendDecodeJS];
    }
}

- (void)sendEncodeJS{
    NSString *js = [NSString stringWithFormat:@"document.getElementById('decoded-area').value='%@';document.getElementById('encode-btn').click();",self.text];
    [self.webView evaluateJavaScript:js completionHandler:^(id obj, NSError * _Nullable error) {
        
    }];
}

- (void)sendDecodeJS{
    NSString *js = [NSString stringWithFormat:@"document.getElementById('encoded-area').value='%@';document.getElementById('decode-btn').click();",self.text];
    [self.webView evaluateJavaScript:js completionHandler:^(id obj, NSError * _Nullable error) {
        
    }];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIViewController *vc = [UIViewController new];
        _webView.hidden = YES;
        [vc.view addSubview:_webView];
    }
    return _webView;
}

///JS执行window.webkit.messageHandlers.<方法名>.postMessage(<数据>).
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"方法名是message.name = %@ \n 参数message.body = %@",message.name,message.body);
//    if ([message.name isEqualToString:@"clickEncode"]) {
//
//    }
//
//    if ([message.name isEqualToString:@"clickDecode"]) {
//    }
    
    !self.callBackResultBlock? : self.callBackResultBlock(message.body);
}




@end
