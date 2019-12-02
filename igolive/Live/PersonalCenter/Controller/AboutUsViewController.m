//
//  AboutUsViewController.m
//  igolive
//
//  Created by 高翔 on 16/8/26.
//  Copyright © 2016年 iGoLive LLC. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ServerURL.h"

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBakcBtn];
    [self initWebView];
}

- (void)initBakcBtn {
//    UIButton *backBtn = [[UIButton alloc] init];
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backButtonClick)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)initWebView {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[ServerURL aboutUsUrl]]];
}

- (void)backButtonClick {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
