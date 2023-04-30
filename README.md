# README

This is a test project for [MRSK](mrsk.dev).

I'll leave it up until I have better ones, then point it to those.

I'm just learning, hopefully this will help you learn MRSK too.

My favorite technique to learn something is to create a minimal testbed.

## rails-mrsk-sqlite

This project was purpose-built to test the mrsk deployment process.

### Rails New

```bash
rails new rails-mersk-sqlite --css=tailwind --database=sqlite
```

### Add Dockerfile

We will use the new(ish) [dockerfile-rails](https://github.com/rubys/dockerfile-rails).

This should eventually be baked into rails itself (v7.1-ish timeframe) so it makes sense to use it here when you need a semi-intelligent Dockerfile generator.

Add to your project:

```bash
bin/bundle add dockerfile-rails --optimistic --group development
```

Then have it spin out a project-specific (this is the cool part) Dockerfile:

```bash
bin/rails generate dockerfile —compose
```

I like having it generate a full `docker-compose.yml` stack. It doesn't matter much in this case with sqlite, but in a more comprehensive project with postrgres and redis or such; it'll save some time.

It should auto-detect what you're using, but there are some command line flags you can tweak if it doesn't on the project page.

I'd test build that, if you have Docker installed on your workstation (if you don't, you probably should).

### Add MRSK

```bash
gem install mrsk
```

Init:

```bash
mrsk init --bundle
```

I like installing it into my project Gemfile (the --bundle flag above should do so).

You'll need to tweak your build, as I've done here to gather all appropriate parameters into an `.env` file (which should have been created).

I also stage this part out a bit and override the default healthcheck (future versions of rails will come default with an `/up` healthcheck).

Commit Hash: [ab3fe93](https://github.com/knightoftheoldcode/rails-mrsk-sqlite/commit/ab3fe9323e6ad1284101e70c1cb0980cda69412c)

Simple Healthcheck: [ab3fe93:config/deploy.yml](https://github.com/knightoftheoldcode/rails-mrsk-sqlite/commit/ab3fe9323e6ad1284101e70c1cb0980cda69412c#diff-fa61612ba96bd682e6fcf1734a4558f3569972a070a4fe902b85972a485b6a36)

### Add Healthcheck

By default, a valid deploy target will use Traefik to blue/green a deploy. It will only succeed in moving from the previous docker container to the new one if the healthcheck passes.

Above, I'd set it to something like `/` with a very simple root route:

[Hello World](https://github.com/knightoftheoldcode/rails-mrsk-sqlite/commit/02b8932a78d8d1e410c8656d9a49da050276e006#diff-766c34fd6533171eaf54300c153f89d6002c35c02cfc9c5b219251f85180ad07)

But a better option is to build and add a simple `/up` route mappting. Ultimately, this healthcheck should do more, including excercising DB access, etc to ensure all features of the new container are working before MRSK rolls it over.

This is still a pretty basic `/up` check for our purposes of testing and proving concepts:

[app/controllers/healthcheck_controller.rb](https://github.com/knightoftheoldcode/rails-mrsk-sqlite/commit/02b8932a78d8d1e410c8656d9a49da050276e006#diff-03a6513e37ef7e0dd4a850913d2b3112ea412a6c9853a89c5cb0d9e60454e2db)

### MRSK Deploy

Once all of this is running:

- Dockerfile / Compose Properly Builds
- Healthcheck Endpoint is returning a 200 OK
- Config stuff is in

You should now be ready for a `bin/mrsk deploy`.

It will take a while; but it should deploy to your target.

For me, I've been using a Digital Ocean $6/month Droplet to test it. (It might work with a smaller one; but while testing infrastructure I like to give it enough that I know I'm not bumping into hardware resource silliness issues. And you can tear down droplets as you please so you shouldn't incurr too many costs. One cool think about MRSK is that fits well into a strategy for quickly raising and tearing down infrastructure.)

My ulitmate demo will be incorporating a bunch more stuff into having an ultimate infrastructure tool that can work all the way from "rails new" to fairly comprehensive on-prem or cloud production deploy.

### NOTES

The entire process above can be a bit more tricky your first few times working with Docker, for instance, on an Apple Silicon Mac. But you can use our friend Google to help troubleshoot anything you run into (feel free to open PRs and I'll try to respond here...but I'll do that more in future, better versions of these repos).

