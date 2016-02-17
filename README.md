# SimpleJenkins

A super simple API for interacting with jenkins. Currently only does 3 things: fetching jobs, fetching views, building jobs

This gem was extracted from another project, as such it has not had a lot of TLC nor is it likely to in the near future.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_jenkins'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_jenkins

## Usage

```ruby
adapter = SimpleJenkins::Adapter.new

jobs = adapter.fetch_jobs
views = adapter.fetch_views

adapter.build_job(jobs.first)
```
