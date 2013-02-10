/*

Copyright (c) 2013 Jeff Menter

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/


#import <UIKit/UIKit.h>

@class JMPickerView;

@protocol JMPickerViewDataSource <UIPickerViewDataSource>
@end

@protocol JMPickerViewDelegate <UIPickerViewDelegate>
@optional
- (void)pickerViewWasShown:(JMPickerView *)pickerView;
- (void)pickerViewWasHidden:(JMPickerView *)pickerView;
- (void)pickerViewSelectionIndicatorWasTapped:(JMPickerView *)pickerView;
@end

@interface JMPickerView : UIPickerView
@property (nonatomic, weak) id<JMPickerViewDataSource> dataSource;
@property (nonatomic, weak) id<JMPickerViewDelegate> delegate;

- (JMPickerView *)init;
- (JMPickerView *)initAttachingToViewController:(UIViewController *)viewController;
- (JMPickerView *)initWithDelegate:(id<JMPickerViewDelegate>)delegate
         attachingToViewController:(UIViewController *)viewController;
- (JMPickerView *)initWithDataSource:(id<JMPickerViewDataSource>)dataSource
                            delegate:(id<JMPickerViewDelegate>)delegate
           attachingToViewController:(UIViewController *)viewController;
- (void)attachToViewController:(UIViewController*)viewController;
- (void)show;
- (void)hide;

@end

