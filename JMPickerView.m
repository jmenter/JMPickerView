
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
        [viewController.view addSubview:self];
    }
    return self;
}

// This method gets called after we have been added to a view.
// We're pretty much useless until we've been added to a view.
- (void)didMoveToSuperview {
    self.frame = CGRectMake(self.superview.bounds.origin.x, self.superview.bounds.size.height, self.superview.bounds.size.width, kPickerViewStandardHeight);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectionIndicatorTap:)]];

    self.pickerDismisserView = UIView.new;
    self.pickerDismisserView.frame = self.topController.view.bounds;
    self.pickerDismisserView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pickerDismisserView.backgroundColor = UIColor.blackColor;
    self.pickerDismisserView.alpha = 0.f;
    [self.pickerDismisserView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    [self.topController.view addSubview:self.pickerDismisserView];
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
