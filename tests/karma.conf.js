module.exports = function(config) {
  var sauceLaunchers = {
    ie: {
      base: 'SauceLabs',
      browserName: 'internet explorer',
      platform: process.env.BVER === '10' ? 'Windows 8' : 'Windows 8.1',
      version: process.env.BVER,
      prerun: {
        executable: 'http://localhost:5000/plugin-installer/SauceLabsInstaller.exe',
        background: false,
        timeout: 120,
      }
    },
    chrome: {
      base: 'Chrome',
      flags: ['--use-fake-ui-for-media-stream', '--use-fake-device-for-media-stream']
    },
    firefox: {
      base: 'Firefox',
      prefs: {
        'media.navigator.permission.disabled': true,
        'media.navigator.streams.fake': true,
        'app.update.enabled': false,
      }
    },
    edge: {
      base: 'SauceLabs',
      browserName: 'MicrosoftEdge',
      platform: 'Windows 10',
      version: process.env.BVER,
      prerun: {
        executable: 'http://localhost:5000/edge-setup/EdgeSetup.exe',
        background: true,
        timeout: 120,
      }
    }
  };
  var browser;
  if (process.env.BROWSER === 'safari') {
    browser = process.env.BVER === 'unstable' ? 'SafariTechPreview' : 'Safari'
  } else {
    browser = process.env.BROWSER || 'chrome';
  }
  config.set({
    hostname: process.env.BROWSER === 'safari' ? '127.0.0.1' : 'localhost',
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
