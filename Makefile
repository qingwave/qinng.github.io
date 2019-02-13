server:
	sleep 5 && x-www-browser "http://localhost:4000" &
	hexo s

init:
	git submodule update --init --recursive
	sudo npm install

clean:
	hexo clean

deploy: clean
	hexo deploy -g

push: deploy
	git add .
	git commit -m "add new file"
	git push