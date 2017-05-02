[![Build Status](https://travis-ci.org/aullman/opentok-test-scripts.svg?branch=master)](https://travis-ci.org/aullman/opentok-test-scripts)

OpenTok Test Scripts
=====

This is a set of scripts which I use for various projects for testing. I use it in conjunction with [travis-multirunner](https://www.npmjs.com/package/travis-multirunner) to test OpenTok applications. It has various helpers in there for testing WebRTC and particularly OpenTok applications.

The [run-tests](run-tests) script uses travis-multirunner to install Chrome and Firefox on Travis based on BROWSER and BVER environment variables. If `SAUCECONNECT` env variable is set then it starts SauceConnect. If the `BROWSERSTACK` env variable is set then is starts BrowserstackLocal. It then runs your unit and integration tests. If you set the UNIT_CMD env variable then it will run that, if you set the INTEGRATION_CMD env variable then it will run that. The tests pass if both of these commands pass.

The [packageSauceLabsInstaller](plugin-installer/packageSauceLabsInstaller.sh) script is used to package up a self executing plugin installer for SauceLabs. It downloads the OpenTok IE plugin and packages it up and enables fake devices (if FAKE_DEVICES is not set to 'false') and tells IE to always allow access to devices. Usage is: `./packageSauceLabsInstaller.sh PATH_TO_OPENTOK FAKE_DEVICES`, eg. `./packageSauceLabsInstaller.sh https://static.opentok.com/v2 true`. The idea is that this is supposed to be used as a pre-run executable for SauceLabs. An example of using it with Protractor is [here](https://github.com/aullman/opentok-test-scripts/blob/master/tests/integration/example.js#L7). For more information on SauceLabs pre-run executables see the [SauceLabs documentation](https://wiki.saucelabs.com/display/DOCS/Pre-Run+Executables).

There are some [examples of karma and protractor configuration files](tests/) included.

Then you can setup your `.travis.yml` file to look something like the [`.travis.yml`](.travis.yml) in this repo and it will run the tests for every combination in your build matrix.

OpenTok Requirements
-----
* opentok-test-scripts v2 requires opentok.js v2.7+
* opentok-test-scripts v3 requires opentok.js v2.8+

Specifying versions
----

The run-tests script also allows you to specify specific browser versions for Chrome and Firefox. It then pulls the correct browser binary from either the [mozilla ftp site](https://ftp.mozilla.org/pub/firefox/releases/) or [slimjet.com](https://www.slimjet.com/chrome/google-chrome-old-version.php) for Chrome (because unfortunately Google does not provide old versions of Chrome). You must specify a specific version that is available on one of these sites. eg. `BROWSER=chrome BVER=54.0.2840.71` or `BROWSER=firefox BVER=46.0.1`.
