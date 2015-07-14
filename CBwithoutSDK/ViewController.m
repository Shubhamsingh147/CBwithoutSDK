//
//  ViewController.m
//  CBwithoutSDK
//
//  Created by Shubham Singh on 12/07/15.
//  Copyright (c) 2015 PayU. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"
#import "SharedDataManager.h"
#import "PayUResultViewController.h"
#import <CommonCrypto/CommonDigest.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *payNowBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *cardNumber;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction) payNow:(UIButton *)btn{
    
    NSURL *restURL = [NSURL URLWithString:@"https://secure.payu.in/_payment"];
    
    // create the request
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:restURL
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    // Specify that it will be a POST request
    theRequest.HTTPMethod = @"POST";
    
    NSDictionary *paramDict = [[SharedDataManager sharedDataManager] allInfoDict];
    
    NSMutableString *postData = [[NSMutableString alloc] init];
    for(NSString *aKey in [paramDict allKeys]){
        
        if(([aKey isEqualToString:PARAM_FIRST_NAME]) || ([aKey isEqualToString:PARAM_EMAIL])){
            [postData appendFormat:@"%@=%@",aKey,@""];
            [postData appendString:@"&"];
        }
        else if(![aKey isEqualToString:PARAM_SALT]){
            [postData appendFormat:@"%@=%@",aKey,[paramDict valueForKey:aKey]];
            [postData appendString:@"&"];
        }
    }
        [postData appendFormat:@"%@=%@",PARAM_PG,CARD_TYPE];
        [postData appendString:@"&"];
    
        [postData appendFormat:@"%@=%@",PARAM_CARD_NUMBER,_cardNumber.text];
        [postData appendString:@"&"];

        [postData appendFormat:@"%@=%@",PARAM_CARD_NAME,@"PAYU"];
        [postData appendString:@"&"];

        [postData appendFormat:@"%@=%@",PARAM_CARD_CVV,@"999"];
        [postData appendString:@"&"];

        [postData appendFormat:@"%@=%@",PARAM_CARD_EXPIRY_MONTH,@"05"];
        [postData appendString:@"&"];
 
        [postData appendFormat:@"%@=%@",PARAM_CARD_EXPIRY_YEAR,@"2027"];
        [postData appendString:@"&"];

        [postData appendFormat:@"%@=%@",PARAM_BANK_CODE,CARD_TYPE];
        
    [postData appendString:@"&"];
    [postData appendFormat:@"%@=%@",PARAM_DEVICE_TYPE,IOS_SDK];
    [postData appendString:@"&"];
    
    
    
    //checksum calculation.
    
    NSString *checkSum = nil;
    if(!HASH_KEY_GENERATION_FROM_SERVER){
        
        NSMutableString *hashValue = [[NSMutableString alloc] init];
        if([paramDict valueForKey:PARAM_KEY]){
            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_KEY]];
            [hashValue appendString:@"|"];
        }
        if([paramDict valueForKey:PARAM_TXID]){
            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_TXID]];
            [hashValue appendString:@"|"];
        }
        if([paramDict valueForKey:PARAM_TOTAL_AMOUNT]){
            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_TOTAL_AMOUNT]];
            [hashValue appendString:@"|"];
        }
        if([paramDict valueForKey:PARAM_PRODUCT_INFO]){
            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_PRODUCT_INFO]];
            [hashValue appendString:@"|"];
        }
        if([paramDict valueForKey:PARAM_FIRST_NAME]){
            //            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_FIRST_NAME]];
            [hashValue appendString:@"|"];
        }
        if([paramDict valueForKey:PARAM_EMAIL]){
            //            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_EMAIL]];
            [hashValue appendString:@"|"];
        }
        if([paramDict valueForKey:PARAM_UDF_1]){
            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_UDF_1]];
            [hashValue appendString:@"|"];
        }
        else{
            [hashValue appendString:@"|"];
        }
        if([paramDict valueForKey:PARAM_UDF_2]){
            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_UDF_2]];
            [hashValue appendString:@"|"];
        }
        else{
            [hashValue appendString:@"|"];
        }
        if([paramDict valueForKey:PARAM_UDF_3]){
            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_UDF_3]];
            [hashValue appendString:@"|"];
        }
        else{
            [hashValue appendString:@"|"];
        }
        if([paramDict valueForKey:PARAM_UDF_4]){
            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_UDF_4]];
            [hashValue appendString:@"|"];
        }
        else{
            [hashValue appendString:@"|"];
        }
        if([paramDict valueForKey:PARAM_UDF_5]){
            [hashValue appendFormat:@"%@",[paramDict valueForKey:PARAM_UDF_5]];
            [hashValue appendString:@"|"];
        }
        else{
            [hashValue appendString:@"|"];
        }
        [hashValue appendString:@"|||||"];
        if([paramDict valueForKey:PARAM_SALT]){
            [hashValue appendString:[paramDict valueForKey:PARAM_SALT]];
        }
        
        checkSum = [self createCheckSumString:hashValue];
        NSLog(@"Hash String = %@ hashvalue = %@",hashValue,checkSum);
        
    }
    else{
        checkSum = [[[SharedDataManager sharedDataManager] hashDict] valueForKey:PAYMENT_HASH];
    }
    
    [postData appendFormat:@"%@=%@",PARAM_HASH,checkSum];
    //sha512(key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5||||||SALT)
    NSLog(@"POST DATA = %@",postData);
    //set request content type we MUST set this value.
    [theRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [theRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    PayUResultViewController *resultViewController = [[PayUResultViewController alloc] initWithNibName:@"PayUResultViewController" bundle:nil];
    resultViewController.request = theRequest;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == IPHONE_3_5)
        {
            resultViewController.flag = YES;
            
        }
        else{
            resultViewController.flag = NO;
        }
        
    }
    
    [self.navigationController pushViewController:resultViewController animated:YES];
}
-(NSString *) createCheckSumString:(NSString *)input{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA512(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
