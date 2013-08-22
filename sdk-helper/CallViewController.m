//
//  CallViewController.m
//  sdk-helper
//
//  Created by Charles Thierry on 7/19/13.
//  Copyright (c) 2013 Weemo SAS. All rights reserved.
//

#import "CallViewController.h"
#import "ViewController.h"

@interface CallViewController ()

@end

@implementation CallViewController
@synthesize b_hangup;
@synthesize b_profile;
@synthesize b_toggleVideo;
@synthesize b_toggleAudio;
@synthesize call;
@synthesize v_videoIn;
@synthesize v_videoOut;

#pragma mark - Controller life cycle
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		[self setCall:[[Weemo instance] activeCall]];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[self call]setDelegate:self];
	[[self call]setViewVideoIn:[self v_videoIn]];
	[[self call]setViewVideoOut:[self v_videoOut]];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self resizeView:[self interfaceOrientation]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)tO duration:(NSTimeInterval)duration
{
	[self resizeView:tO];
}


//updates the VideoViews location
- (void)resizeView:(UIInterfaceOrientation)tO
{
	[[self view]setFrame:CGRectMake(0., 0., [[[self view]superview]bounds].size.width, [[[self view]superview]bounds].size.height)];
	if (UIInterfaceOrientationIsPortrait(tO))
	{
		[[self v_videoIn] setCenter:CGPointMake([[self view]frame].size.width/2., [[self v_videoIn]frame].size.height/2.+ b_hangup.frame.size.height + 2.)];
		[[self v_videoOut]setCenter:CGPointMake([[self view]frame].size.width/2.,
												[[self view]frame].size.height - [[self v_videoOut]frame].size.height/2.)];
	} else if (UIInterfaceOrientationIsLandscape(tO))
	{
		[[self v_videoIn] setCenter:CGPointMake([[self v_videoIn]frame].size.width/2.+2., [[self view] frame].size.height/2.+ b_hangup.frame.size.height)];
		
		[[self v_videoOut]setCenter:CGPointMake([[self view]frame].size.width - [[self v_videoOut]frame].size.width / 2.,
												[[self view]frame].size.height/2.)];
	}
}

#pragma mark - Actions

- (IBAction)hangup:(id)sender
{
	[[self call]hangup];
}

- (IBAction)profile:(id)sender
{
	[[self call] toggleVideoProfile];
}

- (IBAction)toggleVideo:(id)sender
{
	if ([sender isSelected])
	{
		[[self call] videoStop];
	} else {
		[[self call] videoStart];
	}
}

- (IBAction)switchVideo:(id)sender
{
	[[self call] toggleVideoSource];
}

- (IBAction)toggleAudio:(id)sender
{
	if ([sender isSelected])
	{
		[[self call] audioStop];
	} else {
		[[self call] audioStart];
	}
}


#pragma mark - Call delegate

- (void)updateIdleStatus
{
	if ([[self call] isSendingVideo] || [[self call] isReceivingVideo])
	{
		[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	} else {
		[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	}
}

- (void)weemoCall:(id)sender videoReceiving:(BOOL)isReceiving
{
	NSLog(@">>>> CallViewController: Receiving: %@", isReceiving ? @"YES":@"NO");
	[self updateIdleStatus];
	dispatch_async(dispatch_get_main_queue(), ^{
		[[self v_videoIn]setHidden:!isReceiving];
	});
}


- (void)weemoCall:(id)sender videoSending:(BOOL)isSending
{
	NSLog(@">>>> CallViewController: Sending: %@", isSending ? @"YES":@"NO");
	[self updateIdleStatus];
	dispatch_async(dispatch_get_main_queue(), ^{
		[[self b_toggleVideo]setSelected:isSending];
		[[self v_videoOut]setHidden:!isSending];
	});
}



- (void)weemoCall:(id)sender videoProfile:(int)profile
{	
	dispatch_async(dispatch_get_main_queue(), ^{
		NSLog(@">>>> CallViewController: videoProfile: %d", profile);
		[[self b_profile]setSelected:(profile != 0)];
	});
}

- (void)weemoCall:(id)sender videoSource:(int)source
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSLog(@">>>> CallViewController: switchVideoSource: %@", (source == 0)?@"Front":@"Back");
		[[self b_switchVideo] setSelected:(source == 0)];
	});
}

- (void)weemoCall:(id)call audioSending:(BOOL)isSending
{
	
	dispatch_async(dispatch_get_main_queue(), ^{
		NSLog(@">>>> CallViewController: audioSending:%@", isSending?@"YES":@"NO");
		[[self b_toggleAudio]setSelected:isSending];
	});
}

- (void)weemoCall:(id)sender callStatus:(int)status
{
	NSLog(@">>>> CallViewController: callStatus: 0x%X", status);
	[self updateIdleStatus];
	dispatch_async(dispatch_get_main_queue(), ^{
		if (status == CALLSTATUS_ACTIVE)
		{
			NSLog(@">>>> CallViewController: call went active");
			[(ViewController*)[self parentViewController] addCallView];
		}
		if (status == CALLSTATUS_ENDED)
		{
			NSLog(@">>>> CallViewController: call was ended");
			[(ViewController*)[self parentViewController] removeCallView];
		}
	});
}

@end
