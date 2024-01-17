### Jukebox
#### Bard Management for Macroquest2 Written in LUA
---
### What is this?
Managing the bard can be difficult, even for experienced players. This LUA aims at helping you manage your bard.

## Features
### Copilot: 
* Will help you manage *Boastful Bellow*, *Vainglorious Shout*, *Selo's Sonata* and your other AA abilities.
  * *Boastful Bellow* and *Vainglorious Shout* will recast only once *Boastful Conclusion* has been consumed on your target.
  * *Selo's Sonata* will recast once its not found on your character, but will not recast if you are invis or sitting.
  * The other AA abilities such as *Quick Time* and *Fierce Eye* will cast based on certain conditions that you can set with simple mouseclicks.
 
Copilot is meant to help you manage these tedious actions, so you seem like the God-Bard that you actually are.

### Auto Combat:
* Assist Main Target or Main Tank based on *Assist Range*, at a *specific mob health*, and *Scattering*.
  * *Assist Range*: The radius in Everquest-units to assist the Main Assist or Main Tank.
  * *Assist Range Scattering*: A variable assist range, so your character doesn't seem overly mechanistic.
  * *Assist Percent HP*: The HP of the target before you begin assisting.
  * *Assist Percent Scattering*: Just like Range Scattering, this will vary the health at which you assist the Main Assist or Main Tank.

* *Camps*: Set a camp location to return to when combat is done.
  * *Camp Location Scattering*: Sets a semi-randomized camp location near your desired camp spot.
 
* *Why Scattering?*
  * So your actions don't seem overly automated. You'll attack at different times and sit in different locations to make your actions seem a little more organic.

* *Automatically Back Off*
 * Automatically back out of combat if your HP falls below a threshold you can set.
 
### Songs Management
* A work in progress. The current implementation has "Resting Songs" and "Combat Songs". When you are not in combat you'll play "Resting Songs". When you engage in combat, you play "Combat Songs". *(Duh)*
* A fully unique song scheduler.
* Future Implementation will hopefully allow for more advanced conditions per Song-Gem, such as: "Any", "Standby", "Resting", "Combat", "Mob Health", "My Health".
* Start Songs with `/songsstart`
* Stop Songs with `/songsstop`

### History Log
* Want to see what this LUA is up to? Check out the history tab to see timestamped information of every action this LUA takes.

### Future Plans
* Mez management. Choose the conditions for when you want to mez, and let the LUA take care of things for you.
* Pulls management. Pulls mobs for you. If you truly want to AFK your bard, then this might be helpful.
