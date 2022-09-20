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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated{
    self.header.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.header.delegate = nil;
}

@end
