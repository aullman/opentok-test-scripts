const merge = require('lodash.merge');
const helper = require('./firefox-helper.js');

const sauceSettings = {
  sauceUser: process.env.SAUCE_USERNAME,
  sauceKey: process.env.SAUCE_ACCESS_KEY,
  capabilities: {
    'tunnel-identifier': process.env.TRAVIS_JOB_NUMBER,
    name: process.env.BROWSER + '-' +
      process.env.TRAVIS_BRANCH + '-' + process.env.TRAVIS_PULL_REQUEST,
    build: process.env.TRAVIS_BUILD_NUMBER
  }
};

const ieCapabilities = {
  capabilities: {
    prerun: {
      executable: 'http://localhost:5000/plugin-installer/SauceLabsInstaller.exe',
      background: false
    },
    // Sauce Labs Supports IE 10 on Windows 8 and IE 11 on Windows 8.1
    platform: process.env.BVER === '10' ? 'Windows 8' : 'Windows 8.1',
    browserName: 'internet explorer',
    version: process.env.BVER,
  }
};

let config = {
  allScriptsTimeout: 30000,
  specs: [
    'integration/example.js'
  ],
  baseUrl: 'http://localhost:5000/',
  framework: 'jasmine',
  jasmineNodeOpts: {
    defaultTimeoutInterval: 90000
  }
};

switch(process.env.BROWSER) {
  case 'ie':
    merge(config, sauceSettings);
    merge(config, ieCapabilities);
  break;
  case 'firefox':
    config.getMultiCapabilities = helper.getFirefoxProfile;
    config.directConnect = true;
    config.firefoxPath = process.env.BROWSERBIN;
  break;
  case 'edge':
    merge(config, sauceSettings);
    merge(config, {
      capabilities: {
        browserName: 'MicrosoftEdge',
        platform: 'Windows 10',
        version: process.env.BVER,
        prerun: {
          executable: 'http://localhost:5000/edge-setup/EdgeSetup.exe',
          background: false,
          timeout: 120
        }
      }
    });
  break;
  default:
  case 'chrome':
    config.capabilities = {
        browserName: 'chrome',
        chromeOptions: {
          args: ['auto-select-desktop-capture-source="Entire screen"',
            'use-fake-device-for-media-stream',
            'use-fake-ui-for-media-stream'],
          binary: process.env.BROWSERBIN
        }
      };
    config.directConnect = true;
  break;
}
exports.config = config;
