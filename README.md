# RequireJS + Rails + Jasmine

This repository is a tutorial and straw-man design proposal for integrating
Jasmine test support into a Rails app using [RequireJS](http://requirejs.org/)
via the `requirejs-rails` gem.  My ultimate goal is to see all of this wrapped
up so that it's as easy as adding a gem to your app's Gemfile.

## Goals

### it should play nicely with the Asset Pipeline

Rails' Asset Pipeline provides useful conventions, plugins, workflow and tools.
As much as possible, I'd like to preserve that while bringing the benefits of
RequireJS and Jasmine into play.

### it should be [DRY](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself)

A suite of AMD source code in a Rails app makes its dependencies
explicit via `require()` and `define()` calls.  The Jasmine configuration
should not make the developer reiterate this knowledge.

## Other Approaches 

### guard

One approach by [Michael Kessler](https://github.com/netzpirat) uses guard to
[transpile and assemble the test suite from sources and
specs](https://gist.github.com/673967).  This is handy for general Ruby apps
without Sprockets.  For a Rails app, it fails to be DRY and doesn't respect
the configuration and processing built into the Asset Pipeline.

### Jasmine helpers

Scott Burch's [jasmine-require](https://github.com/scottburch/jasmine-require)
helper is another integration approach.  I honestly never did get it
configured and working with `requirejs-rails`, but that's probably a (lack of)
documentation issue.  Setup aside, Scott's `requireStubs()` call is a nice
idea worth keeping in mind.

My personal bias is that I would prefer a "native-AMD" module style rather
than a Jasmine helper.

## Step-by-step guide

This section explains the changes made to enable Jasmine support with
`requirejs-rails` as described in the Introduction.

Based on the above discussion, here are some guidelines this template
adheres to:

- Asset path compatibility: Specs should reference source files using the same
  path structure as the source files themselves use.
- Specs live in `spec/javascripts/spec`.  Like any asset, they can be in any format
  that transpiles to JavaScript, such as CoffeeScript.
- Helpers live in `spec/javascripts/helpers` as usual.  They are not
  currently processed through Sprockets, so CoffeeScript, etc. is not
  supported.

### Update `Gemfile`

Add these lines to your `Gemfile`, then run `bundle install`:

```ruby
gem 'requirejs-rails', '~> 0.8.0'

group :development, :test do
  gem 'jasmine', :git => 'git://github.com/pivotal/jasmine-gem.git'
end
```

### Run the jasmine generator

```rake g jasmine:install```

### Update development asset paths

Add this line to `config/environments/development.rb`:

```ruby
config.assets.paths << Rails.root.join("spec", "javascripts")
```

### Add files from this repository

You'll need to add these files, in these relative locations, to your Rails
app:

```
spec/javascripts/support/jasmine_config.rb
spec/javascripts/support/run.html.erb
spec/javascripts/support/jasmine.yml
```

### Add specs

Create your specs in `spec/javascripts/spec`.  Check out the example spec file
in that directory.  To run it, start the jasmine server via the usual `rake
jasmine` and navigate to `http://localhost:8888/`.

A spec in CoffeeScript would look like this:

```coffeescript
define (require) ->
  PlaylistModel = require('models/playlist_model')

  describe 'existence', ->
    it 'should be defined', ->
      expect(PlaylistModel).toBeDefined()
```
