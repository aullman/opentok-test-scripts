module.exports = function(config) {
  var sauceLaunchers = {
    ie: {
      base: 'SauceLabs',
      browserName: 'internet explorer',
      platform: process.env.BVER === '10' ? 'Windows 8' : 'Windows 8.1',
      version: process.env.BVER
    },
    chrome: {
      base: 'Chrome',
      flags: ['--use-fake-ui-for-media-stream', '--use-fake-device-for-media-stream']
    },
    firefox: {
      base: 'Firefox',
      prefs: {
        'media.navigator.permission.disabled': true,
        'app.update.enabled': false,
      }
    },
    safari: {
      base: 'Safari'
    }
  };
  var browser;
  if (process.env.BROWSER === 'safari') {
    browser = process.env.BVER === 'unstable' ? 'SafariTechPreview' : 'Safari'
  } else {
    browser = process.env.BROWSER || 'chrome';
  }
  config.set({

    basePath: '../',

    files: [
      'https://tbdev.tokbox.com/v2/js/opentok.js',
      'tests/unit/*.js'
    ],

    autoWatch: true,

    frameworks: ['jasmine'],

    customLaunchers: sauceLaunchers,

    browsers: [browser],

    plugins: [
      'karma-chrome-launcher',
      'karma-firefox-launcher',
      'karma-safari-launcher',
      'karma-safaritechpreview-launcher',
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
