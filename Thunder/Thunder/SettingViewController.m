//
//  SettingViewController.m
//  Thunder
//
//  Created by apple on 2022/9/15.
//

#import "SettingViewController.h"
#import "SDAutoLayout.h"
#import "Socket.h"
#import "MBProgressHUD.h"

@interface SettingViewController ()<SocketDelegate>
@property (strong, nonatomic)Socket *header;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  setAutoLayout];
    self.header = [Socket sharedInstance];
    self.header.delegate = self;
    [self.header initDevice];
    [self.header initData];   //获取初始化数据
}

-(void)setAutoLayout{
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef ref = CGColorCreate(colorSpaceRef, (CGFloat[]){1,1,1,1}); //设置按钮的边界颜色
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIImageView *ivLogoBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ThunderBack.jpg"]];
    [self.view addSubview:ivLogoBack];
    ivLogoBack.sd_layout
        .topSpaceToView(self.view, 0.0)
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightRatioToView(self.view, 0.18);
    
    UIImageView *ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [ivLogoBack addSubview:ivLogo];
    ivLogo.sd_layout
        .centerXEqualToView(ivLogoBack)
        .centerYEqualToView(ivLogoBack)
        .heightRatioToView(ivLogoBack, 0.6)
        .autoWidthRatio(2362.0/945.0);
    
    UIView *vback = [[UIView alloc ] init];
    [vback setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:89.0/255.0 blue:129.0/255.0 alpha:1]];
    [self.view addSubview:vback];
    vback.sd_layout
        .topSpaceToView(ivLogoBack, 0)
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightRatioToView(self.view, 0.68);
    
    UIButton *btReturn = [[UIButton alloc]init];
    [vback addSubview:btReturn];
    btReturn.sd_layout
        .topSpaceToView(vback, 8.0)
        .leftSpaceToView(vback, 4.0)
        .widthRatioToView(vback,0.3)
        .autoHeightRatio(0.4);
    [btReturn setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:89.0/255.0 blue:129.0/255.0 alpha:1]];
    [btReturn setTitle:@"<Back" forState:UIControlStateNormal];
    btReturn.titleLabel.font = [UIFont systemFontOfSize:24];
    [btReturn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btReturn addTarget:self action:@selector(toBoard:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //wifi setting
    UILabel  *lbWiFi = [[UILabel alloc]init];
    [vback addSubview:lbWiFi];
    lbWiFi.sd_layout
        .topSpaceToView(vback, self.view.frame.size.height/10)
        .leftSpaceToView(vback, self.view.frame.size.width/20);
    lbWiFi.text = @"WiFi Setting";
    lbWiFi.textColor = [UIColor whiteColor];
    [lbWiFi setFont:[UIFont fontWithName:@"Arial" size:22.0]];
    [lbWiFi setSingleLineAutoResizeWithMaxWidth:200];
   
    UIButton  *btWiFi = [[UIButton alloc]init];
    [vback addSubview:btWiFi];
    btWiFi.sd_layout
        .centerYEqualToView(lbWiFi)
        .heightRatioToView(lbWiFi, 0.5)
        .widthRatioToView(self.view, 0.2)
        .rightSpaceToView(vback, self.view.frame.size.width/20);
    [btWiFi setTitle:@">" forState:UIControlStateNormal];
    btWiFi.titleLabel.font = [UIFont systemFontOfSize:22];
    btWiFi.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [btWiFi.layer setCornerRadius:10];
    [btWiFi.layer setBorderWidth:2];//设置边界的宽度
    [btWiFi.layer setBorderColor:ref];
    
    //unit setting
    UILabel  *lbUnit = [[UILabel alloc]init];
    [vback addSubview:lbUnit];
    lbUnit.sd_layout
        .topSpaceToView(vback, self.view.frame.size.height/5.8)
        .leftSpaceToView(vback, self.view.frame.size.width/20);
    lbUnit.text = @"Temperature Unit";
    lbUnit.textColor = [UIColor whiteColor];
    [lbUnit setFont:[UIFont fontWithName:@"Arial" size:22.0]];
    [lbUnit setSingleLineAutoResizeWithMaxWidth:200];
    
    UIButton  *btUnit = [[UIButton alloc]init];
    [vback addSubview:btUnit];
    btUnit.sd_layout
        .centerYEqualToView(lbUnit)
        .heightRatioToView(lbWiFi, 0.5)
        .widthRatioToView(self.view, 0.2)
        .rightSpaceToView(vback, self.view.frame.size.width/20);
    [btUnit setTitle:@"℃" forState:UIControlStateNormal];
    btUnit.titleLabel.font = [UIFont systemFontOfSize:22];
    btUnit.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [btUnit.layer setCornerRadius:10];
    [btUnit.layer setBorderWidth:2];//设置边界的宽度
    [btUnit.layer setBorderColor:ref];
    
    //mode setting
    UILabel  *lbMode = [[UILabel alloc]init];
    [vback addSubview:lbMode];
    lbMode.sd_layout
        .topSpaceToView(vback, self.view.frame.size.height/4)
        .leftSpaceToView(vback, self.view.frame.size.width/20);
    lbMode.text = @"Mode";
    lbMode.textColor = [UIColor whiteColor];
    [lbMode setFont:[UIFont fontWithName:@"Arial" size:22.0]];
    [lbMode setSingleLineAutoResizeWithMaxWidth:200];
    
    UIButton  *btmode = [[UIButton alloc]init];
    [vback addSubview:btmode];
    btmode.sd_layout
        .centerYEqualToView(lbMode)
        .heightRatioToView(lbWiFi, 0.5)
        .widthRatioToView(self.view, 0.2)
        .rightSpaceToView(vback, self.view.frame.size.width/20);
    [btmode setTitle:@"Eco" forState:UIControlStateNormal];
    btmode.titleLabel.font = [UIFont systemFontOfSize:22];
    btmode.titleLabel.textAlignment = NSTextAlignmentRight;
    
    //[btmode.layer setMasksToBounds:NO];
    [btmode.layer setCornerRadius:10];
    [btmode.layer setBorderWidth:2];//设置边界的宽度
    [btmode.layer setBorderColor:ref];
    
    //开
    UIButton *btON = [[UIButton alloc]init];
    [vback addSubview:btON];
    btON.sd_layout
        .bottomSpaceToView(vback, self.view.frame.size.height/15)
        .leftSpaceToView(vback,self.view.frame.size.width/5.5)
        .widthRatioToView(self.view,0.23)
        .autoHeightRatio(0.618);
    
    [btON.layer setCornerRadius:10];
    [btON.layer setBorderWidth:2];//设置边界的宽度
    [btON.layer setBorderColor:ref];
    
    [btON setTitle:@"ON" forState:UIControlStateNormal];
    btON.titleLabel.font = [UIFont systemFontOfSize:22];
    [btON addTarget:self action:@selector(setOn:) forControlEvents:UIControlEventTouchUpInside];
    [btON setBackgroundColor:[UIColor colorWithRed:48.0/255 green:186.0/255 blue:195.0/255 alpha:1.0]];
    
    //关
    UIButton *btOFF = [[UIButton alloc]init];
    [vback addSubview:btOFF];
    btOFF.sd_layout
        .bottomSpaceToView(vback, self.view.frame.size.height/15)
        .rightSpaceToView(vback,self.view.frame.size.width/5.5)
        .widthRatioToView(self.view,0.23)
        .autoHeightRatio(0.618);
    [btOFF.layer setCornerRadius:10];
    [btOFF.layer setBorderWidth:2];//设置边界的宽度
    [btOFF.layer setBorderColor:ref];
    [btOFF setTitle:@"OFF" forState:UIControlStateNormal];
    btOFF.titleLabel.font = [UIFont systemFontOfSize:22];
    [btOFF addTarget:self action:@selector(setOff:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel  *lbSetting = [[UILabel alloc]init];
    [self.view addSubview:lbSetting];
    lbSetting.sd_layout
        .topSpaceToView(vback, 20.0)
        .centerXEqualToView(self.view)
        .widthRatioToView(self.view, 0.4)
        .autoHeightRatio(0.2);
    lbSetting.text = @"SETTING";
    lbSetting.textAlignment = NSTextAlignmentCenter;
    lbSetting.textColor = [UIColor whiteColor];
    [lbSetting setFont:[UIFont fontWithName:@"Arial" size:24.0]];
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//连接失败
- (void) onConnectFailed{
    
}

//连接成功
- (void) onConnected{
    
}

//连接断开
- (void) onConnectBreak{
    
}

//更新数据
- (void) OnDidReadData{
    
}

//写数据错或者读数据错
- (void) OnDataError{
    
}

-(void)toBoard:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

-(void)setOn:(id)sender{
    
    
}

-(void)setOff:(id)sender{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.header.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.header.delegate = nil;
}

@end
