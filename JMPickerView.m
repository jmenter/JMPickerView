/*

Copyright (c) 2013 Jeff Menter

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

#import "JMPickerView.h"

@interface JMPickerView ()
@property (nonatomic) UIView *pickerDismisserView;
@property (nonatomic, weak) UIViewController *topController;
@end

@implementation JMPickerView

static CGFloat kPickerViewStandardHeight = 216.f;
static CGFloat kDismissViewAlpha = 0.66f;
static CGFloat kAnimationDuration = 0.25f;
static CGFloat kTwoFifths = 0.4f;
static CGFloat kThreeFifths = 0.6;

// This is just a convenient init method.
// All we need are a delegate and to be added to a viewController's view.
- (JMPickerView *)initWithDelegate:(id<JMPickerViewDelegate>)delegate addingToViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.showsSelectionIndicator = YES;
        self.delegate = delegate;
        self.topController = viewController.navigationController ?: viewController;
        if ([viewController isKindOfClass:[UITableViewController class]]) {
            // Can't add ourselves to a UITableViewController (because it scrolls.)
            // Hopefully there's a parent (like a navigation controller or a tab bar controller.)
            self.topController = viewController.navigationController;
            viewController = viewController.parentViewController;
        }
        [viewController.view addSubview:self];
    }
    return self;
}

// This method gets called when a view adds us as a subview.
// We're pretty much useless until we've been added to a view.
- (void)didMoveToSuperview {
    if (self.superview) {
        self.frame = CGRectMake(self.superview.bounds.origin.x, self.superview.bounds.size.height, self.superview.bounds.size.width, kPickerViewStandardHeight);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectionIndicatorTap:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapGestureRecognizer];

        if (![self.topController.view.subviews containsObject:self.pickerDismisserView]) {
            self.pickerDismisserView = UIView.new;
            self.pickerDismisserView.frame = self.topController.view.bounds;
            self.pickerDismisserView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.pickerDismisserView.backgroundColor = UIColor.blackColor;
            self.pickerDismisserView.alpha = 0.f;
            [self.pickerDismisserView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
            [self.topController.view addSubview:self.pickerDismisserView];
        }
    }
}

- (void)selectionIndicatorTap:(UITapGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer locationInView:self].y > (self.bounds.size.height * kTwoFifths) &&
        [gestureRecognizer locationInView:self].y < (self.bounds.size.height * kThreeFifths)) {
        if ([self.delegate respondsToSelector:@selector(pickerViewSelectionIndicatorWasTapped:)]) {
            [self.delegate pickerViewSelectionIndicatorWasTapped:self];
        }
    }
}

- (void)show {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.frame = CGRectMake(self.superview.bounds.origin.x, self.superview.bounds.size.height - kPickerViewStandardHeight, self.superview.bounds.size.width, kPickerViewStandardHeight);
        self.pickerDismisserView.frame = CGRectMake(self.topController.view.bounds.origin.x, self.topController.view.bounds.origin.y, self.topController.view.bounds.size.width, self.topController.view.bounds.size.height - kPickerViewStandardHeight);
        self.pickerDismisserView.alpha = kDismissViewAlpha;
    }];
    if ([self.delegate respondsToSelector:@selector(pickerViewWasShown:)]) {
        [self.delegate pickerViewWasShown:self];
    }
}

- (void)hide {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.frame = CGRectMake(self.superview.bounds.origin.x, self.superview.bounds.size.height, self.superview.bounds.size.width, kPickerViewStandardHeight);
        self.pickerDismisserView.frame = self.topController.view.bounds;
        self.pickerDismisserView.alpha = 0.f;
    }];
    if ([self.delegate respondsToSelector:@selector(pickerViewWasHidden:)]) {
        [self.delegate pickerViewWasHidden:self];
    }
}

// If we weren't initialized with a View Controller/Navigation Controller,
// we should try to find an approrpiate one. This might be ripe for improvements.
- (UIViewController *)topController {
    if (!_topController) {
        if ([self.superview.nextResponder isKindOfClass:[UIViewController class]]) {
            _topController = (UIViewController *)self.superview.nextResponder;
        }
        if (_topController.navigationController != nil) {
            _topController = _topController.navigationController;
        }
    }
    return _topController;
}

@end
