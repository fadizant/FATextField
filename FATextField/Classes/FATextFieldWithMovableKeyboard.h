//
//  FATextFieldWithMovableKeyboard.h
//  SlideBar
//
//  Created by Fadi on 25/8/15.
//  Copyright (c) 2015 BeeCell. All rights reserved.
//

#import <UIKit/UIKit.h>
//View IBInspectable property in UI
IB_DESIGNABLE

@interface FATextFieldWithMovableKeyboard : UITextField<UITextFieldDelegate>

@property (nonatomic) IBInspectable BOOL toolBar;
@property (nonatomic) IBInspectable BOOL toolBarNextPre;
@property (nonatomic,retain) IBInspectable UIColor *toolBarColor;

@property (nonatomic,retain) IBInspectable UIColor *placeholderColor;
-(void)setPlaceholderText;

#pragma mark UI Property
/**
 * Border Color
 */
@property (nonatomic,retain) IBInspectable UIColor *borderColor;
/**
 * Border Width
 */
@property (nonatomic) IBInspectable CGFloat borderWidth;
/**
 * Corner
 */
@property (nonatomic) IBInspectable CGFloat borderCorner;

@property (nonatomic) CGRect initFrame;
@property (strong,nonatomic) UITapGestureRecognizer *tap ;
-(void)hideKeyboard;
- (void)keyboardWasShownHide:(NSNotification *)notification;
@end
