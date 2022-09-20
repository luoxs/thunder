//
//  Socket.m
//  demoSocket
//
//  Created by 罗 显松 on 2017/6/24.
//  Copyright © 2017年 neusoft. All rights reserved.
//
#import "Socket.h"
#import "crc.h"
@implementation Socket

//初始化存储空间
- (void)initDevice{
    self.dataRead = [DataToBeRead alloc];
    self.dataWrite = [DataToBeWrite alloc];
}

+ (Socket *) sharedInstance
{
    static Socket *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}


// socket连接
-(void)socketConnectHost{
    self.socketHost = @"192.168.4.1";
    self.socketPort = 5000;
    
    //必须确认在断开连接的情况下，进行连接
    if (self.socket.isDisconnected) {
        [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:nil];
    }
}

#pragma mark  - 连接成功回调
-(void) socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"socket连接成功");
    [self.delegate onConnected];
    
    /*
     if(![self.connectTimer isValid]){
     self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(initData)  userInfo:nil repeats:YES];
     [self.connectTimer fire];
     }*/
}

/*
 -(void) longConnectToSocket{
 // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
 NSString *longConnect = @"longConnect";
 NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
 [self.socket writeData:dataStream withTimeout:1 tag:1];
 }
 */

//断开之后重新连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"sorry the connect is failure %@",sock.userData);
    //这里可以列举枚举值
    //因用户自动断开 不自动连接
    if (sock.userData == [NSNumber numberWithInt:SocketOfflineByUser])  {
        [self.connectTimer invalidate];
        self.connectTimer = nil;
        //[self.socket setDelegate:nil];
        [self.socket disconnect];
        [self.delegate onConnectFailed];
    }
    //因服务器原因断开 自动连接
    else if (sock.userData == [NSNumber numberWithInt:SocketOfflineByServer]) {
        [self.connectTimer invalidate];
        self.connectTimer = nil;
        // [self.socket setDelegate:nil];
        [self.socket disconnect];
        // [self.socket setDelegate:self];
        [self.socket connectToHost:self.socketHost onPort:self.socketPort error:nil];
        //因Wifi原因断开 不自动连接
    }else{
        [self.connectTimer invalidate];
        self.connectTimer = nil;
        //[self.socket setDelegate:nil];
        [self.socket disconnect];
        [self.delegate onConnectFailed];
    }
}

// 切断socket
-(void)cutOffSocket{
    self.socket.userData = [NSNumber numberWithInt:SocketOfflineByUser];
    [self.connectTimer invalidate];
    [self.socket disconnect];
}

#pragma mark - 写数据

//获取冰箱状态
-(void)initData{
    Byte value[10] ={0};
    
    value[0] = 0xAA;
    value[1] = 0x02;  //获取冰箱信息
    //获取状态时2、3、4位无意义
    int crc = CalcCRC(&value[1],6);
    value[7] = (crc>>8)& 0xff;
    value[8] = crc & 0xff;
    value[9] = 0x55;
    
    NSData *data = [NSData dataWithBytes:&value length:sizeof(value)];
    [self.socket writeData:data withTimeout:3 tag:3];
}

/*
 @property Byte start;   //0.通讯开始
 @property Byte power;   //1.0x01:开机 0x00:关机  0x02获取冰箱状态
 @property Byte temp1;   //2.0XEC:-20  0X0A:10 温度设定1
 @property Byte temp2;   //3.0XEC:-20  0XFB:-5 温度设定2
 @property Byte mode;    //4.0x00: ECO模式 0x01:Turbo模式
 @property Byte protection;  //5.电池保护设定 0-L 1-M 2-H
 @property Byte unit;     //6.华氏或摄氏显示 0：摄氏 1：华氏
 @property Byte crcH;     //7.CRC校验高8位
 @property Byte crcL;     //8.CRC校验低8位
 @property Byte end;      //9.通讯结束
 */

//写数据
-(void) writeBoard{
    Byte value[10] ={0};
    value[0] = 0xAA;
    value[1] = self.dataWrite.power;
    value[2] = self.dataWrite.temp1;
    value[3] = self.dataWrite.temp2;
    value[4] = self.dataWrite.mode;
    value[5] = self.dataWrite.protection;
    value[6] = self.dataWrite.unit;
    
    int crc = CalcCRC(&value[1],6);
    value[7] = crc & 0xff;
    value[8] = (crc>>8)& 0xff;
    value[9] = 0x55;
    
    NSData *data = [NSData dataWithBytes:&value length:sizeof(value)];
    [self.socket writeData:data withTimeout:3 tag:3];
}


- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    //写数据成功，开始读
    NSLog(@"write data successful!");
    if(tag==0 || tag==3){
        [self.socket readDataWithTimeout:3 tag:1];
    }
}


-(void) socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"read data successful!");
    //读数据
    Byte value[18] = {0};
    NSUInteger len = [data length];
    if(len>=18){
        memcpy(value, [data bytes], 18);
    }
    int crc = CalcCRC(&value[1],14);
    Byte crcL8= crc & 0xff;
    Byte crcH8= (crc>>8)& 0xff;
    if(value[15]==crcH8 && value[16]==crcL8 && value[0]==0x55 && value[17]==0xAA){
        NSLog(@"data corrected!");
        self.dataRead.start = value[0];
        self.dataRead.power = value[1];
        self.dataRead.temHigh1 = value[2];
        self.dataRead.temLow1 = value[3];
        self.dataRead.temHigh2 = value[4];
        self.dataRead.temLow2 = value[5];
        self.dataRead.temsetting1 = value[6];
        self.dataRead.temsetting2 = value[7];
        self.dataRead.mode = value[8];
        self.dataRead.protect = value[9];
        self.dataRead.unit = value[10];
        self.dataRead.voltHigh = value[11];
        self.dataRead.voltLow = value[12];
        self.dataRead.errcode = value[13];
        self.dataRead.singleDouble = value[14];
        self.dataRead.crcH = value[15];
        self.dataRead.crcL = value[16];
        self.dataRead.end = value[17];
        [self.delegate OnDidReadData];
    }else{
        [self.delegate OnDataError];
    }
}

@end
