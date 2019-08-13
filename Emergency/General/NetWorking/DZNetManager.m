//
//  DZNetManager.m
//  creditcheck_ios
//
//  Created by srj on 17/2/7.
//  Copyright © 2017年 daze. All rights reserved.
//

#import "DZNetManager.h"

@implementation DZNetManager
static DZNetManager * sharedArchiveManager;

+ (DZNetManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedArchiveManager = [[self alloc] init];
    });
    return sharedArchiveManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.baseURL = BASE_API_URL;
        self.reqManager = [AFHTTPSessionManager manager];
    }
    return self;
}

//post请求 parameters请求的参数 url请求的接口 completed Block返回一个BOOL和一个Obj
- (void)netPOST:(id)parameters url:(NSString *)url completed:(DZCompletedBlock)completed
{
    NSString *fullurl = XBString(@"%@",url);
    DLog(@"======request url = %@, param = %@ \n",fullurl,parameters);
    [self setHTTPHeaderField:self.reqManager signedParam:parameters];
    [self.reqManager POST:fullurl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response = %@", responseObject);
        if (completed) {
            [self baidutransfResponseUrl:fullurl responseObject:responseObject completed:completed];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode; // 错误的code
        
        if (completed) {
            completed(NO, @{@"msg":NotNil([self getCommentErrorString:error]),@"code":XBString(@"%ld",(long)statusCode)});
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)netGET:(id)parameters url:(NSString *)url completed:(DZCompletedBlock)completed
{
    NSString *fullurl = XBString(@"%@",url);
    [self setHTTPHeaderField:self.reqManager signedParam:parameters];
    [self.reqManager  GET:fullurl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"response = %@", responseObject);
        if (completed) {
            [self baidutransfResponseUrl:fullurl responseObject:responseObject completed:completed];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode; // 错误的code
        if (completed) {
            completed(NO, @{@"msg":NotNil([self getCommentErrorString:error]),@"code":XBString(@"%ld",(long)statusCode)});
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}
- (void)netPOSTBody:(id)parameters url:(NSString *)url completed:(DZCompletedBlock)completed
{
    NSString *fullurl = XBString(@"%@",url);
    DLog(@"======request url = %@, body = %@ \n",fullurl,parameters);
    ((AFJSONResponseSerializer *)self.reqManager.responseSerializer).removesKeysWithNullValues = YES;
    NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:fullurl parameters:parameters error:nil];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *sessionTask = [self.reqManager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        DLog(@"response = %@", responseObject);
        if (!error) {
            [self baidutransfResponseUrl:fullurl responseObject:responseObject completed:completed];
        }else {
            NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            NSInteger statusCode = response.statusCode; // 错误的code
            
            if (completed) {
                completed(NO, @{@"msg":NotNil([self getCommentErrorString:error]),@"code":XBString(@"%ld",(long)statusCode)});
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }];
    [sessionTask resume];
}

- (void)transfResponseUrl:(NSString *)fullUrl responseObject:(id _Nullable)responseObject completed:(DZCompletedBlock)completed
{
    if([[NSStringFromClass([responseObject class]) lowercaseString] rangeOfString:@"dictionary"].location == NSNotFound){
        completed(NO, @{@"msg":@"服务器异常"});
        return;
    }
    if ([self isNetSuccess:responseObject]){
        completed(YES, responseObject);
    }else{
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (msg == nil || [msg length] == 0) {
            msg = @"操作失败";
        }
        completed(NO, @{@"msg":msg});
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)baidutransfResponseUrl:(NSString *)fullUrl responseObject:(id _Nullable)responseObject completed:(DZCompletedBlock)completed
{
    if([[NSStringFromClass([responseObject class]) lowercaseString] rangeOfString:@"dictionary"].location == NSNotFound){
        completed(NO, @{@"msg":@"服务器异常"});
        return;
    }
    if (responseObject){
        completed(YES, responseObject);
    }else{
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (msg == nil || [msg length] == 0) {
            msg = @"操作失败";
        }
        completed(NO, @{@"msg":msg});
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


//统一入口的header头
- (NSMutableDictionary *)headerParams
{
    NSMutableDictionary *headerParams = [NSMutableDictionary new];
    [headerParams setValue:@"ios" forKey:@"os"];
    [headerParams setValue:@"application/json" forKey:@"Content-Type"];
    [headerParams setValue:@"application/json" forKey:@"Accept"];
    //    [headerParams setValue:[ANUserModel currentUser].token forKey:@"token"];
    [headerParams setValue:@"ios" forKey:@"channel_from"];
    [headerParams setValue:@"1.0.0" forKey:@"app_var"];
    return headerParams;
}

- (void)setHTTPHeaderField:(AFHTTPSessionManager *)manager signedParam:(id)parameters
{
    NSMutableDictionary *headerParams = [self headerParams];
    
    [headerParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [((AFHTTPSessionManager *)manager).requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES; //在请求的时候去掉服务器给的NULL类型
    [headerParams addEntriesFromDictionary:parameters];
    //  NSString *s = [self stringWithDict:headerParams];
    //  NSString *appSign = XBString(@"%@%@",s,@"ef41f328f46ecd49486286138502bca2");
    //  appSign = [[appSign md5Hash1] md5Hash1];
    
    //  [((AFHTTPSessionManager *)manager).requestSerializer setValue:appSign forHTTPHeaderField:@"appSign"];
}

- (void)setHTTPHeaderFieldInReq:(NSMutableURLRequest *)req signedParam:(id)parameters
{
    NSMutableDictionary *headerParams = [self headerParams];
    [headerParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [req setValue:obj forHTTPHeaderField:key];
    }];
    
    NSString *s = [self stringWithDict:headerParams];
    NSString *appSign = XBString(@"%@%@%@",s,[self dictToString:parameters],@"ef41f328f46ecd49486286138502bca2");
    appSign = [[appSign md5Hash1] md5Hash1];
    [req setValue:appSign forHTTPHeaderField:@"appSign"];
}

- (NSString *)h5BasicParamsHeadString {
    NSMutableDictionary *headerParams = [self headerParams];
    NSString *s = [self stringWithDict:headerParams];
    NSString *appSign = XBString(@"%@%@",s,@"ef41f328f46ecd49486286138502bca2");
    appSign = [[appSign md5Hash1] md5Hash1];
    [headerParams setValue:([self isUserNotificationEnable]?@"1":@"0") forKey:@"notification"];
    [headerParams setValue:appSign forKey:@"appSign"];
    [headerParams setValue:XBGetUserDefaults(@"currentSessionId") forKey:@"sessionId"];
    //  [headerParams setValue:gMyUser.userPhone forKey:@"userPhone"];
    return [self dictToString:headerParams];
}

- (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    } else { // iOS版本 <8.0 处理逻辑
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
    }
    return isEnable;
}

- (NSString *)getCommentErrorString:(NSError *)error{
    NSString *msg = @"网络异常,请检查网络";
    if (error.code == NSURLErrorTimedOut) {
        msg = @"请求超时,请检查网络";
    }
    else if (error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorNotConnectedToInternet) {
        msg = @"网络未开启,请检查网络";
    }
    return msg;
}

- (BOOL)isNetSuccess:(id)JSON{
    id codeStr = [JSON objectForKey:@"code"];
    if (codeStr == nil) {
        return NO;
    }
    int code = [codeStr intValue];
    BOOL bSuccess = NO;
    if (code == 1) {
        bSuccess = YES;
        id info = [JSON objectForKey:@"data"];
        
        if ([info isKindOfClass:[NSDictionary class]]) {
            id result = [info objectForKey:@"msg"]; //result崩溃 这里社保蛙后台会返回这个参数，无语
            if (result != nil) {
                if ([result isKindOfClass:[NSString class]] ){
                    if (result != nil && [result length] > 0) {
                        bSuccess = [result boolValue];
                    }
                }
                else{
                    bSuccess = [result boolValue];
                }
            }
        }
    }
    return bSuccess;
}
-(NSString *)stringWithDict:(NSDictionary*)dict{
    NSArray *keys = [dict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        return[obj1 compare:obj2 options:NSNumericSearch];//正序
    }];
    
    NSString*str =@"";
    for(NSString*key in sortedArray) {
        id value = [dict objectForKey:key];
        if([value isKindOfClass:[NSDictionary class]]) {
            value = [self stringWithDict:value];
        }
        str = [str stringByAppendingFormat:@"%@%@",key,value];
    }
    //    NSLog(@"str:%@",str);
    return str;
}

- (NSString *)dataTojsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSString *)dictToString:(NSDictionary *)parameters
{
    NSString *parametersString = nil;
    if ([parameters count]) {
        NSData *jsonData = [self toJSONData:parameters];
        if (jsonData) {
            parametersString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        } else {
            parametersString = @"";
        }
    } else {
        parametersString = @"";
    }
    
    return parametersString;//[parametersString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (NSData *)toJSONData:(id)theData
{
    NSError *error = nil;
    
    NSData *jsonData;
    jsonData = [NSJSONSerialization dataWithJSONObject:theData options:0 error:&error];
    
    if ([jsonData length] > 0 && error == nil) {
        return jsonData;
    } else {
        return nil;
    }
}

- (void)commonGetReq:(id)param method:(NSString *)method completed:(DZCompletedBlock)completed
{
    [self netGET:param url:method completed:completed];
}

- (void)commonPostReq:(id)param method:(NSString *)method completed:(DZCompletedBlock)completed
{
    [self netPOST:param url:method completed:completed];
}

- (void)netUploadTask:(NSDictionary *)param url:(NSString *)url data:(NSData*)data num:(int)num mineType:(int)mineType completed:(DZCompletedBlock)completed
{
    NSString *fullurl = XBString(@"%@",url);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:fullurl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    [[manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgress.totalUnitCount != uploadProgress.completedUnitCount){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshVideoUploadProcess" object:nil userInfo:@{@"process":uploadProgress}];
        }
    }completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"fullUrl = %@ \nparameters = %@,response = %@", fullurl,param?:@"",responseObject);
        if (!error){
            [self baidutransfResponseUrl:fullurl responseObject:responseObject completed:completed];
        }else {
            NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            NSInteger statusCode = response.statusCode;
            if (completed) {
                completed(NO, @{@"msg":NotNil([self getCommentErrorString:error]),@"code":XBString(@"%ld",(long)statusCode)});
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }] resume];
}

- (void)netUploadTaskBody:(id)param method:(NSString *)method completed:(DZCompletedBlock)completed
{
    [self netPOSTBody:param url:method completed:completed];
}


@end

