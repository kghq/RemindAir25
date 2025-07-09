#  README

## Breathing App
WE'll see how far can I go.


## TODO

2. Change the sliders for NumPad.
3. Nicer Buttons in Edit, Add, Timer, etc.
4. Polish the Detail (especially). It has to look good, be functional and usable before moving on.

Next Big thing
Timer itself

6. Make Duration editable, and that would set the number of breaths. Or maybe not? We'll see with the NumPad. After all, duration is more important with Meditation. But being able to set the duration of Exercise also makes sense.
7. Sort by name, date created, date used (is it necessary now?)
8. Description in TextEditor

then, xctest

Later: add an extension with the NavigationPath

## Ideas
Meditation timer settings to userdefaults. Length, sound, or no sound, or any countdown at all (if not, only measure time elapsed, and log to health after done.)
Tabs: Exercises, Meditation, Stats, Knowledge
Reminder to meditate?
Stats in the Detail View?
Deal with the timer when app is quit (Stage)
Path in AppStorage, maybe?
Accessibility
Make favorites
Session done: summary on the same screen. Maybe user can go to details directly from there?
Haptics: during the exercise (as a guide), as well as in the UI
Watch Support
SwiftData and iCloud
Choosing color and icon

## Layout

My basic idea for the layout for now
Tab 1: Exercises: add exercise (AddView for exercises only), list of exercises, etc.
Tab 2: Meditation: a single screen with a timer and settings. Fires off with a button, maybe doesn't need any child view at all. Maybe some settings like reminders, animations, coundown or not, health log, sounds, could go into a sheet, or something
tab 3: WHM. Maybe WHM is so specific that it's better for it to have its separate tab.

## Future
With tiles layout, long press to edit, start, and delete. A dedicated button "Play" to move to the TimerView. All the rest of the tile moves to DetailView.

## Concerns about the input in Add and Edit
align to the right
indicate that it's seconds, maybe somehow convert to minutes
numpad
check against pasting some text
additional validation?

## Breath summary layout


