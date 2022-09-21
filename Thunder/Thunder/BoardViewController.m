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
    
    UIButton *btToSetting = [[UIButton alloc]init];
    [vback addSubview:btToSetting];
    btToSetting.sd_layout
    .topSpaceToView(vback, 8.0)
    .rightSpaceToView(vback, 4.0)
    .widthRatioToView(vback,0.3)
    .autoHeightRatio(0.4);
    [btToSetting setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:89.0/255.0 blue:129.0/255.0 alpha:1]];
    [btToSetting setTitle:@"Setting>" forState:UIControlStateNormal];
    btToSetting.titleLabel.font = [UIFont systemFontOfSize:24];
    [btToSetting setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btToSetting addTarget:self action:@selector(toSetting:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *lbName = [[UILabel alloc]init];
    [vback addSubview:lbName];
    lbName.sd_layout
    .topSpaceToView(vback, self.view.height/18)
    .centerXEqualToView(vback);
    lbName.text = @"refragator";
    lbName.textColor = [UIColor whiteColor];
    [lbName setFont:[UIFont fontWithName:@"Arial" size:20.0]];
    [lbName setSingleLineAutoResizeWithMaxWidth:200];
    [lbName setTag:100];
    
    UIImageView *ivRefrige = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single"]];
    [vback addSubview:ivRefrige];
    ivRefrige.sd_layout
    .topSpaceToView(lbName, -8)
    .centerXEqualToView(vback)
    .widthRatioToView(self.view, 0.6)
    .autoHeightRatio(674.0/1268.0);
    [ivRefrige setTag:200];
    
    //实时温度
    UILabel  *lbRealTemp = [[UILabel alloc]init];
    [vback addSubview:lbRealTemp];
    lbRealTemp.sd_layout
    .topSpaceToView(vback,self.view.height/5.2)
    .centerXEqualToView(vback);
    lbRealTemp.text = @"0℃";
    lbRealTemp.textColor = [UIColor whiteColor];
    [lbRealTemp setFont:[UIFont fontWithName:@"Arial" size:36]];
    [lbRealTemp setSingleLineAutoResizeWithMaxWidth:100];
    [lbRealTemp setTag:300];
    
    //滑动调节
    UISlider *slider = [[UISlider alloc]init];
    [vback addSubview:slider];
    slider.sd_layout
    .topSpaceToView(vback, self.view.height/2.9)
    .centerXEqualToView(vback)
    .widthRatioToView(self.view, 0.7)
    .heightRatioToView(vback, 0.1);
    [slider setTag:400];
    [slider addTarget:self action:@selector(chgTemp:) forControlEvents:UIControlEventValueChanged];
    
    //设置温度
    UILabel  *lbTempSetting = [[UILabel alloc]init];
    [vback addSubview:lbTempSetting];
    lbTempSetting.sd_layout
    .topSpaceToView(vback,self.view.height/3.3)
    .centerXEqualToView(vback);
    lbTempSetting.text = @"0℃";
    lbTempSetting.textColor = [UIColor whiteColor];
    [lbTempSetting setFont:[UIFont fontWithName:@"Arial" size:22]];
    [lbTempSetting setSingleLineAutoResizeWithMaxWidth:100];
    [lbTempSetting setTag:500];
    
    //减
    UIButton *btMinus = [[UIButton alloc]init];
    [vback addSubview:btMinus];
    btMinus.sd_layout
    .bottomSpaceToView(vback, 30)
    .leftSpaceToView(vback,self.view.frame.size.width/5.5)
    .widthRatioToView(self.view,0.18)
    .autoHeightRatio(1);
    //[btToSetting setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:89.0/255.0 blue:129.0/255.0 alpha:1]];
    [btMinus setBackgroundImage:[UIImage imageNamed:@"minus"]  forState:UIControlStateNormal];
    [btMinus setBackgroundImage:[UIImage imageNamed:@"minus1"]  forState:UIControlStateHighlighted];
    [btMinus addTarget:self action:@selector(tempMinus:) forControlEvents:UIControlEventTouchUpInside];
    
    //加
    UIButton *btAdd = [[UIButton alloc]init];
    [vback addSubview:btAdd];
    btAdd.sd_layout
    .bottomSpaceToView(vback, 30)
    .rightSpaceToView(vback,self.view.frame.size.width/5.5)
    .widthRatioToView(self.view,0.18)
    .autoHeightRatio(1);
    [btAdd setBackgroundImage:[UIImage imageNamed:@"add"]  forState:UIControlStateNormal];
    [btAdd setBackgroundImage:[UIImage imageNamed:@"add1"]  forState:UIControlStateHighlighted];
    [btAdd addTarget:self action:@selector(tempAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel  *lbContr = [[UILabel alloc]init];
    [self.view addSubview:lbContr];
    lbContr.sd_layout
        .topSpaceToView(vback, 8.0)
        .centerXEqualToView(self.view)
        .widthRatioToView(self.view, 0.8)
        .autoHeightRatio(0.2);
    lbContr.text = @"TEMPERATURE CONTROL";
    lbContr.textColor = [UIColor whiteColor];
    lbContr.textAlignment = NSTextAlignmentCenter;
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

-(void)tempMinus:(id)sender{
    
    
}
-(void)tempAdd:(id)sender{
    
    
}

-(void)toSetting:(id)sender{
    [self performSegueWithIdentifier:@"enterSetting" sender:self];
}

-(void)chgTemp:(id)sender{
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.header.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.header.delegate = nil;
}
@end
