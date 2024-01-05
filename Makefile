develop:
	docker run --rm --volume="$$PWD:/srv/jekyll" -p 4000:4000 -p 35729:35729 -it jekyll/jekyll:4.0 jekyll serve --livereload
	
dbuild:
	docker run --rm --volume="$$PWD:/srv/jekyll" -it jekyll/jekyll:4.0 jekyll build

check_links: build
	bundle exec htmlproofer --alt_ignore="*" --empty_alt_ignore --url-ignore "/diglabqueue.groups.et.byu.net/,/ecen220wiki.groups.et.byu.net/" --allow-hash-href ./_0site

serve:
	bundle exec jekyll serve

build:
	bundle exec jekyll build

dist: 
	bundle exec jekyll build
# Copy files to server.  Need to change the username and change directory back to the project direrctory
	cd _0site; scp -r * djlee@ssh.et.byu.edu:groups/ecen220wiki/www; cd ..

checks:
	make build
	make checklinks

# http://localhost:4000
