//
//  ViewController.m
//  TestIJKMedia
//
//  Created by 强新宇 on 16/8/10.
//  Copyright © 2016年 强新宇. All rights reserved.
//

#import "ViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>






#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (atomic, strong) NSURL *url;
@property (atomic, retain) IJKFFMoviePlayerController<IJKMediaPlayback> * player;
@property (weak, nonatomic) UIView *PlayerView;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UISlider *slider;


@property (nonatomic, strong)NSTimer * timer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    

    
  
    
    
    NSString * m3u_1 = @"http://pl-dxk.youku.com/playlist/m3u8?ids=%7B%22a1%22%3A%22419351534_mp4%22%2C%22v%22%3A%22XMTY3MzQwOTM1Ng%3D%3D_mp4%22%7D&ts=1470795309&ep=dCaTGk6EU80A4ybcjT8bYSm3dHcHXPoL%2FxyAgNdhBNNZLIG85HSwgOLUM%2F48QfQUHSAPEuI%3D&sid=64707953065351265e008&token=2929&ctype=12&ev=1&oip=3722188266";
    
    
    NSString * m3u_2 = @"http://pl.youku.com/playlist/m3u8?vid=XMTY3MzQwOTM1Ng==&type=mp4&ts=1470795309&keyframe=0&ep=dCaTGk6EU80A4ybcjT8bYSm3dHcHXJZ3knaG%2FJgDR8RANenBzjPcqJ%2B5TPY%3D&sid=64707953065351265e008&token=2929&ctype=12&ev=1&oip=3722188266";
    NSString * m3u_3 = @"http://pl.youku.com/playlist/m3u8?vid=XMTY3MzQwOTM1Ng==&type=mp4&ts=1470795310&keyframe=0&ep=dCaTGk6EU80A4ybcjT8bYSm3dHcHXJZ3knaG%2FJgDR8RANenBzjPcqJ%2B5TPY%3D&sid=64707953065351265e008&token=2929&ctype=12&ev=1&oip=3722188266";
    
    NSString * m3u_4 = @"http://pl.youku.com/playlist/m3u8?vid=XMTY3MzQwOTM1Ng==&type=mp4&ts=1470795311&keyframe=0&ep=dCaTGk6EU80A4ybcjT8bYSm3dHcHXJZ3knaG%2FJgDR8RANenBzjPcqJ%2B5TPY%3D&sid=64707953065351265e008&token=2929&ctype=12&ev=1&oip=3722188266";
    
    NSString * m3u_5 =@"http://pl.youku.com/playlist/m3u8?vid=XMTY3MzQwOTM1Ng==&type=mp4&ts=1470795310&keyframe=0&ep=dCaTGk6EU80A4ybcjT8bYSm3dHcHXJZ3knaG%2FJgDR8RANenBzjPcqJ%2B5TPY%3D&sid=64707953065351265e008&token=2929&ctype=12&ev=1&oip=3722188266";
    
    
    self.url = [NSURL URLWithString:m3u_4];

    
    [self.slider setThumbImage:[UIImage imageNamed:@"verify_code_button"] forState:UIControlStateNormal];
    _slider.minimumTrackTintColor = [UIColor clearColor];
    _slider.maximumTrackTintColor = [UIColor clearColor];
    _slider.backgroundColor = [UIColor clearColor];
    
    // slider开始滑动事件
    [_slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [_slider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [_slider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    // slider 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderTap:)];
    [_slider addGestureRecognizer:tap];
  
    
    
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
    
    UIView *playerView = [self.player view];
    
    UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    displayView.backgroundColor = [UIColor blackColor];
    self.PlayerView = displayView;
    self.PlayerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.PlayerView];
    
    playerView.frame = self.PlayerView.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.PlayerView insertSubview:playerView atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    [self installMovieNotificationObservers];

    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(change) userInfo:nil repeats:YES];


}

     
- (void)change
{
    
    self.slider.minimumValue = 0;
    self.slider.maximumValue = self.player.duration;
    
    self.slider.value = self.player.currentPlaybackTime;
    
    self.progress.progress = self.player.playableDuration / self.player.duration;
    
    
    
    NSLog(@" -----currentTime =>  %f,   duration => %f, playableDuration => %f",self.player.currentPlaybackTime,
          self.player.duration,self.player.playableDuration);
}

/**
 *  滑块相关方法
 *
 */
- (void)progressSliderTouchBegan: (UISlider *)sender {
    
    [self.player pause];
    
    
    [_timer setFireDate:[NSDate distantFuture]];//暂停timer
    
    NSLog(@" --- began touch");
}

- (void)progressSliderValueChanged: (UISlider *)sender {
    
    CGFloat sliderProgress = sender.value / sender.maximumValue;
    
    if (self.progress.progress < sliderProgress) {
        self.progress.progress = sender.value / sender.maximumValue;
    }
    
    
    
    NSLog(@" --- event touch  %f",sender.value);
    
    
}

- (void)progressSliderTouchEnded: (UISlider *)sender {
    
    
    self.player.currentPlaybackTime = sender.value;
    
    
    [self.player play];
    [_timer setFireDate:[NSDate distantPast]];//启动timer
    
    NSLog(@" ---- end touch");
}


/**
 *  Slider Tap
 */
- (void)sliderTap: (UITapGestureRecognizer *)sender {
    
    if ([sender.view isKindOfClass:[UISlider class]]) {
        
        UISlider *slider = (UISlider *)sender.view;
        CGPoint point = [sender locationInView:slider];
        CGFloat length = slider.frame.size.width;
        
        CGFloat tempValue = point.x / length;
        
        NSTimeInterval currentTime = self.player.duration * tempValue;
        self.player.currentPlaybackTime = currentTime;
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
}
- (IBAction)pause:(id)sender {
    [self.player pause];
}

- (IBAction)play:(id)sender {
    [self.player play];
}


#pragma Selector func

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma Install Notifiacation

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
