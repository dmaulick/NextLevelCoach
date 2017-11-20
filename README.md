@Author David Maulick
"ChatChat" - The prototype for my final app "Next Level Coach"

In my previous milestone I identified two major API's that I would be
working with. I said I would need Firebase and Eventkit.

I said I would need EventKit for the calendar functionality. And I said I
would need Firebase for the messanging.

Upon implementation I found this was not exactly correct. In this prototype,
for the calendar I actually did not use eventkit because it would not help me
build a calendar. Instead I used JTAppleCalendar API to help me build my
calendar. In the prototype I have a calendar built, now all I need to do
is link up events to it.

For messanging I did ended up using firebase for the backend. Then using the
msqmessaging API I was able to create an intuitive chat UI that will show
when others are typing in the same group.
If you use my app on the simulator and an iphone at the same time
you can see that the firebase backend works correctly and shows
when others are typing.

With Firebase I have already linked my chat up to an authentication system.
As of now it authenticates anonymously, howevever the final will work with users.

The remainder of the app does not require any more APIs. It will simply be
my own development. As of now the remainder of the app is not that
decorated simply because I know that this part of the app will be the most
straight forward. My goal for this milestone was to get messanging and
calendar prepped for further customization.

No major issues to report on.
