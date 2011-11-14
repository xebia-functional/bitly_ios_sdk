//
//  BitlyConfig.m
//  BitlyLib
//
//  Created by Tracy Pesin on 8/12/11.
//  Copyright (c) 2011 Betaworks. All rights reserved.
//

#import "BitlyConfig.h"

@implementation BitlyConfig

NSString *BitlyLogin=nil;
NSString *BitlyApiKey=nil;

NSString *BitlyTwitterOAuthConsumerKey = nil;
NSString *BitlyTwitterOAuthConsumerSecret = nil;
NSString *BitlyTwitterOAuthSuccessCallbackURL = nil;

//These should be the same for everyone, but can be doublechecked at https://dev.twitter.com/apps/ 
NSString * const BitlyTwitterRequestTokenURL = @"https://api.twitter.com/oauth/request_token";
NSString * const BitlyTwitterAccessTokenURL = @"https://api.twitter.com/oauth/access_token";
NSString * const BitlyTwitterAuthorizeURLFormat = @"https://api.twitter.com/oauth/authorize?oauth_token=%@";


+ (void)setBitlyLogin:(NSString *)bitlyLogin bitlyApiKey:(NSString *)bitlyApiKey {
    BitlyLogin = bitlyLogin;
    BitlyApiKey = bitlyApiKey;
}

+ (void)setTwitterOAuthConsumerKey:(NSString *)consumerKey 
        twitterOAuthConsumerSecret:(NSString *)consumerSecret 
    twitterOAuthSuccessCallbackURL:(NSString *)successCallbackURL {
    BitlyTwitterOAuthConsumerKey = consumerKey;
    BitlyTwitterOAuthConsumerSecret = consumerSecret;
    BitlyTwitterOAuthSuccessCallbackURL = successCallbackURL;
}


@end
