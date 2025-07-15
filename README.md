#  README

## Breathing App
WE'll see how far can I go.


## TODO
Include breath count: how many left, how many to go.
Hide all but 3 upcoming timers
Breath phases labels
Done
When this is done, smooth the transitions and add some ending.
Ending will probably be some kind of summary: time spent, number of breaths, or something.
Done button: if started, end and save session, if not, go to the previous screen
SessionStage enum

### Timer

The Timer shows:
Preparation time (then disappears)
Total time
Cycles left
Name of exercise, maybe?
Collumn of timers (maybe disappear one by one as the last cycle closes, so in the end no timer is shown?)
Label for the current and next breath phase (and Prepare, and End, like Starting in... and Done)
Summary in the future.

Animation: Enlarge the current one, the previous one fades up. Basically It's a queue that goes up. User should see 3 upcoming phases.
The phases should be labeled
Animation: Enlarging circle (inhale), change color (progressively as hold), shrinking circle, change color
Animation: something indicating preparation.

Chime when done. Disappear the clock when done, some nicer screen in the end. Animations.

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
Live activities, dynamic island
Larger screen support
Shortcuts
Hide navigation while timer is running.
Integration with Spotlight, Siri, and Shortcuts

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
I want to show inhale, exhale, hold full and hold empty time intervals
I want to show how much will one breath take in total
I want to show 1 breath x number of breaths
I want to show total duration
And i want to show the prep time as optional

## Smaller changes
1. Make Duration editable, and that would set the number of breaths. Or maybe not? We'll see with the NumPad. After all, duration is more important with Meditation. But being able to set the duration of Exercise also makes sense.
2. Sort by name, date created, date used (is it necessary now?)
3. Description in TextEditor
4. Refactor TimerView (extract buttons to separate views, etc)
5. Rename AddView to ExerciseAddView etc
.listrowbackground
Dividers between list rows
