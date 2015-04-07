### travish

A super, super, super simple tool for running travis.yml files. Supports enough features that you can probably make it work if you define all your own steps.

Taking a reasonably complex `.travis.yml` file ( from [Eigen](https://github.com/artsy/eigen/blob/master/.travis.yml) )

``` yaml
osx_image: xcode61
language: objective-c

env:
  global:
    secure: "nNOR1HgbuY1Z1SgsHyn2p2EtcC7N8HMJvv3BrQwnY7Fzg6dkIFWISAZYzzijXaqN0BJ+lvKHSO8F4HjWRL64x868bPSMdf3xlqG2VR5yvKsFfpjwqxoyDsBYc68VPsH+tcZqQt4SC2wAqGSkOOF3Pn/4yGyoCGZWWq05cN05las="

cache:
  - bundler

before_install:
  - 'echo ''gem: --no-ri --no-rdoc'' > ~/.gemrc'
  - echo "machine github.com login $GITHUB_API_KEY" > ~/.netrc
  - chmod 600 ~/.netrc
  - pod repo add artsy https://github.com/artsy/Specs.git

before_script:
  - make ci
  
install:
  - bundle install --jobs=3 --retry=3 --deployment --path=${BUNDLE_PATH:-vendor/bundle}
  - make oss
  - bundle exec pod install

script:
  - make test
  - make lint

notifications:
  slack:
    secure: "fXmNnx6XW5OvT/j2jSSHYd3mHwbL+GzUSUSWmZVT0Vx/Ga5jXINTOYRY/9PYgJMqdL8a/L0Mf/18ZZ+tliPlWQ/DnfTz1a3Q/Pf94hfYSGhSGlQC/eXYcpOm/dNOKYQ3sr4tqXtTPylPUDXHeiM2D59ggdlUvVwcALGgHizajPQ="
```

Running `travish run` will execute all of your commands and set up any ENV variables that are _not_ secure. Running a full build of your test suite.

## Things it doesnt do

* Support notifications.
* Support secure env variables.
* Support secure anything really.
* Support the default script stages that are ran when a stage is not included.

I'm open to PRs for any of these things.

## Contributing to travish
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* You can run tests by running the command `rspec`
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

### Copyright

Copyright (c) 2015 Orta Therox & Artsy. See LICENSE.txt for
further details.

