//
//  MopooRemoteServer.m
//  Mopoo
//
//  Created by altchen on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MopooRemoteServer.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "MopooUserDefaults.h"
#import "NSString+SSToolkitAdditions.h"
@interface MopooRemoteServer(Private)
-(NSString * ) fetchHtmlWithRequest:(NSString *) url;
-(void) setRequestProperties:(ASIHTTPRequest *)request;
-(ASIHTTPRequest *) requestWithUrl:(NSString * )url;
-(ASIFormDataRequest * ) formDataRequestWithUrl:(NSString *) url;
-(void) visitIndexIfNeed;
-(NSString *) stringFromLeftCss;
-(NSString *) stringFromRightCss;
-(NSString *) stringFromFixjs;
-(BOOL) needNextVisitIndex;
-(NSString *) getChatCssString;
@end

@implementation MopooRemoteServer
@synthesize error,lastVisitIndexDate=_lastVisitIndexDate;
static NSString * REAL_MOPOO_IP =@"REAL-IP"; //请换成服务器真实ip，为了里屋安全不直接写ip请自行修改，并且不要提交到git上
static NSString * URI_ROOT = nil; 
+(MopooRemoteServer *) sharedRemoteServer
{
    static MopooRemoteServer * staticServer = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticServer = [[MopooRemoteServer alloc] init];
        URI_ROOT = [NSString stringWithFormat:@"https://%@",REAL_MOPOO_IP];
    });
    return staticServer;
}
-(id)init
{
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    [ASIHTTPRequest setDefaultTimeOutSeconds:25];
    defaultEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSChineseSimplif);
    return self;
}
-(BOOL) isLogin
{
    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:URI_ROOT]];
    for(NSHTTPCookie * currCookie in cookies){
        //NSLog(@"key=%@,value=%@",[currCookie name],[currCookie value]);
        if( [[ currCookie name] isEqualToString:@"yourname2"]){
            return TRUE;
        }
    }
    return FALSE;
}
-(BOOL) haveIndexCookie
{
    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:URI_ROOT]];
    for(NSHTTPCookie * currCookie in cookies){
        NSString * name = [currCookie name];
        [currCookie expiresDate];
        if  ([name containsString:@"ASPSESSIONID"]){
            return YES;
        }
    } 
    return NO;
}
-(void) logout
{
    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:URI_ROOT]];
    for(NSHTTPCookie * currCookie in cookies){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:currCookie];
    }
    [self setLastVisitIndexDate:nil];
}
-(BOOL) login:(NSString *)user withPassword:(NSString *)password
{
    NSString * loginUrl = [NSString stringWithFormat:@"%@%@",URI_ROOT,@"/inyourname.asp"];
    ASIFormDataRequest * request = [self formDataRequestWithUrl:loginUrl];
    [request setPostValue:@"4544745" forKey:@"h"];
    [request setPostValue:user forKey:@"name"];
    [request setPostValue:password forKey:@"pass1"];
    [request setPostValue:@"登录" forKey:@"B1"];
    [request setPostValue:@"1" forKey:@"C1"];
    [request setPostValue:@"" forKey:@"tjm"];
    [request setShouldRedirect:NO];
    [request setShouldUseRFC2616RedirectBehaviour:NO];
    [request startSynchronous];
    NSString * location = [[request responseHeaders] objectForKey:@"Location"];
    if([location isEqualToString:@"index.asp"]){
        return TRUE;
    }else{
        return FALSE;
    }
}
-(BOOL) needNextVisitIndex
{
    if (_lastVisitIndexDate == NULL) {
        return YES;
    }
    NSDate * nowDate = [NSDate date];
    NSTimeInterval more = [nowDate timeIntervalSince1970] - [_lastVisitIndexDate timeIntervalSince1970];
    if (more > 60*10) { //10分钟再请求一次
        return YES;
    }else{
        return NO;
    }
}
-(void) visitIndexIfNeed
{
    if(![self haveIndexCookie]||[self needNextVisitIndex]){
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString * indexUrl = [NSString stringWithFormat:@"%@/index.asp?t=%ld",URI_ROOT,(long)time];
        [self fetchHtmlWithRequest:indexUrl];
        if (self.error==nil) {
            [self setLastVisitIndexDate:[NSDate date]];
        }
    }
}
-(NSString *)fetchTopicListHtml:(BOOL) useCahce useRemote:(BOOL)isUseRemote
{
    [self visitIndexIfNeed];
    [self setError:nil];
    NSString * topicListUrl = [NSString stringWithFormat:@"%@%@",URI_ROOT,@"/new/info.asp"];
    NSString * html = [self fetchHtmlWithRequest:topicListUrl];
    NSError * currError = [self error];
    if (currError != nil) {
        return [currError localizedDescription]; 
    }
    NSString * leftcss = [self stringFromLeftCss];
    NSMutableString * mString = [NSMutableString stringWithString:leftcss];
    __block BOOL isValidTopicListHtml = FALSE;
    __block BOOL start = FALSE;
    [mString appendString:@"<body topmargin=\"5\"background=\"https://www.253874.com/new/leftbg.jpg\" bgproperties=\"fixed\">"];
    NSMutableString * onlyListHtml = [[NSMutableString alloc] init];
    [html enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        if(!isValidTopicListHtml){
            if([line rangeOfString:@"info2.asp?id="].length>0){ //判断，如果有这一句当作是正常的列表
                isValidTopicListHtml = TRUE;
            }
        }
        if ([line hasPrefix:@"[<span style="]) {
            start = TRUE;
            NSRange startRange = [line rangeOfString:@"</font>帖<p>"];
            [onlyListHtml appendString:[line substringFromIndex:(startRange.location+startRange.length)]];
            [onlyListHtml appendString:@"\n"]; 
            return;
        }
        if (start && [line hasPrefix:@"<SCRIPT LANGUAGE=\"JavaScript\">"]) {
            *stop = YES;
        }
        if (start){
            [onlyListHtml appendString:line];
            [onlyListHtml appendString:@"\n"];
        }
    }];
    if ([onlyListHtml length]<=0) {
        [mString appendString:html];
    }else{
        [mString appendString:onlyListHtml];
    }
    [mString appendString:@"</body>"];
    //NSLog(@"%@",mString);
    return mString;
}
-(NSString *) fetchTopicHtml:(NSString *) topicId viewPlay:(BOOL) isViewPlay useCache:(BOOL)isUseCache useRemote:(BOOL) isUseRemote
{
    [self visitIndexIfNeed];  
    NSString * topicListUrl = [[URI_ROOT stringByAppendingString:@"/new/info2.asp?id="] stringByAppendingString:topicId]; 
    if (isViewPlay) {
        topicListUrl = [topicListUrl stringByAppendingString:@"&lmck=1"];
    }
    NSString * html = [self fetchHtmlWithRequest:topicListUrl];
    
    NSRange startRange = [html rangeOfString:@"</title>"];
    html = [html substringFromIndex:(startRange.location+startRange.length)];
    NSRange endRange = [html rangeOfString:@"<script "];
    html = [html substringToIndex:endRange.location];
    if (html == nil) {
        return nil;
    }
    NSString * rightcss = [self stringFromRightCss];
    NSMutableString * mString = [NSMutableString stringWithString:rightcss];
    [mString appendString:html];
    return mString;
}
-(NSString *) fetchChatHtml
{
    [self visitIndexIfNeed];
    NSString * chatUrl = [URI_ROOT stringByAppendingString:@"/new/mmm.asp"];
    NSString * html = [self fetchHtmlWithRequest:chatUrl];
    NSMutableString * mString = [NSMutableString stringWithString: [self getChatCssString]];
    [mString appendString:[html stringByStartEnd:@"<body topmargin=\"5\" vlink=\"#008080\">" end:@"<script language=\"JavaScript\">"]];
    return mString;
}
-(NSString * ) getChatCssString
{
    return @"<style>BODY{font-size : 14pt;line-height: 24px;} a{text-decoration : none;}a:hover{text-decoration: underline;}</style>";
}
-(BOOL) sendChat:(NSString *)msg
{
    [self visitIndexIfNeed];
    NSString * sendChatUrl = [URI_ROOT stringByAppendingString:@"/new/mmm.asp"];
    ASIFormDataRequest * request = [self formDataRequestWithUrl:sendChatUrl];
    [request setPostValue:msg forKey:@"T1"];
    [request setPostValue:msg forKey:@"T2"];
    [request setPostValue:@"OK" forKey:@"submit"];
    [request startSynchronous];
    
    if (request.error ==nil){
        NSString * html = [request responseString];
        if ([html isBlank]) {
            NSError * err = [[NSError alloc] init]; 
            [self setError:err];
            return FALSE;
        }
        [self setError:nil];
        return TRUE;
        
    }else{
        [self setError:request.error];
        return FALSE;
    }
}
-(BOOL) doReply:(NSString *)topicId replayText:(NSString *)text nimin:(BOOL)isNimin lc:(NSString* ) lc lcText:(NSString *) lcText
{
    [self visitIndexIfNeed];
    NSString * replyUrl = [URI_ROOT stringByAppendingString:@"/new/info2.asp"];
    ASIFormDataRequest * request = [self formDataRequestWithUrl:replyUrl];
    [request setPostValue:@"34236367464234525" forKey:@"h"];
    [request setPostValue:topicId forKey:@"id"];
    NSString * formatText = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    [request setPostValue:formatText forKey:@"neirong2"];
    if (isNimin){
        [request setPostValue:@"1" forKey:@"nimin"];
    }
    if (lc!=nil && lcText!=nil) {
        [request setPostValue:lc forKey:@"lc"];
        [request setPostValue:lcText forKey:@"neirongy"];        
    }    
    
    [request setPostValue:@"提交回复" forKey:@"B1"];
    [request startSynchronous];
    
    if (request.error ==nil){
        NSString * html = [request responseString];
        if ([html isBlank]) {
            NSError * err = [[NSError alloc] init]; 
            [self setError:err];
            return FALSE;
        }
        [self setError:nil];
        return TRUE;
        
    }else{
        [self setError:request.error];
        return FALSE;
    }
   
}

