# Additional README for ECEn-320
The `README.md` file was inherited from the original https://github.com/byu-cpe/ClassWebPages project.
It contains info on customizing that project to a specific class's web page.

This `README_ECEn320.md` is additional info for **this** version of the web pages.

## Installing Docker
[These instructions](https://runnable.com/docker/install-docker-on-macos) were helpful to install docker on a Mac.

## Troubleshooting
* Sometimes odd errors were thrown when running `make develop` such as:
```
$ make develop
docker run --rm --volume="$PWD:/srv/jekyll" -p 4000:4000 -p 35729:35729 -it jekyll/jekyll:4.0 bundle exec jekyll serve --livereload --host=0.0.0.0
Could not find ffi-1.12.2 in any of the sources
Run `bundle install` to install missing gems.
make: *** [develop] Error 7
```
In the end, removing Gemfile.lock solved the problem.  Must have been left over from a previous run.

* Other times running `make develop` would result in a complaint that port 35729 was already in use.  This is presumably similar in that something was left over from a previous run.  No solution other than rebooting has been found for this to date.

## Change of _site Location
I kept mistakenly editing the files in the `_site` directory since it was out in the middle of my file listing.  

So, I changed its location to `_0site` to get it out of the way.  It almost never causes problems but every once in a while something will be expecting `_site` instead.  Locations that had to change to accommodate this includes:
* `config.yml`
* `Makefile`
* `.gitignore`

## Link Checking
There is a link checking capability that helps find broken links.
Instructions are in the `LINKCHECK.md` file.  Once installed, it can be run automatically.  

It could even be put into a Travis-CI check (haven't done that yet).

## Videos on Youtube
The decision was made to never put videos into this repo.
Rather they are all at Youtube.

There is an account at Youtube with this login info:
* byuecen220
    * XC7A35T-1CPG236C

The videos all go into that channel.
We then use the "Embed" link info in our webpage.  

NOTE: if you put "?rel=0" at the end of a video link then when the video is done playing it will NOT put up a screen of suggested follow-on videos to watch (which is good since the suggested videos may not be appropriate).

## Changing "Suggest Edits" Link
    We set it so the button, by default will send an email to ecen220feedback@byu.net, which should be an alias for whatever faculty member wants to receive emails with feedback on specific pages.  This can be added as an alias by going to alias.byu.edu and adding it to your account (you will have to get the previous faculty to relinquish it first, however).  This is different than what was there in the original website...

## Scrolling Sidebar
Made changes to the _sass/simple-sidebar.scss file to make the sidebar independently scrollable.  Entry now looks like:
```
.sidebar-sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0;

  /* Next 5 entries are new - made to make sidebar have own scrollbar */
  height: calc(100vh); 
  padding-top: 0.5rem; 
  overflow-x: hidden; 
  overflow-y: auto; 
  padding-bottom: 50px;
}
```
## "Make Suggestion" Icon in Upper Right of Screen
Changed icon from github icon to mail icon.

## Calendar and Zoom Meetings
Added data to zoom.yaml and schedule.yaml and then script code to 02_ta_schedule.md to draw the Snoopy icon for when people have scheduled zoom office hours.
