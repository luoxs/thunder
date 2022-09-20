//
//  ViewController.m
//  Thunder
//
//  Created by apple on 2022/9/14.
//

#import "ViewController.h"
#import "SDAutoLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  setAutoLayout];
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
   
    //[btBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

@end
