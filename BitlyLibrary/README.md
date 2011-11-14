# Bitly Twitter Library

## Introduction

The Bitly Twitter library allows you to easily include Twitter sharing in your application. It builds on top of the iOS5 twitter integration, but with these advantages over Apple's TWTweetComposeViewController:

* Is backwards compatible to iOS4 (must be compiled against iOS5, but can be deployed onto iOS4 devices.)
* Shortens links in tweets using bitly, so that your company can take advantage of its bitly custom domains and sharing analytics. If you don't have a custom domain, you can create one for free!
* Shortens links in real time, so users can see exactly how their tweet will appear. 
* Is open source, so you can customize it as desired. 

Additionally, if you would prefer to shorten links using bitly but present your own UI, the library provides convenience classes to support this.

## Supported iOS Versions

The library must be built against iOS5, but can be deployed onto iOS 4.2+. When running against iOS5, the library automatically uses the Twitter accounts configured by the user in the Settings app. On iOS4, the library uses OAuth to authenticate the user.

## Setting Up

The easiest way to integrate this project is to use the shared library (.a file). However, if you would like the source, you can download it from https://github.com/bitly/bitly\_ios\_sdk. **THIS LINK WILL NEED UPDATING WHEN WE SWITCH TO PUBLIC REPO**

### Create api keys

#### 1) Create bitly api keys

If you don't already have a bitly api key, obtain one here: http://bitly.com/a/sign_up. 
	
#### 2) Create twitter api keys
	
If your company doesn't already have twitter OAuth keys, create them here: https://dev.twitter.com/apps/new. **Important** -- You must set a callback URL, even though the user will never see that page. The library will intercept redirects to that URL and act accordingly. As an example, our project uses @"http://twitterauthsuccess.bit.ly";


#### 3) If desired, run the sample project to validate your keys

**TODO**: I need to build a sample project that only includes the static library, not all the source. 
	
Build and run the BitlyLib target, using a version of Xcode that includes the iOS5 SDK. **While the library must be built against iOS5, it will run on iOS 4.2+.**
	
Make sure that links typed in the text box are being shortened, indicating that your bitly api key is working. Links are shortened whenever the user types a space character, hits "Done" on the keypad, or sends the tweet.  
	
Send a test tweet to make sure your twitter keys are working.
	
	
### Add BitlyLib to your project

