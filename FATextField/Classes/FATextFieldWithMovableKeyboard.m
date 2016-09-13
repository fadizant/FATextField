//
//  FATextFieldWithMovableKeyboard.m
//  SlideBar
//
//  Created by Fadi on 25/8/15.
//  Copyright (c) 2015 BeeCell. All rights reserved.
//

#import "FATextFieldWithMovableKeyboard.h"

@implementation FATextFieldWithMovableKeyboard
@synthesize tap;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //handle SHow keyboard
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShownHide:)
                                                     name:UIKeyboardWillShowNotification //UIKeyboardDidShowNotification
                                                   object:nil];
        //handle Hide keyboard
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShownHide:)
                                                     name:UIKeyboardWillHideNotification//UIKeyboardWillHideNotification
                                                   object:nil];
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

//placeholder
-(void)setPlaceholderText
{
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)] && self.placeholder) {
        
        _placeholderColor = _placeholderColor ? _placeholderColor : [UIColor darkGrayColor];
        
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.attributedPlaceholder.string attributes:@{NSForegroundColorAttributeName: _placeholderColor}];
        
        self.delegate = self;
        self.initFrame = CGRectZero;
        
        
        //add toolBar
        [self addToolBar];
        
        
    }
    
}

//Border
- (void)layoutSubviews{
    
    [super layoutSubviews];
    [self layoutIfNeeded];
    
    self.layer.borderColor = [_borderColor CGColor];
    self.layer.borderWidth = _borderWidth;
    //circle Image
    [self.layer setCornerRadius:_borderCorner];
    [self.layer setMasksToBounds:YES];
    
}

//Handle keyboard
- (void)keyboardWasShownHide:(NSNotification *)notification {
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIView *parant = self.superview;
    CGRect parantFrame = parant.frame;
    float animationDelay = 0;
    
//    if (CGRectEqualToRect(self.initFrame, CGRectZero)) {
//        self.initFrame = parant.frame;
//    }
    
    //add and remove GestureRecognizer
    if (![parant.gestureRecognizers containsObject:tap]) {
        [parant addGestureRecognizer:tap];
    }
    else if(tap && [notification.name isEqualToString: UIKeyboardWillHideNotification]){
        [parant removeGestureRecognizer:tap];
    }
    
    //if textfield note foucesed
    if (![self isFirstResponder]) {
        return;
    }
    
    if ([parant.superview isKindOfClass:[UIScrollView class]]) {
        parantFrame.size = ((UIScrollView*)parant.superview).contentSize;
//        parantFrame.size = self.initFrame.size;
        
        //scroll to view
        CGRect frame = self.frame;
//        frame.size.height = (keyboardSize.height + frame.size.height + frame.origin.y) > parant.frame.size.height ? frame.size.height : (keyboardSize.height + frame.size.height);
//        frame.size.height =  parantFrame.size.height - frame.origin.y;
frame.size.height +=  keyboardSize.height;
        
        [((UIScrollView*)parant.superview) scrollRectToVisible:frame animated:NO];
        animationDelay = 0.2;
    }
    
    

    //if view above keyboard
    if (((parantFrame.size.height - (self.frame.origin.y + self.frame.size.height)) > keyboardSize.height) &&  [notification.name isEqualToString: UIKeyboardWillShowNotification] ) {
        return;
    }



    
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    
    //animation time
    duration = ([notification.name isEqualToString: UIKeyboardWillShowNotification]  ? duration + 0.2 : duration - 0.5);
    const float movementDuration = duration ; // tweak as needed
    

    //set new y axis
    float y = (self.frame.origin.y + self.frame.size.height) - (parantFrame.size.height - (float)keyboardSize.height);
    
    //set new frame
    CGRect newFram = parant.frame;
    newFram.origin.y = ([notification.name isEqualToString: UIKeyboardWillShowNotification]  ? -y : self.initFrame.origin.y);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, animationDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //make animation
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        [UIView setAnimationDelay:animationDelay];
        //parant.frame = CGRectOffset(parant.frame, 0, movement);
        parant.frame = newFram;
        [UIView commitAnimations];
    });
    
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    switch (textField.returnKeyType) {
        case UIReturnKeyNext:
            if (nextResponder) {
                // Found next responder, so set it.
                [self hideKeyboard];
                [nextResponder becomeFirstResponder];
            } else {
                // Not found, so remove keyboard.
                [textField resignFirstResponder];
            }
            return NO; // We do not want UITextField to insert line-breaks.
            break;
        case UIReturnKeyDone:
            [self hideKeyboard];
            return YES;
            break;
        default:
            return YES;
            break;
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    [self addToolBar];
    [self setPlaceholderText];
    if (CGRectEqualToRect(self.initFrame, CGRectZero)) {
        self.initFrame = self.superview.frame;
    }
    return bounds;
}

