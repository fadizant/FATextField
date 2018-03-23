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
{
    UIView *bottomBorder;
}

@property (nonatomic) IBInspectable BOOL toolBar;
@property (nonatomic) IBInspectable BOOL toolBarNextPre;
@property (nonatomic,retain) IBInspectable UIColor *toolBarColor;

@property (nonatomic,retain) IBInspectable UIColor *placeholderColor;
-(void)setPlaceholderText;

@property (nonatomic) IBInspectable BOOL isBottomBorder;

#pragma mark UI Property
/**
 * Border Color
 */
@property (nonatomic,retain) IBInspectable UIColor *borderColor;
/**
 * Selected Border Color
 */
@property (nonatomic,retain) IBInspectable UIColor *borderSelectedColor;
/**
 * Highlighted Border Color
 */
@property (nonatomic,retain) IBInspectable UIColor *borderEditingColor;
/**
 * Border Width
 */
@property (nonatomic) IBInspectable CGFloat borderWidth;
/**
 * Corner
 */
@property (nonatomic) IBInspectable CGFloat borderCorner;
/**
 * X padding
 */
@property (nonatomic) IBInspectable CGFloat textStartPadding;
/**
 * Y padding
 */
@property (nonatomic) IBInspectable CGFloat textTopPadding;
/**
 * Allow view to move with keyboard
 *
 * Defaults false
 */
@property (nonatomic) IBInspectable BOOL moveWithKeyboard;

@property (nonatomic) CGRect initFrame;
@property (strong,nonatomic) UITapGestureRecognizer *tap ;
-(void)hideKeyboard;
- (void)keyboardWasShownHide:(NSNotification *)notification;

-(void)removeMoving;
@end
