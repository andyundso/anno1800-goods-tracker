# README

An application to track the flow of goods in Anno 1800. Originally also my personal playground to test Turbo, Stimulus and Tailwind.

## Idea

If you're not familiar with Anno 1800, [RepublicOfGamer](https://www.youtube.com/watch?v=b1xdE_6C_JU) has a great tutorial, which shows you the basic nuances.

I often play this game with friends, and we expand our empire together. However, the already complex linking of resources gets even more complicated when you are four people playing in the same faction. Why did he place an additional fabric there? Where do we ship coal to the Arctic? We often found ourselves questioning what we did, especially when we didn't play for even a few days.

The good tracker allows you to track those things: You can enter which goods are produced on which island based on what other goods (including from different islands). Let's make an easy example:

* You want to produce Rum, which is composed out of sugar and wood for the barrels for Crown Falls in the old world.
* You have an island in the new world, Bahamas, which has enough population to produce rum, but no sugar fertility.
* But luckily, a second island, Aruba, in the new world has the sugar fertility.

To enter this in the good tracker, apply the following steps:

* Register the three different island.
* Register that Aruba produces 4 sugar a minute.
* Register that Bahamas produces 4 woods a minute.
* Register that Bahamas produces 4 rum a minute, based on the sugar from Aruba and the wood from itself.
* Register that Bahamas consumes 1 rum a minute from itself.
* Register that Crown Falls consumes 3 rum a minute from the Bahamas.

Now, if you're later wondering where that rum is coming from, simply click on the Crown Falls island overview, click on the Rum symbol, and you see that it's imported from the Bahamas. Or the other direction: Click on the rum symbol on the Bahamas island overview, and you see that is consumed on itself and in Crown Falls.

The data you enter will be saved on the server's site. When you click "Create game" on the login screen, note down the number that'll be printed. It'll later allow you to open you progress.

Ah, and since I want to use this with my friends, all changes you enter are synced (almost) immediately to your friends when you or they enter changes (when you open the same game id of course).

### What the tool doesn't do

It doesn't run directly in your game. First of all, this would break multiplayer when you play with a modded game. Second, I don't know how to mod.

The tool doesn't know anything about fabrics and how much they put out. This is mainly due to the immense varieties of items and boosts you can gain within the game. Some items even replace the input goods for certain fabrics. So the goods tracker keeps things rather simple.

### Setup

* Make sure you have Redis and Postgres running.
* Configure your database.yml.
* Install Ruby 3.3.6.
* Install the latest bundler `gem install bundler --no-document`.
* Install the bundle `bundle install`
