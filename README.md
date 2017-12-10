@Author David Maulick
"ChatChat" - Final app: "Next Level Coach"

Accounts to use in testing:
Username: davidtester899@gmail.com
Password: tester123

Username:  davidtester899@gmail.com
Password:  tester1234

At the bottom of this readme is what was submitted for milestone two in the readme.

In this version of Next Level Coach there were a number of major implementations, this included:

Firebase:
    - Authentication that used google authentication so that the app would have a customized experience for each userapp
    - Database- most app data that is seen in terms of the teams, groups, events and users are stored in the firebase databaseand
    - Storage - used storage to store pictures that are associated with the seperate users and teams.
    
JTAppleCalendar
     - My own customized calendar using the JTapple calendar pods
     
Chat
    - Live chat that allows you to see bubbles when another person is typing in the same group chatallows
    - It also is able to send pictures over chat
    
Camera
      - In create team, you can access the camera and photo library to add your own photo to be used for your teams image
      
Biggest issue with the app
    - The way I chose to store my data was not efficient. I used a user to team, team to group branch in my data base to match users with the correct groups. This results in somewhat slow updates in use of the app.
    - If I were to do it again I would try to keep data local more often and use the local data to build the UI instead of constantly checking firebase. This also would have been the easier way to do it too.
    - Because it is constantly trying to load the UI with data from firebase, sometimes the app will crash if you go too fast from team to team. Because it must reload everything.
    
    
Overalll I am pleased with the app because it is a pretty large app with a complex backend. If I had known better how to design this backend frontend interaction from the start I feel the UX would be much better.

Here is an overview of the app so that it is more obvious what each part is.

After logging in you are brought to a homescreen. At this home screen you can not do anything really until you have selected a team on the menu on the left side. You can see this menu by either panning right or pressing the teams button on the left side of the navigation bar.

If you go to the profile part of the app(by pressing the top image button in the homescreen). You will see the photo from your gmail account as a profile picture along with some of the info you created the account with on the right of the picture. Then if you press manage teams on the upper right of this profile page you can create, find and edit teams.
The create team has preset images that you can toggle by pressing on it. This was done for presentation purposes so that I could demonstrate easily. You can also upload a photo or use your camera to upload a photo here.
If you want to find a team you did not create, you can go to the find team segment in manage teams and find it by using the correct team name and passcode.
The edit team segment has no functionality.

Which events you can see in the app is governed by the groupchats that you are associated with. The groups in your team that you are associated with can be found in the chat section of the app. You can quickly create new chats on this tableview page. If you want to see other chat groups that are on your team but you may not be a part of. Press the "existing groups" button on the top right to see a pickerview with all groups in the team.

All events associated with the groups you are a part of will show up at the correct date on the calendar. They will also show up in a list format on your newsfeed. Both the calendar and newsfeed have button icons on the home page. One thing I wish I had done in the newsfeed table was put in order by time and made it look a little bit nicer. However I ran out of time. And if you would like to add an event you can do so by going to the newsfeed section of the app, pressing the add button, selecting the group you would like to add an event to and then pressing save.
Note there is one data bug with the picker when you try add a new event from the newsfeed. For some reason it shows duplicates of groups after adding a new event- BUT if you go back to the home screen it will fix it self and again show only the correct groups in the picker view.
Note that when you click on an event in either the calendar or newsfeed the detail view of the event is simply to show that the data from firebase is readily available to use- I did not choose to design nice detail views for the events.

Finally you can sign out from a currrent user by pressing sign out on the bottom.




README from Milestone #2:

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
