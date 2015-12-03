describe('IE Smoke Test', function() {
  it('has the plugin installed and audio, video input devices', function (done) {
    // We need to wait a little bit for the tests before starting. This is to allow
    // the Plugin installer to finish in IE.
    var videoInput = element(by.css('.videoInput'));
    var audioInput = element(by.css('.audioInput'));
    var waitToStart = function () {
      browser.get('/devices.html');
      browser.wait(function () {
        return element(by.css('body.loaded')).isPresent();
      }, 4000).then(function () {
        videoInput.isPresent().then(function (hasVideoInput) {
          if (hasVideoInput) {
            audioInput.isPresent().then(function (hasAudioInput) {
              if (hasAudioInput) {
                done();
              } else {
                setTimeout(waitToStart, 2000);
              }
            });
          } else {
            setTimeout(waitToStart, 2000);
          }
        });
      });
    };
    waitToStart();
  });
});

describe('Example Test', function() {
  beforeEach(function() {
    browser.ignoreSynchronization = true;
    browser.get('');
  });
  it('has the right title', function() {
    expect(browser.getTitle()).toEqual('Example Test');
  });
  describe('publisher', function() {
    it('loads the video', function() {
      browser.wait(function() {
        return element(by.css('.OT_publisher:not(.OT_loading)')).isPresent();
      }, 10000);
    });
  });
});