-(void)addToolBar
{
    //add tool bar
    if (_toolBar && !self.inputAccessoryView) {
        UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *nextBarButton,*preBarButton,*flexBarButton,*doneBarButton,*marginSpace;
        if (_toolBarNextPre) {
            BOOL hasNext = NO,hasPre = NO,Found = NO;
            
            for (UIView *item in self.superview.subviews) {
                if(([item isKindOfClass:[UITextField class]] || [item isKindOfClass:[UITextView class]]) && item.isUserInteractionEnabled && item != self && !Found)
                {
                    hasPre = YES;
                }
                
                if (item == self && !Found) {
                    Found = YES;
                }
                else if(([item isKindOfClass:[UITextField class]] || [item isKindOfClass:[UITextView class]])  && item.isUserInteractionEnabled && Found)
                {
                    hasNext = YES;
                    break;
                }
            }
            
            nextBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nextTextField"] style:UIBarButtonItemStylePlain target:self action:@selector(yourTextViewNextButtonPressed)];
            nextBarButton.enabled = hasNext;
            
            preBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preTextField"] style:UIBarButtonItemStylePlain target:self action:@selector(yourTextViewPreButtonPressed)];
            preBarButton.enabled = hasPre;
        }

        flexBarButton = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil action:nil];
//        doneBarButton = [[UIBarButtonItem alloc]
//                                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                          target:self action:@selector(yourTextViewDoneButtonPressed)];
        doneBarButton = [[UIBarButtonItem alloc]
                         initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleDone target:self action:@selector(yourTextViewDoneButtonPressed)];
        marginSpace = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                         target:nil action:nil];
        marginSpace.width = 5;
        
        
        keyboardToolbar.items = _toolBarNextPre ? @[preBarButton,nextBarButton,flexBarButton, doneBarButton,marginSpace]:@[flexBarButton, doneBarButton,marginSpace];
        if(_toolBarColor)
        keyboardToolbar.tintColor = _toolBarColor;
        self.inputAccessoryView = keyboardToolbar;
    }
}

-(void)hideKeyboard {
    [self.superview endEditing:YES];
}

//Hide in click Done
-(void)yourTextViewDoneButtonPressed
{
    [self resignFirstResponder];
}
//Next text field
-(void)yourTextViewNextButtonPressed
{
    BOOL Found = NO;
    for (UIView *item in self.superview.subviews) {
        if (item == self && !Found) {
            Found = YES;
        }
        else if(([item isKindOfClass:[UITextField class]] || [item isKindOfClass:[UITextView class]])  && item.isUserInteractionEnabled && Found)
        {
            [self hideKeyboard];
            [item becomeFirstResponder];
            return;
        }
    }
    [self resignFirstResponder];
}
//Pre text field
-(void)yourTextViewPreButtonPressed
{
    UIView *preView;
    for (UIView *item in self.superview.subviews) {
        if(([item isKindOfClass:[UITextField class]] || [item isKindOfClass:[UITextView class]])  && item.isUserInteractionEnabled && item != self)
        {
            preView = item;
        }
        else if(item == self)
        {
            [self hideKeyboard];
            [preView becomeFirstResponder];
            return;
        }
    }
    [self resignFirstResponder];
}

//// placeholder position
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectInset(bounds, 10, 10);
//}
//
//// text position
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return CGRectInset(bounds, 10, 10);
//}

@end
