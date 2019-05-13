//
//  ViewController.m
//  WXPay
//
//  Created by lk on 2019/5/13.
//  Copyright © 2019 lk. All rights reserved.
//

#import "ViewController.h"
#import <WXApi.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickBtnAction:(UIButton *)sender {
    [self sendWXPay];
}

- (void)sendWXPay
{
    NSString *urlString   = @"https://wxpay.wxutil.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                /** 商家向财付通申请的商家id */
                req.partnerId           = [dict objectForKey:@"partnerid"];
                /** 预支付订单 */
                req.prepayId            = [dict objectForKey:@"prepayid"];
                /** 随机串，防重发 */
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                /** 时间戳，防重发 */
                req.timeStamp           = stamp.intValue;
                /** 商家根据财付通文档填写的数据和签名 */
                req.package             = [dict objectForKey:@"package"];
                /** 商家根据微信开放平台文档对数据做的签名 */
                req.sign                = [dict objectForKey:@"sign"];
                //发送请求到微信，等待微信返回onResp
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }else{
                NSLog(@"%@",[dict objectForKey:@"retmsg"]);
            }
        }else{
            NSLog(@"服务器返回错误，未获取到json对象");
        }
    }else{
        NSLog(@"服务器返回错误");
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
