function getCapabilitiesFor(browserName, version) {
  var base = {
    'tunnel-identifier' : process.env.TRAVIS_JOB_NUMBER,
    'name': browserName + version + '-' + process.env.TRAVIS_BRANCH + '-' +
      process.env.TRAVIS_PULL_REQUEST,
    'build': process.env.TRAVIS_BUILD_NUMBER,
    'prerun': {
      'executable': 'http://localhost:5000/plugin-installer/SauceLabsInstaller.exe',
      'background': false,
      'timeout': 120
    }
  };
  // Sauce Labs Supports IE 10 on Windows 8 and IE 11 on Windows 8.1
  base.platform = version === '10' ? 'Windows 8' : 'Windows 8.1';
  base.browserName = browserName === 'ie' ? 'internet explorer' : browserName;
  base.version = version;
  return base;
}

var config = {
  allScriptsTimeout: 30000,
  specs: [
    'integration/*.js'
  ],
  baseUrl: 'http://localhost:5000/',
  framework: 'jasmine',
  jasmineNodeOpts: {
    defaultTimeoutInterval: 90000
  }
};

switch(process.env.BROWSER) {
  case 'ie':
    config.sauceUser = process.env.SAUCE_USERNAME;
    config.sauceKey = process.env.SAUCE_ACCESS_KEY;
    config.capabilities = getCapabilitiesFor(process.env.BROWSER, process.env.BVER);
  break;
  case 'firefox':
    var helper = require('./firefox-helper.js');
    config.getMultiCapabilities = helper.getFirefoxProfile;
    config.seleniumAddress = 'http://hub.browserstack.com/wd/hub';
  break;
  default:
  case 'chrome':
    config.capabilities = {
        'browserName': 'chrome',
        'chromeOptions': {
          'args': ['auto-select-desktop-capture-source="Entire screen"',
            'use-fake-device-for-media-stream',
            'use-fake-ui-for-media-stream'],
          'binary': process.env.BROWSERBIN
        }
      };
    config.directConnect = true;
  break;
}
exports.config = config;
