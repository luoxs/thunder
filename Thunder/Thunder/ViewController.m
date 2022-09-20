//
//  ViewController.m
//  Thunder
//
//  Created by apple on 2022/9/14.
//

#import "ViewController.h"
#import "SDAutoLayout.h"
#import "BoardViewController.h"
#import "Socket.h"
#import "MBProgressHUD.h"

@interface ViewController ()<SocketDelegate>
@property (strong, nonatomic)Socket *header;
@property (nonatomic,retain) MBProgressHUD *HUD;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  setAutoLayout];
    self.HUD = [[MBProgressHUD alloc] init];
    self.header = [Socket sharedInstance];
    self.header.delegate = self;
}

-(void)setAutoLayout{
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *ivBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camp.jpg"]];
    [self.view addSubview:ivBack];
    ivBack.sd_layout
    .topSpaceToView(self.view, 10.0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightRatioToView(self.view, 0.8);
    
    
    UIImageView *ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [ivBack addSubview:ivLogo];
    ivLogo.sd_layout
    .topSpaceToView(ivBack, 50.0)
    .centerXEqualToView(ivBack)
    .widthRatioToView(self.view, 0.8)
    .autoHeightRatio(945.0/2362.0);
    
    UIButton *btEnter = [[UIButton alloc]init];
    [self.view addSubview:btEnter];
    btEnter.sd_layout
        .topSpaceToView(ivBack, 20.0)
        .centerXEqualToView(self.view)
        .widthRatioToView(self.view, 0.4)
        .autoHeightRatio(0.4);
    
    [btEnter setBackgroundColor:[UIColor blackColor]];
    [btEnter setTitle:@"ENTER" forState:UIControlStateNormal];
    btEnter.titleLabel.font = [UIFont systemFontOfSize:24];
    [btEnter setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btEnter addTarget:self action:@selector(connetWiFi:) forControlEvents:UIControlEventTouchUpInside];
   
    //[btBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) connetWiFi:(id)sender{
    [self.header socketConnectHost];
    [self.view addSubview:self.HUD];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.label.text = @"连接设备中……";
    [self.HUD showAnimated:YES];
    /*
    BoardViewController  *boardV = [[BoardViewController alloc] init];
    if(1){
        [self presentViewController:boardV animated:YES completion:^{
            NSLog(@"openviewcontroller");
        }];
    }
    */
}


-(void)onConnected{
    [self.HUD  hideAnimated:YES];
    [self.HUD  removeFromSuperview];
    [self performSegueWithIdentifier:@"enterBoard" sender:self];
    //初始化数据
    //[self.header initData];
}

-(void)onConnectFailed{
  
    [self.HUD  hideAnimated:YES];
    [self.HUD   removeFromSuperview];
    
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle: NSLocalizedString(@"Alert", nil)
                               message: NSLocalizedString(@"Please connect WiFi in the settings", nil)
                               preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }
    }]];
    //弹出提示框
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)OnDidReadData{
    NSLog(@"read data successful!----entrance");
    /*
    if(self.header.dataRead.type == 0x00){
         [self performSegueWithIdentifier:@"showSingle" sender:self]; //单冷冰箱
    }else if(self.header.dataRead.type == 0x01){
         [self performSegueWithIdentifier:@"showDouble" sender:self]; //冷热冰箱
    }else{
         [self performSegueWithIdentifier:@"showDouble" sender:self]; //双冷冰箱？
    }*/
}

-(void)viewWillDisappear:(BOOL)animated{
    self.header.delegate = nil;
}

@end
