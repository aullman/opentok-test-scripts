OpenTok Test Scripts
=====

This is a set of scripts which I use for various projects for testing. I use it in conjunction with [travis-multirunner](https://www.npmjs.com/package/travis-multirunner) to test OpenTok applications. It has various helpers in there for testing WebRTC and particularly OpenTok applications.

The [run-tests](run-tests) script uses travis-multirunner to install Chrome and Firefox on Travis based on BROWSER and BVER environment variables. If `SAUCECONNECT` env variable is set then it starts SauceConnect. If the `BROWSERSTACK` env variable is set then is starts BrowserstackLocal. It then runs your unit and integration tests. If you set the UNIT_CMD env variable then it will run that, if you set the INTEGRATION_CMD env variable then it will run that. The tests pass if both of these commands pass.

The [packageSauceLabsInstaller](plugin-installer/packageSauceLabsInstaller.sh) script is used to package up a self executing plugin installer for SauceLabs. It downloads the OpenTok IE plugin and packages it up along with ManyCam (if BUNDLE_MANYCAM is not set to 'false') and tells IE to always allow access to devices. Usage is: `./packageSauceLabsInstaller.sh PATH_TO_OPENTOK BUNDLE_MANYCAM`, eg. `./packageSauceLabsInstaller.sh https://static.opentok.com/v2 true`. The idea is that this is supposed to be used as a pre-run executable for SauceLabs. An example of using it with Protractor is [here](https://github.com/aullman/opentok-test-scripts/blob/master/tests/integration/example.js#L7). For more information on SauceLabs pre-run executables see the [SauceLabs documentation](https://wiki.saucelabs.com/display/DOCS/Pre-Run+Executables).

There are some [examples of karma and protractor configuration files](tests/) included.

Then you can setup your `.travis.yml` file to look something like the [`.travis.yml`](.travis.yml) in this repo and it will run the tests for every combination in your build matrix.
