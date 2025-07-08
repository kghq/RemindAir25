#  README

## Breathing App
WE'll see how far can I go.


## TODO

1.1. Complete EditView and AddView with prep time
1.2. Add validation: Name must be entered, breathe in and out at least 1 second. And whole breath at least 3 sec
1.3. Synergy betwenn these three views, and especially between Add and Edit. Make them look reasonably similar.
2.1. Polish the DetailView with all the right data: Description (called notes, maybe?) optional, layout the exercise pattern with number of braeths, time of breath and total time.
2.2. Polish the Detail, Add, and Edit views: right formatting, with time etc, using the computed properties. Doesn't have to be pretty, just functional and readable.
2.3. Nicer buttons with background and bolder font
4. Add timer mockup (Just Total Duration in a big font will suffice, with maybe a button that gets the user back to the detail view.)
3. Data persistence (file manager)

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
Stats in the Detail View?

## Layout

My basic idea for the layout for now
Tab 1: Exercises: add exercise (AddView for exercises only), list of exercises, etc.
Tab 2: Meditation: a single screen with a timer and settings. Fires off with a button, maybe doesn't need any child view at all. Maybe some settings like reminders, animations, coundown or not, health log, sounds, could go into a sheet, or something
tab 3: WHM. Maybe WHM is so specific that it's better for it to have its separate tab.

## Future
With tiles layout, long press to edit, start, and delete. A dedicated button "Play" to move to the TimerView. All the rest of the tile moves to DetailView.
