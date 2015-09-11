module.exports = function(config) {
  var sauceLaunchers = {
    'Ie': {
      base: 'SauceLabs',
      browserName: 'internet explorer',
      platform: process.env.BVER === '10' ? 'Windows 8' : 'Windows 8.1',
      version: process.env.BVER
    }
  };
  var browser = process.env.BROWSER || 'chrome';
  config.set({

    basePath: '../',

    files: [
      'unit/*.js'
    ],

    autoWatch: true,

    frameworks: ['jasmine'],

    customLaunchers: sauceLaunchers,

    browsers: [browser[0].toUpperCase() + browser.substr(1)],

    CHROME_BIN: process.env.BROWSERBIN,
    FIREFOX_BIN: process.env.BROWSERBIN,

    plugins: [
      'karma-chrome-launcher',
      'karma-firefox-launcher',
      'karma-jasmine',
      'karma-sauce-launcher'
    ],

    junitReporter: {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    },

    sauceLabs: {
      startConnect: false,
      tunnelIdentifier: process.env.TRAVIS_JOB_NUMBER
    },

    reporters: ['progress', 'saucelabs']

  });
};
