
//  DZNetManager.h
//  creditcheck_ios
//
//  Created by srj on 17/2/7.
//  Copyright © 2017年 daze. All rights reserved.
//

#import <Foundation/Foundation.h>

//*************** 这里修改网络地址 *******************//
#define BASE_API_URL    @"http://172.100.8.172:8085" //能瑶本地

typedef void (^DZCompletedBlock)(BOOL ret, id obj);

@interface DZNetManager : NSObject
+ (DZNetManager *)sharedManager;
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) AFHTTPSessionManager *reqManager;

- (NSMutableDictionary *)headerParams;
- (NSDictionary *)ql_headerParams:(NSDictionary*)parameters;

//获取商品
- (void)commonGetReq:(id)param method:(NSString *)method completed:(DZCompletedBlock)completed;
- (void)commonPostReq:(id)param method:(NSString *)method completed:(DZCompletedBlock)completed;
- (void)netUploadTaskBody:(id)param method:(NSString *)method completed:(DZCompletedBlock)completed;

- (void)netUploadTask:(NSDictionary *)param url:(NSString *)url data:(NSData*)data num:(int)num mineType:(int)mineType completed:(DZCompletedBlock)completed;
@end
