
#import <UIKit/UIKit.h>

@class JMPickerView;

@protocol JMPickerViewDelegate <UIPickerViewDelegate>

@optional
- (void)pickerViewWasShown:(JMPickerView *)pickerView;
- (void)pickerViewWasHidden:(JMPickerView *)pickerView;
- (void)pickerViewSelectionIndicatorWasTapped:(JMPickerView *)pickerView;
@end

@interface JMPickerView : UIPickerView
@property (nonatomic, weak) id<JMPickerViewDelegate> delegate;

- (JMPickerView *)initWithDelegate:(id<JMPickerViewDelegate>)delegate addingToViewController:(UIViewController *)viewController;
- (void)show;
- (void)hide;

@end

