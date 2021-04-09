Our project, Monster Browser, is an incremental game that involves
raising, feeding, and training monsters. These monsters will gather
food for you--this food can then be used to feed the monsters, making
them better at gathering food, or used to purchase new monsters, who
you can train, raise, and feed, increasing your overall strength. The
members of our team are Fedor "Ted" Kiriakidi, Andrew "Duffman"
Duffy, Will "Suspension" Bridges, and Nicolas "There's no 'H' in my
name" Karayakaylar. Our app is deployed on
http://monster-browser.tkwaffle.site, and the github url is
github.com/nicolassims/FinalProject. Our app is deployed and working
exactly as intended. That's our story, and we're sticking to it.
While working on the project, Ted took the lead role, doing massive
amounts of work as a "producer," of sorts, ensuring we met up in a
timely fashion, and also almost soloing all aspects of the project
that involved twitter integration and authorization. His leadership
and competency was also indispensable when it came to fixing some
bugs or poor design choices other members of the team didn't catch,
being the team member with the best birds-eye view of the project.
Nicolas came up with the idea for the app as well as many features,
was responsible largely for creating the written parts of the
assignment, such as this essay, and the previous one, and also
created much of the user interface for monster/user creation, as well
as the functions that implement that UI. Will implemented the PATCH
methods that allowed for the updating of monsters/users and improved
the registration process to prevent duplicate users. He also secured
our Twitter development account and pitched the idea of using
asynchronous server processes, which became the core idea of one of
our experiments as well as a key component of our website. Andy
served as a “Co-pilot” for various app functions, assisting Ted in
food incrementation and worked to design the “monster shop”
component.

As mentioned before, our Project 2 app is a GAME--so we'd hope it
entertains. On a more psychological level, though, it's an
incremental game, so it's essentially a hack directly into the part
of the mind that makes people happy when numbers go up. We would also
hope that the variety of monsters and nicknames--as well as the
random nature of their selections--would create randomly-generated,
dynamically-evolving narratives. What will your farm look like if the
first five monsters you get are all dragons named "Jerry?" Well, it's
possible. 

Our app's concept has not actually changed much since the proposal.
We managed to avoid having to scope down our app, as many projects
eventually have to, by making any difficult features stretch goals
that we didn't actually include in our proposal. We didn't end up
including those particular stretch goals, but we did end up including
a few features we didn't plan for, such as a user leaderboard, the
ability to rename monsters, and an inversely exponential food-gain
curve utilizing square roots. 

Users interact with the application by creating an account, buying
their first monster for 0 food, and then sending it off to either the
wild or the farm. Again, the sense of "accomplishment" that a user
can achieve through this game is entirely fake--we're appealing
directly to one's sense of satisfaction gained from seeing numbers go
up. And, as satisfying as that is, it's also explicitly purposeless.
But, you know, it is a game. So purposelessness is pretty much the
purpose of the thing.

If we were to run through every requirement of the project, and
describe how we fulfilled them, it'd look something like this:
Obviously, this app is more complicated and ambitious than anything
we've done in this class before. Though a somewhat subjective
measurement, the fact of the matter is this assignment has a lot more
lines of code, and files, than any other. The app is split into two
parts, containing an elixir server and a react-based ui. We've
deployed the app to Ted Kiriakidi's VPS. User accounts are
authenticated with passwords, the encrypted versions of which are
kept securely in our database. Users, and Monsters are stored in a
postgres database that the app references. The application uses the
twitter API, requiring the app to be authenticated, so that users can
post to twitter from the app, and the app can check the number of
likes on a tweet. Of course, the application uses phoenix channels to
push realtime updates to users, and it does this every second, since
the core conceit of our game is that it plays itself even if nobody
is logged in. And that, incidentally, is the cool thing that our app
does--state is kept persistently, and updated constantly, even if
there's not a single browser window/command terminal pointed towards
the app. So every time you come back to the game, you should be in a
much better position than you were before. As for testing... well,
we're fairly certain it's tested to completion. I suppose you've got
to try and break it, to see if that's true!

The most complex part of the app--and the most significant challenge
we faced--is almost certainly the Twitter authentication, which, as
mentioned before, Ted essentially soloed. (Although we did practice
pair programming! Sometimes even triad programming, and a couple
times quad programming.) Ted achieved this through storing the
obtained user tokens in the database and only setting the ExTwitter
config to use these tokens in the process that calls the Twitter API
on their behalf, immediately before the action. Issues faced before
the final result  included not having the authorization available as
well as having the users authorization remain for the wrong API
calls.