#### 1) Download the zip file
(Dennis, we can't publish this until iOS5 is released because of Apple NDA restrictions. You can find the zip file in the "distribution" directory of the github project for now.)
	
Unzip the file. Add the Bitly folder to your project, selecting "Copy items into destination group's folder (if needed)." 
	
Link to the libbitly.a framework. (In the "Build Phases" tab of your project's target, open the "Link Binary with Libraries" item and add libbitly.a.) 
	
	
#### 2) Link to the required frameworks

In the "Build Phases" tab of your project's target, open the "Link Binary with Libraries" item. Add these frameworks if you're not already linking to them:
	* Security.framework
	* QuartzCore.framework
	* Accounts.framework *NOTE if you are supporting OS versions less than iOS5, this must be marked "Optional", not "Required"*
	* Twitter.framework *NOTE if you are supporting OS versions less than iOS5, this must be marked "Optional", not "Required"*

#### 3) Set the -ObjC linker flag

In the "Build Settings" tab of your project's target, open "Other Linker Flags" and add "-ObjC" to it. 



#### Notes on building from source

If you followed the steps above and are using the libbitly.a static library, don't worry about all this. It's only needed if you decide to pull in the source rather than the .a file. 

If you cloned the project from git, run this command to retrieve the dependencies:

	git submodule update --init

Note on ARC: The current version of this library is not built with ARC, because there were some known bugs in the early betas of iOS5 in the interaction between the twitter integration and ARC that prevented development using ARC. If your project uses ARC, you will have to turn this off on a per-file basis. **NOTE this can't be made public until iOS5 is no longer under NDA.** Select your target, and under "Build Phases" -> Compile Sources, set the Compiler Flags to -fno-objc-arc for all BitlyLib, TouchJSON, and OAuthConsumer implementation files. 
	

## How to use

### Set your API key information

(See "Create api keys above"" if you don't have keys)

Call these two methods to set your credentials. You may want to do this in your application:didFinishLaunching implementation:

	[BitlyConfig setBitlyLogin:<your bitly login> bitlyApiKey:<your bitly api key>];

    [BitlyConfig setTwitterOAuthConsumerKey:<your consumer key> twitterOAuthConsumerSecret:<your consumer secret> twitterOAuthSuccessCallbackURL:<your callback url>];
	

### Using the bitly TweetSheet

#### 1) Create the bitly TweetSheet
	
	BitlyTweetSheet *tweetsheet = [[BitlyTweetSheet alloc] init];

Set the delegate to the appropriate object:

	tweetsheet.delegate = self;
	
#### 2) Set the tweet contents

You can optionally set the initial text to populate the tweet:

	tweetsheet.initialText = @"Check out this link: http://some.domain.com/myLongURL?someQuery";
	
You can also append a URL to the text:
	
	[tweetsheet addURL:[NSURL URLWithString:@"http://another.domain.com/anotherLongURL?anotherQuery"]];
	
The TweetSheet will automatically convert all long URLs to short URLs.

#### 3) Implement the delegate methods

All BitlyTweetSheetDelegate methods are optional, however you will probably want to implement them to know when the operation is complete and the TweetSheet can be dismissed.

	- (void)bitlyTweetSheetDidSendTweet:(BitlyTweetSheet *)viewController;
	- (void)bitlyTweetSheet:(BitlyTweetSheet *)viewController didFailWithError:(NSError *)error;
	- (void)bitlyTweetSheetUserCancelledTweet:(BitlyTweetSheet *)viewController;
	- (void)bitlyTweetSheet:(BitlyTweetSheet *)viewController textDidChange:(NSString *)text;
	
	/*These two methods are only relevant when on iOS5+ since they refer to the Accounts framework. */
	- (void)bitlyTweetSheetAccountAccessDenied:(BitlyTweetSheet *)viewController;
	- (void)bitlyTweetSheetNoAccountsAvailable:(BitlyTweetSheet *)viewController;

#### 4) Display the TweetSheet

The BitlyTweetSheet can be displayed as a modal view on the iPhone, and either a popover or modal on the iPad.

To display modally on iPhone or iPad, call presentModallyFromViewController with the parent view controller for the modal, for example:
	
	[tweetsheet presentModallyFromViewController:self];
	
To display as a popover on iPad, get the popoverController instance from the TweetSheet and display it, for example:

	UIPopoverController *popoverController = self.bitlyShareController.popoverController;
    [popoverController presentPopoverFromRect:((UIView *)sender).frame 
                                                inView:self.view 
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:NO];
    
*Note:* while the popover is a nice UI choice for the iPad, the user can easily dismiss the popover by accident by tapping outside its bounds, possibly undoing work they've done to customize the tweet. You may want to remember the last text inside your underlying view controller, and present that text if the user raises the popover a second time. You can get access to that text by implementing this delegate method:

	- (void)bitlyTweetSheet:(BitlyTweetSheet *)viewController textDidChange:(NSString *)text;
	

### Using your own UI

To integrate bitly URL shortening with your own twitter UI, you can either use the BitlyTextView component, or the BitlyURLShortener

#### 1) Using BitlyTextView

Using BitlyTextView is an intermediate solution for when you want automatic URL shortening in a UITextView, but prefer to surround the textview with your own UI.

To use, add it to your interface the way you would any UIView instance, either by calling initWithFrame or adding it to a nib file. Set the delegate to the appropriate object:

	BitlyTextView *bitlyTextView = [[BitlyTextView alloc] initWithFrame:CGRectMake(x, y, width, height)];
	bitlyTextView.delegate = self;
	
Implement the delegate callback if you need to know when the text has changed, for example to update a character count: 
	
	- (void)bitlyTextView:(BitlyTextView *)textView didShortenLinks:(NSDictionary *)linkDictionary 
	              oldText:(NSString *)oldText text:(NSString *)text;
	
#### 2) Using BitlyURLShortener

When you just want to shorten a link with bitly, use the BitlyURLShortener class. 

	BitlyURLShortener *bitly = [[BitlyURLShortener alloc] init];
	bitly.delegate = self;

This class can be called with a single NSURL:

	[bitly shortenURL:[NSURL URLWithString:@"http://www.mylongdomain.com/mylongurl"]];

Or with an NSString object, in which case it will shorten all URLs in the text:

	[bitly shortenLinksInText:@"Here are two links to shorten: http://www.longdomain1.com/longurl1 and http://www.longdomain2.com/longurl2"];
	
Implement the delegate callbacks appropriate to your needs:

	/* Called after all URLs in the text are either shortened, or have had shortening attempted and failed */
	- (void)bitlyURLShortenerDidShortenText:(BitlyURLShortener *)shortener oldText:(NSString *)text text:(NSString *)text linkDictionary:(NSDictionary *)dictionary;

	/* Called when each URL is successfully shortened. */ 
	- (void)bitlyURLShortenerDidShortenURL:(BitlyURLShortener *)shortener longURL:(NSURL *)longURL shortURLString:(NSString *)shortURLString; 

	/* Called whenever shortening fails for an individual link. Developers can choose to implement this if they need to debug problems with url shortening, such as an invalid api key. */
	- (void)bitlyURLShortener:(BitlyURLShortener *)shortener 
	        didFailForLongURL:(NSURL *)longURL 
	               statusCode:(NSInteger)statusCode
	               statusText:(NSString *)statusText;
 
	




 
