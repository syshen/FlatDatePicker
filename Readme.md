# What is FlatDatePicker

Before iOS7 beta was announced, I developed this flat date picker for one of my apps. Althought it is not a real flat design, it still includes gradient to give the illusion of scrolling. But you look at iOS7 date picker design, it is the same concept. iOS7 date picker didn't abandon the grandient, it still provides some sort of reflection of reality. So, before iOS7 was officially released, you may want to try this control, and I think it is a good match with FlatUIKit. 

# What's in FlatDatePicker

* Comply with Interface Builder
* Easy to customize the font and color throught UIAppearance
* Can be placed as a subview in any view
* Comply with UIControl protocol
* Flat and elegant

# How to install

1. Drag & drop the SSFlatDatePicker into your project
2. Link with Quartz Core framework
3. You can either use [[SSFlatDatePicker alloc] initWithFrame:frame] to add SSFlatDatePicker as a subview of your UI
4. Or, you can drag a UIView retangle, and customize its class as SSFlatDatePicker, and link to the IBOutlet in your source code. 
5. You can hook the value change throught monitoring the UIControlEventValueChanged event. 

