//
//  DataToBeRead.h
//  evaKool
//
//  Created by Sierra on 2019/7/24.
//  Copyright © 2019年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataToBeRead : NSObject
@property Byte start;        //0.0x55 通讯开始
@property Byte power;        //1.0x01:开机 0x00:关机
@property Byte temHigh1;     //2.0x00-0xff 温度1数据高八位
@property Byte temLow1;;     //3.0x00-0xff 温度1数据低八位
@property Byte temHigh2;     //4.0x00-0xff 温度2数据高八位
@property Byte temLow2;;     //5.0x00-0xff 温度2数据低八位
@property Byte temsetting1;; //6.0XEC—0X0A 温度1最后设定值
@property Byte temsetting2;; //7.0XEC—0XFB 温度2最后设定值/单温区固定为0XEC
@property Byte mode;         //8.0x00-0x01 0x00: ECO模式 0x01:Turbo模式
@property Byte protect;      //9.0x00-0x02 电池保护设定 0-L 1-M 2-H
@property Byte unit;         //10.0X00-0X01 0x00-摄氏度  0x01-华氏度
@property Byte voltHigh;     //11.0x00-0xff 电压值高八位
@property Byte voltLow;      //12.0x00-0xff 电压值低八位
@property Byte errcode;      //13.0x00-0xff 故障代码，和工作状态
@property Byte singleDouble; //14.0x00-0x01 0x00:单温区冰箱 0x01:双温区冰箱
@property Byte crcH;         //15.0x00-0xff CRC校验高8位
@property Byte crcL;         //16.0x00-0xff CRC校验低8位
@property Byte end;          //17.0xaa 通讯结束
@end