-(BOOL) doEditReply:(NSString *) topicId editReplyId:(NSString *) replyId replyText:(NSString *) text
{
    [self visitIndexIfNeed];
    NSString * replyUrl = [URI_ROOT stringByAppendingString:@"/new/info2.asp"];
    ASIFormDataRequest * request = [self formDataRequestWithUrl:replyUrl];
    [request setPostValue:@"23468845456" forKey:@"h"];
    [request setPostValue:topicId forKey:@"id"];
    [request setPostValue:replyId forKey:@"id2"];

    NSString * formatText = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    [request setPostValue:formatText forKey:@"neirong"];
    [request setPostValue:@"修改" forKey:@"B1"];
    [request startSynchronous];
    
    if (request.error ==nil){
        NSString * html = [request responseString];
        if ([html isBlank]) {
            NSError * err = [[NSError alloc] init]; 
            [self setError:err];
            return FALSE;
        }
        [self setError:nil];
        return TRUE;
        
    }else{
        [self setError:request.error];
        return FALSE;
    }   
}
-(BOOL) delReply:(NSString *)topicId editReplyId:(NSString *)replyId
{
    [self visitIndexIfNeed];
    NSString * url = [URI_ROOT stringByAppendingFormat:@"/new/infonewdel.asp?delhf=1&sid=%@&id=%@",topicId,replyId];
    NSString * html = [self fetchHtmlWithRequest:url];
    if (html != nil && [html containsString:@"删除成功"]) {
        return TRUE;
    }else{
        return FALSE;
    } 
}

