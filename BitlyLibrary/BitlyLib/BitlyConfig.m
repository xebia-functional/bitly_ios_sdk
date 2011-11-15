//
//  BitlyConfig.m
//  BitlyLib
//
//  Created by Tracy Pesin on 8/12/11.
//  Copyright (c) 2011 Betaworks. All rights reserved.
//

#import "BitlyConfig.h"

@interface BitlyConfig() {
    NSString *bitlyLogin;
    NSString *bitlyAPIKey;
}
- (NSDictionary *)plistConfig;

@end

static BitlyConfig *theInstance = nil;

@implementation BitlyConfig

NSString *BitlyTwitterOAuthConsumerKey = nil;
NSString *BitlyTwitterOAuthConsumerSecret = nil;
NSString *BitlyTwitterOAuthSuccessCallbackURL = nil;

//These should be the same for everyone, but can be doublechecked at https://dev.twitter.com/apps/ 
NSString * const BitlyTwitterRequestTokenURL = @"https://api.twitter.com/oauth/request_token";
NSString * const BitlyTwitterAccessTokenURL = @"https://api.twitter.com/oauth/access_token";
NSString * const BitlyTwitterAuthorizeURLFormat = @"https://api.twitter.com/oauth/authorize?oauth_token=%@";


+ (BitlyConfig *)sharedBitlyConfig {
    if (!theInstance) {
        theInstance = [[BitlyConfig alloc] init];
    }
    return theInstance;
}

- (void)setBitlyLogin:(NSString *)login bitlyAPIKey:(NSString *)apiKey {
    bitlyLogin = login;
    bitlyAPIKey = apiKey;
}

+ (void)setTwitterOAuthConsumerKey:(NSString *)consumerKey 
        twitterOAuthConsumerSecret:(NSString *)consumerSecret 
    twitterOAuthSuccessCallbackURL:(NSString *)successCallbackURL {
    BitlyTwitterOAuthConsumerKey = consumerKey;
    BitlyTwitterOAuthConsumerSecret = consumerSecret;
    BitlyTwitterOAuthSuccessCallbackURL = successCallbackURL;
}

- (NSDictionary *)plistConfig {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BitlyServices" ofType:@"plist"];
    if (plistPath) {
       return [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    } else {
        return nil;
    }
}

- (NSString *)bitlyLogin {
    if (!bitlyLogin) {
        NSDictionary *plistConfig = [self plistConfig];
        if (plistConfig) {
            bitlyLogin = [plistConfig objectForKey:@"BLYBitlyLogin"];
        } 
    }
    return bitlyLogin;
}

- (NSString *)bitlyAPIKey {
    if (!bitlyAPIKey) {
        NSDictionary *plistConfig = [self plistConfig];
        if (plistConfig) {
            bitlyAPIKey = [plistConfig objectForKey:@"BLYBitlyAPIKey"];
        }
    }
    return bitlyAPIKey;
}


@end
