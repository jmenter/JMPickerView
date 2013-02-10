/*

Copyright (c) 2013 Jeff Menter

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

#import "JMPickerView.h"

@implementation UIViewController (ClassQuery)
- (BOOL)isTableViewController { return [self isKindOfClass:UITableViewController.class]; }
- (BOOL)isTabBarController { return [self isKindOfClass:UITabBarController.class]; }
@end

@interface JMPickerView ()
@property (nonatomic) UIView *dismisserView;
@property (nonatomic, weak) UIViewController *dismisserViewController;
@end

@implementation JMPickerView

static CGFloat kPickerViewStandardHeight = 216.f;
static CGFloat kDismissViewAlpha = 0.66f;
static CGFloat kAnimationDuration = 0.25f;
static CGFloat kTwoFifths = 0.4f;
static CGFloat kThreeFifths = 0.6;

- (JMPickerView *)init {
    return [self initAttachingToViewController:nil];
}

- (JMPickerView *)initAttachingToViewController:(UIViewController *)viewController {
    return [self initWithDelegate:nil attachingToViewController:viewController];
}

- (JMPickerView *)initWithDelegate:(id<JMPickerViewDelegate>)delegate
         attachingToViewController:(UIViewController *)viewController {
    return [self initWithDataSource:nil delegate:delegate attachingToViewController:viewController];
}

- (JMPickerView *)initWithDataSource:(id<JMPickerViewDataSource>)dataSource
                            delegate:(id<JMPickerViewDelegate>)delegate
           attachingToViewController:(UIViewController *)viewController {
    if (viewController.isTableViewController && viewController.parentViewController == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Adding to standalone UITableViewControllers that don't have parent view controllers is not supported because there is nowhere upon which to attach our views."];
    }
    
    if (self = [super init]) {
        self.showsSelectionIndicator = YES;
        self.delegate = delegate;
        self.dataSource = dataSource;
        if (viewController) {
            [self attachToViewController:viewController];
        }
    }
    return self;
}

- (void)attachToViewController:(UIViewController*)viewController {
    self.dismisserViewController = viewController;
    if (viewController.navigationController) {
        self.dismisserViewController = viewController.navigationController;
    }
    if (viewController.isTableViewController && viewController.parentViewController.isTabBarController) {
        self.dismisserViewController = viewController.parentViewController;
    }
    if (viewController.isTableViewController) {
        viewController = viewController.parentViewController;
    }
    [viewController.view addSubview:self];
}

- (void)didMoveToSuperview {
    if (self.superview) {
        self.frame = CGRectMake(self.superview.bounds.origin.x, self.superview.bounds.size.height, self.superview.bounds.size.width, kPickerViewStandardHeight);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectionIndicatorTap:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapGestureRecognizer];

        if (![self.dismisserViewController.view.subviews containsObject:self.dismisserView]) {
            self.dismisserView = UIView.new;
            self.dismisserView.frame = self.dismisserViewController.view.bounds;
            self.dismisserView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.dismisserView.backgroundColor = UIColor.blackColor;
            self.dismisserView.alpha = 0.f;
            [self.dismisserView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
            [self.dismisserViewController.view addSubview:self.dismisserView];
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
        self.dismisserView.frame = CGRectMake(self.dismisserViewController.view.bounds.origin.x, self.dismisserViewController.view.bounds.origin.y, self.dismisserViewController.view.bounds.size.width, self.dismisserViewController.view.bounds.size.height - kPickerViewStandardHeight);
        self.dismisserView.alpha = kDismissViewAlpha;
    }];
    if ([self.delegate respondsToSelector:@selector(pickerViewWasShown:)]) {
        [self.delegate pickerViewWasShown:self];
    }
}

- (void)hide {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.frame = CGRectMake(self.superview.bounds.origin.x, self.superview.bounds.size.height, self.superview.bounds.size.width, kPickerViewStandardHeight);
        self.dismisserView.frame = self.dismisserViewController.view.bounds;
        self.dismisserView.alpha = 0.f;
    }];
    if ([self.delegate respondsToSelector:@selector(pickerViewWasHidden:)]) {
        [self.delegate pickerViewWasHidden:self];
    }
}

@end
