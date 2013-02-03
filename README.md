JMPickerView
============

A better UIPickerVIew.

Ah, the venerable UIPickerView for iOS. So neat yet so ungainly. Let's make it better!

JMPickerView improves UIPickerView by adding presentation and interaction functionality. It's simple to use. Let's take a look!

1.) Add JMPickerView.h and JMPickerView.m to your project (make sure it's added to your target.)

2.) You'll be adding this to a view controller.

In the .h, make your view controller conform to the <JMPickerView> protocol.

In the .m, make it a property... 
@property (nonatomic) JMPickerView *pickerView;

...and instantiate it in viewDidLoad or somesuch. Just one line is all you need:

self.pickerView = [[JMPickerView alloc] initWithDelegate:self addingToViewController:self];

BOOM! You're done. Well, almost. Now you have to make it useful. To hide and show the pickerView, use:

[self.pickerView show];

...and...

[self.pickerView hide];

To know when the picker view does stuff, implement these delegate methods:

- (void)pickerViewWasHidden:(JMPickerView *)pickerView;
- (void)pickerViewWasShown:(JMPickerView *)pickerView;
- (void)pickerViewSelectionIndicatorWasTapped:(JMPickerView *)pickerView;

They are self explanitory, are they not?
