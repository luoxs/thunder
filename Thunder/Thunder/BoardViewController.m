//
//  BoardViewController.m
//  Thunder
//
//  Created by apple on 2022/9/15.
//

#import "BoardViewController.h"
#import "SDAutoLayout.h"
#import "Socket.h"
#import "MBProgressHUD.h"

@interface BoardViewController ()<SocketDelegate>
@property (strong, nonatomic)Socket *header;
//@property (weak, nonatomic) IBOutlet UILabel *upTemp;//上面冰箱温度
@property int upSliderValue;
//@property (weak, nonatomic) IBOutlet UIImageView *imageRefra;
@property (nonatomic,strong) NSString *currentDeviceName;
@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self  setAutoLayout];
    self.currentDeviceName = [[NSString alloc]init];
    self.header = [Socket sharedInstance];
    self.header.delegate = self;
    [self.header initDevice];
    [self.header initData];   //获取初始化数据
}

-(void)setAutoLayout{
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIImageView *ivLogoBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ThunderBack.jpg"]];
    [self.view addSubview:ivLogoBack];
    ivLogoBack.sd_layout
    .topSpaceToView(self.view, 0.0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightRatioToView(self.view, 0.2);
    
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
    .heightRatioToView(self.view, 0.7);
    
    UIImageView *ivRefrige = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single"]];
    [vback addSubview:ivRefrige];
    ivRefrige.sd_layout
    .topSpaceToView(ivLogoBack, 30)
    .centerXEqualToView(vback)
    .widthRatioToView(self.view, 0.6)
    .autoHeightRatio(674.0/1268.0);
    
    UILabel  *lbContr = [[UILabel alloc]init];
    [self.view addSubview:lbContr];
    lbContr.sd_layout
        .topSpaceToView(vback, 0.0)
        .centerXEqualToView(self.view)
        .widthRatioToView(self.view, 0.8)
        .autoHeightRatio(0.4);
    lbContr.text = @"TEMPERATURE CONTROL";
    lbContr.textColor = [UIColor whiteColor];
    [lbContr setFont:[UIFont fontWithName:@"Arial" size:24.0]];
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

-(void)viewWillAppear:(BOOL)animated{
    self.header.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.header.delegate = nil;
}
@end
