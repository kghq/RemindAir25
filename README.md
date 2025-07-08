#  README

## Breathing App
WE'll see how far can I go.


## TODO

swipe to delete, long press to edit and start
Complete EditView
Add timer mockup
data persistence (file manager)
format the times and dates

A shitload of private vars are creeping in add and edit views. Think where they could go.
Data persistence with FileManager

Timer itself (when rough Exercise structure is ready)

Later: add an extension with the NavigationPath

## Ideas
Meditation timer settings to userdefaults. Length, sound, or no sound, or any countdown at all (if not, only measure time elapsed, and log to health after done.)
Tabs: Exercises, Meditation, Stats, Knowledge
In AddView and EditView: Some sort of summary, like 20 breaths, 17 sec each = 4 minutes 6 seconds?
More importantly, two sliders: one for number of breaths, second for total duration: they can influence each other, and user can both decide on nuber of breaths and time duration
Reminder to meditate?

## Layout

My basic idea for the layout for now
Tab 1: Exercises: add exercise (AddView for exercises only), list of exercises, etc.
Tab 2: Meditation: a single screen with a timer and settings. Fires off with a button, maybe doesn't need any child view at all. Maybe some settings like reminders, animations, coundown or not, health log, sounds, could go into a sheet, or something
tab 3: WHM. Maybe WHM is so specific that it's better for it to have its separate tab.
