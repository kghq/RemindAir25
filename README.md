#  README

## Breathing App
WE'll see how far can I go.


## TODO

1. Data persistence (file manager)
1.1. Make the funcions generic
2. Refactor, especially the Edit and Add
3. Timer mockup should have two buttons: start timer to set date last used and stop, to move to the previous view
3.1 This will allow to sort by date last used and date created and check if edit doesn't reset the date created.
4. formatAsWords as a computed property in BreathExercise

A shitload of private vars are creeping in add and edit views. Think where they could go.
Data persistence with FileManager

Timer itself (when rough Exercise structure is ready)

Later: add an extension with the NavigationPath

## Ideas
Validation in Add and Edit: Name must be entered, breathe in and out at least 1 second. And whole breath at least 3 sec
Nicer buttons with background and bolder font. Needed, really? Stock looks qute good, and is in line with iOS.
Meditation timer settings to userdefaults. Length, sound, or no sound, or any countdown at all (if not, only measure time elapsed, and log to health after done.)
Tabs: Exercises, Meditation, Stats, Knowledge
In AddView and EditView: Some sort of summary, like 20 breaths, 17 sec each = 4 minutes 6 seconds?
More importantly, two sliders: one for number of breaths, second for total duration: they can influence each other, and user can both decide on nuber of breaths and time duration
Reminder to meditate?
Stats in the Detail View?
Deal with the timer when app is quit (Stage)
Path in AppStorage, maybe?
Time duration pickers not as sliders, but just text field with a keyboard (no constraints to length, etc).
Also, if I wanted to make the AddView And Editview in other way, the user would just enter the values.
Accessibility
Make favorites

## Layout

My basic idea for the layout for now
Tab 1: Exercises: add exercise (AddView for exercises only), list of exercises, etc.
Tab 2: Meditation: a single screen with a timer and settings. Fires off with a button, maybe doesn't need any child view at all. Maybe some settings like reminders, animations, coundown or not, health log, sounds, could go into a sheet, or something
tab 3: WHM. Maybe WHM is so specific that it's better for it to have its separate tab.

## Future
With tiles layout, long press to edit, start, and delete. A dedicated button "Play" to move to the TimerView. All the rest of the tile moves to DetailView.