-(BOOL) postNewTopic:(NSString *) title body:(NSString *)bodyText nimin:(BOOL)isNimin
{
    [self visitIndexIfNeed];
    [self setError:nil];
    NSString * replyUrl = [URI_ROOT stringByAppendingString:@"/new/fatiezi.asp"];
    ASIFormDataRequest * request = [self formDataRequestWithUrl:replyUrl];
    [request setPostValue:title forKey:@"title"];
    NSString * formatText = [bodyText stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    [request setPostValue:formatText forKey:@"neirong"];
    [request setPostValue:@"0" forKey:@"Rqz"];
    [request setPostValue:@"no" forKey:@"acgs"];
    [request setPostValue:@"1" forKey:@"huifubz"];
    [request setPostValue:@"普通" forKey:@"ttype"];
    if (isNimin) {
        [request setPostValue:@"1" forKey:@"nimin"];
    }
    [request setPostValue:@"按此处发帖" forKey:@"B1"];
    [request startSynchronous];
    
    if (request.error ==nil){
        NSString * html = [request responseString];
        if ([html isBlank]) {
            NSError * err = [[NSError alloc] init]; 
            [self setError:err];
            return FALSE;
        }
        [self setError:nil];
        return TRUE;
        
    }else{
        [self setError:request.error];
        return FALSE;
    }
}
-(NSString *) fetchSearchHtml:(NSString*) key searchType:(NSString*) searchType useCache:(BOOL)isUseCache useRemote:(BOOL) isUseRemote
{
    [self visitIndexIfNeed];
    [self setError:nil];
    NSString * url = [URI_ROOT stringByAppendingString:@"/new/msearch.asp"];
    ASIFormDataRequest * request = [self formDataRequestWithUrl:url];
    [request setPostValue:key forKey:@"T1"];
    [request setPostValue:searchType forKey:@"D1"];
    [request setPostValue:@"查找" forKey:@"B1"];
    [request startSynchronous];
    
    NSString * html = [request responseString];
    NSRange startRange = [html rangeOfString:@"</form>"];
    html = [html substringFromIndex:(startRange.location+startRange.length)];
    if (html == nil) {
        return nil;
    }
    NSString * rightcss = [self stringFromRightCss];
    NSMutableString * mString = [NSMutableString stringWithString:rightcss];
    [mString appendString:html];
    return mString;    
}
-(NSString*) fetchInfoNewHtml:(NSString *) lastUrl
{
    [self visitIndexIfNeed];
    NSString * url = [[URI_ROOT stringByAppendingString:@"/new/"] stringByAppendingString:lastUrl];
    NSString * html = [self fetchHtmlWithRequest:url];
    NSRange startRange = [html rangeOfString:@"</form>"];
    html = [html substringFromIndex:(startRange.location+startRange.length)]; 
    if (html == nil) {
        return nil;
    }
    NSString * rightcss = [self stringFromRightCss];
    NSMutableString * mString = [NSMutableString stringWithString:rightcss];
    [mString appendString:html];
    return mString;  
}
#pragma 工具方法
-(NSString *) fetchReplyText:(NSString *)topicId editReplyId:(id)replyId
{
    
    [self visitIndexIfNeed];
    [self setError:nil];
    NSString * replyUrl = [NSString stringWithFormat:@"%@/new/editlthf.asp?id=%@&id2=%@",URI_ROOT,topicId,replyId];
    NSString * html = [self fetchHtmlWithRequest:replyUrl];
    return [html stringByStartEnd:@"<textarea rows='10' name='neirong' cols='38'>" end:@"</textarea>"];
}
-(BOOL) favTopic:topicId
{
    [self visitIndexIfNeed];
    [self setError:nil];
    NSString * topicListUrl = [[URI_ROOT stringByAppendingString:@"/new/ltcollect.asp?collid="] stringByAppendingString:topicId];
    NSString * html = [self fetchHtmlWithRequest:topicListUrl];
    
    if (html!=nil && [html containsString:@"已添加到收藏夹"]){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(NSArray * ) fetchOtherUserReplayByURL:(NSString *) url
{
    [self visitIndexIfNeed];
    [self setError:nil];
    NSString * replyUrl = [URI_ROOT stringByAppendingString:url];
    NSString * html = [self fetchHtmlWithRequest:replyUrl];
    NSString * lc = [html stringByStartEnd:@"name='lc' value=" end:@" >"];
    NSString * text =[html stringByStartEnd:@"<textarea rows='4' name='neirongy' cols='36' onkeydown=ctlent2()>" end:@"</textarea>"]; 
    ACLog(@"%@", text);
    return [NSArray arrayWithObjects:lc,text, nil];
}
-(void) setRequestProperties:(ASIHTTPRequest *)request
{
    [request setUserAgent:@"AppleWebKit/533.18.1 (KHTML, like Gecko) Version/5.0.2 Safari/533.18.5" ];
    [request addRequestHeader:@"Host" value:@"www.253874.com"];
    [request addRequestHeader:@"Referer" value:@"https://www.253874.com/inyourname.asp"];
    if ( [request isKindOfClass:[ASIFormDataRequest class]]==YES) {
        ASIFormDataRequest * formRequest = (ASIFormDataRequest *)request;
        [formRequest setStringEncoding:defaultEncoding];
    }
    [request setAllowCompressedResponse:YES ];
    [request setValidatesSecureCertificate:NO];
    [request setResponseEncoding:defaultEncoding];
    [request setDefaultResponseEncoding:defaultEncoding];
}
-(ASIHTTPRequest *) requestWithUrl:(NSString *)url
{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [self setRequestProperties:request];
    return request;
}
-(ASIFormDataRequest * ) formDataRequestWithUrl:(NSString *)url
{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [self setRequestProperties:request];    
    return request;
}
-(NSString * ) fetchHtmlWithRequest:(NSString *)url
{
    [self setError:nil ];
    ASIHTTPRequest * request = [self requestWithUrl:url];
    ACLog(@"MopooRemoteServer请求远程服务器地址：%@", url);
    [request startSynchronous];
    if (request.error){
        [self setError:request.error];
        return nil;
    }
    return [request responseString ];    
}

-(NSData *) fetchDataWithUrl:(NSString *)url
{
    [self setError:nil ];
    NSMutableString * mString = [NSMutableString stringWithString:url];
    [mString replaceOccurrencesOfString:@"www.253874.com" withString:REAL_MOPOO_IP options:NSLiteralSearch range:NSMakeRange(0, [mString length])];
    url = mString;
    NSLog(@"请求远程地址:%@",url);
    ASIHTTPRequest * request = [self requestWithUrl:url];
    [request startSynchronous];
    if (request.error){
        [self setError:request.error];
        return nil;
    }
    return [request responseData ];    
}

#pragma load data from resource file

-(NSString *) stringFromFixjs
{
    if (_fixjs ==NULL){
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"fixjs" ofType:@"javascript"];
        _fixjs = [NSString stringWithContentsOfFile:filePath encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
    }
    return _fixjs;
}
-(NSString *) stringFromLeftCss
{   
    if(_leftcss==NULL){
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"leftcss" ofType:@"css"];
        NSString * leftcss = [NSString stringWithContentsOfFile:filePath encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
        NSString * fontSize = [[MopooUserDefaults sharedUserDefaults] fontSize];
        NSString * leftLineHeight = [[MopooUserDefaults sharedUserDefaults] lineHeight];
        NSMutableString * mString = [[NSMutableString alloc] initWithString:leftcss];
        [mString replaceOccurrencesOfString:@"%font_size%" withString:fontSize options:NSLiteralSearch range:NSMakeRange(0, [mString length])];
        [mString replaceOccurrencesOfString:@"%line_height%" withString:leftLineHeight options:NSLiteralSearch range:NSMakeRange(0, [mString length])];
        _leftcss = mString; 
    }
    return _leftcss;
}
-(NSString *) stringFromRightCss
{
    if(_rightcss == NULL){
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"rightcss" ofType:@"css"];
        NSString * rightcss = [NSString stringWithContentsOfFile:filePath encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
        NSString * fontSize = [[MopooUserDefaults sharedUserDefaults] fontSize];
        NSString * rightLineHeight = [[MopooUserDefaults sharedUserDefaults] lineHeight];
        NSMutableString * mString = [[NSMutableString alloc] initWithString:rightcss];
        [mString replaceOccurrencesOfString:@"%font_size%" withString:fontSize options:NSLiteralSearch range:NSMakeRange(0, [mString length])];
        [mString replaceOccurrencesOfString:@"%line_height%" withString:rightLineHeight options:NSLiteralSearch range:NSMakeRange(0, [mString length])];        
        _rightcss = mString;
    }
    return _rightcss;
}


-(void) clearCacheCSS
{
    if (_leftcss!=NULL) {
        _leftcss =NULL;
    }
    
    if (_rightcss!=NULL) {
        _rightcss =NULL;
    }
}















@end
