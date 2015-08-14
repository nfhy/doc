//
//  SKScene.h
//  SpriteKit
//
//  Copyright (c) 2011 Apple Inc. All rights reserved.
//

#import <SpriteKit/SKEffectNode.h>
#import <SpriteKit/SpriteKitBase.h>

@class SKView, SKPhysicsWorld;

typedef NS_ENUM(NSInteger, SKSceneScaleMode1) {
    SKSceneScaleModeFill1,           /* Scale the SKScene to fill the entire SKView. 宽与高各自伸缩，铺满frame，会导致图像变形，不会丢失图像信息*/
    SKSceneScaleModeAspectFill1,     /* Scale the SKScene to fill the SKView while preserving the scene's aspect ratio. Some cropping may occur if the view has a different aspect ratio. 宽高伸缩比例相同，铺满frame，图像不会变形，但是有可能丢失图像*/
    SKSceneScaleModeAspectFit1,      /* Scale the SKScene to fit within the SKView while preserving the scene's aspect ratio. Some letterboxing may occur if the view has a different aspect ratio. 宽高伸缩比例相同，图像不会变形，不会丢失图像，但有可能出现黑边。*/
    /*以上三者间可以互相变换*/
    /*当初始为第四个时，系统认为图像的高宽与frame相同，修改类型时不需要伸缩，所以图像不会变化*/
    SKSceneScaleModeResizeFill1      /* Modify the SKScene's actual size to exactly match the SKView. 图像定位于frame坐下角，图像不会伸缩，但背景会延伸直至铺满整个frame，不会丢失图像，但是图像位置会出现变化。*/
} NS_ENUM_AVAILABLE(10_9, 7_0);

NS_AVAILABLE(10_10, 8_0) @protocol SKSceneDelegate1 <NSObject>
@optional
- (void)update:(NSTimeInterval)currentTime forScene:(SKScene *)scene;
- (void)didEvaluateActionsForScene:(SKScene *)scene;
- (void)didSimulatePhysicsForScene:(SKScene *)scene;

- (void)didApplyConstraintsForScene:(SKScene *)scene;
- (void)didFinishUpdateForScene:(SKScene *)scene;
@end

/**
 A scene is the root node of your content. It is used to display SpriteKit content on an SKView.
 toDo list in a new frame
 1.call update 调用update方法
 2.evaluate actions 执行Action
 3.call didEvaluateActions 执行Action结束，调用didEvaluateActions方法
 4.simulate physics 进行物理模拟
 5.call didSimulateActions 物理模拟结束，调用didSimulatePhysics方法
 6.apply constraints 使约束生效
 7.call didApplyConstraints 约束生效结束，调用didApplyConstraint方法
 8.call didFinishUpdate 调用didFinishUpdate方法
 9.render scence and nodes 渲染画面
 @see SKView
 */
SK_EXPORT @interface SKSceneAbout : SKEffectNode

/**
 Called once when the scene is created, do your one-time setup here.
 
 A scene is infinitely large, but it has a viewport that is the frame through which you present the content of the scene.
 The passed in size defines the size of this viewport that you use to present the scene.
 To display different portions of your scene, move the contents relative to the viewport. One way to do that is to create a SKNode to function as a viewport transformation. That node should have all visible conents parented under it.
 
 @param size a size in points that signifies the viewport into the scene that defines your framing of the scene.
 scene本身无限大，但是frame限制了可以显示的内容大小，通过参数size来确定。
 类指定的初始化方法
 */
- (instancetype)initWithSize:(CGSize)size;
/**
 等同于[[SKScene alloc] init]
 */
+ (instancetype)sceneWithSize:(CGSize)size;

@property (nonatomic) CGSize size;

/**
 Used to determine how to scale the scene to match the SKView it is being displayed in.
 */
@property (nonatomic) SKSceneScaleMode1 scaleMode;

/* Background color, defaults to gray */
@property (nonatomic, retain) SKColor *backgroundColor;

@property (nonatomic, assign) id<SKSceneDelegate1> delegate NS_AVAILABLE(10_10, 8_0);

/**
 Used to choose the origin of the scene's coordinate system
 anchorPoint处于本Scene的View坐标系中，anchorPoint和size一起决定了view中的哪一部分是可以显示的，他们共同决定了Scene的可见区域。
 */
@property (nonatomic) CGPoint anchorPoint;

/**
 Physics simulation functionality
 */
@property (nonatomic, readonly) SKPhysicsWorld *physicsWorld;

- (CGPoint)convertPointFromView:(CGPoint)point;
- (CGPoint)convertPointToView:(CGPoint)point;

/**
 The SKView this scene is currently presented in, or nil if it is not being presented.
 */
@property (nonatomic, weak, readonly) SKView *view;

/**
 Override this to perform per-frame game logic. Called exactly once per frame before any actions are evaluated and any physics are simulated.
 
 @param currentTime the current time in the app. This must be monotonically increasing.
 */
- (void)update:(NSTimeInterval)currentTime;

/**
 Override this to perform game logic. Called exactly once per frame after any actions have been evaluated but before any physics are simulated. Any additional actions applied is not evaluated until the next update.
 */
- (void)didEvaluateActions;

/**
 Override this to perform game logic. Called exactly once per frame after any actions have been evaluated and any physics have been simulated. Any additional actions applied is not evaluated until the next update. Any changes to physics bodies is not simulated until the next update.
 */
- (void)didSimulatePhysics;

/**
 Override this to perform game logic. Called exactly once per frame after any enabled constraints have been applied. Any additional actions applied is not evaluated until the next update. Any changes to physics bodies is not simulated until the next update. Any changes to constarints will not be applied until the next update.
 */
- (void)didApplyConstraints NS_AVAILABLE(10_10, 8_0);

/**
 Override this to perform game logic. Called after all update logic has been completed. Any additional actions applied are not evaluated until the next update. Any changes to physics bodies are not simulated until the next update. Any changes to constarints will not be applied until the next update.
 
 No futher update logic will be applied to the scene after this call. Any values set on nodes here will be used when the scene is rendered for the current frame.
 */
- (void)didFinishUpdate NS_AVAILABLE(10_10, 8_0);

- (void)didMoveToView:(SKView *)view;
- (void)willMoveFromView:(SKView *)view;
- (void)didChangeSize:(CGSize)oldSize;

@end
