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
    
    self.currentDeviceName = [[NSString alloc]init];
    self.header = [Socket sharedInstance];
    self.header.delegate = self;
    [self.header initDevice];
    [self.header initData];   //获取初始化数据
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



-(void)viewWillDisappear:(BOOL)animated{
    self.header.delegate = nil;
}
@end
