//
//  MopooRemoteServer.h
//  Mopoo
//
//  Created by altchen on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MopooRemoteServer : NSObject {
    NSError * error;
    NSStringEncoding defaultEncoding;
    NSString * _fixjs;
    NSString * _leftcss;
    NSString * _rightcss;
    NSDate * _lastVisitIndexDate;
}
@property (nonatomic,strong) NSError * error;
@property (nonatomic,strong) NSDate * lastVisitIndexDate;
+(MopooRemoteServer *) sharedRemoteServer;
-(BOOL) login:(NSString *) user withPassword:(NSString *) password;
-(BOOL) haveIndexCookie;
-(NSString *) fetchTopicListHtml:(BOOL)useCache useRemote:(BOOL) isUseRemote;
-(NSString *) fetchSearchHtml:(NSString*) key searchType:(NSString*) searchType useCache:(BOOL)isUseCache useRemote:(BOOL) isUseRemote;
-(NSString*) fetchInfoNewHtml:(NSString *) lastUrl;
-(NSString *) fetchTopicHtml:(NSString *) topicId viewPlay:(BOOL)isViewPay useCache:(BOOL)isUseCache useRemote:(BOOL) isUseRemote;
-(NSString *) fetchChatHtml;
-(NSData * ) fetchDataWithUrl:(NSString *) url;
-(NSArray *  ) fetchOtherUserReplayByURL:(NSString *) url;
-(void) clearCacheCSS;
-(BOOL) postNewTopic:(NSString *) title body:(NSString *) bodyText nimin:(BOOL) isNimin;
-(BOOL) doReply:(NSString *) topicId replayText:(NSString *) text nimin:(BOOL) isNimin lc:(NSString* ) lc lcText:(NSString *) lcText;
-(BOOL) doEditReply:(NSString *) topicId editReplyId:(NSString *) replyId replyText:(NSString *) text ;
-(BOOL) delReply:(NSString *) topicId editReplyId:(NSString *) replyId;
-(NSString *) fetchReplyText:(NSString *) topicId editReplyId:replyId;
-(BOOL) favTopic:(NSString *) topicId;
-(BOOL) sendChat:(NSString *)msg;
-(BOOL) isLogin;
-(void) logout;
@end
