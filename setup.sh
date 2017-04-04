#!/bin/bash -f
gem install bundler jekyll --user-install
npm install grunt-cli vulcanize bower compass
npm install grunt --save-dev
bundle install
npm install
bower install
grunt docs

