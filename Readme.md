# What is FlatDatePicker

Before iOS7 beta was announced, I developed this flat date picker for Xing app, which we applied for Evernote DevCup contest (You can vote us from this url: https://www.hackerleague.org/hackathons/evernote-devcup-2013/hacks/xing ). Althought it is not a real flat design, it includes gradient to provide the depth and illusion of scrolling. But if you look at iOS7 new date picker design, it is the same concept, it still provides some sort of reflection to reality. So, before iOS7 was officially released, you may want to try this control, and I think it is a good match to FlatUIKit. 

<img src="http://f.cl.ly/items/3B2Y3N2v2Z0l1D3U2O2l/date.png" width="400"/>
<img src="http://f.cl.ly/items/0b1s0K3n3f210P110d2L/time.png" width="400"/>

And also watch the sample app video here: http://youtu.be/ROgQzdq8CXg

# What's in FlatDatePicker

* Comply with Interface Builder
* Easy to customize the font and colors throught UIAppearance
* Can be placed as a subview in any view
* Comply with UIControl protocol
* Flat and elegant

# How to install

## Manual
1. Drag & drop the SSFlatDatePicker into your project
2. Link with Quartz Core framework
3. You can either use [[SSFlatDatePicker alloc] initWithFrame:] to add SSFlatDatePicker as a subview of your UI
4. Or, you can drag a UIView retangle in Interface Builder, set its custom class as SSFlatDatePicker, and link to the IBOutlet in your source code. 
5. You can hook the changed value throught monitoring the UIControlEventValueChanged event. 

## Cocoapods
SSFlatDatePicker is in cocoapods now, you can find it and install it throught pods command. 

