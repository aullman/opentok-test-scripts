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
      }, 60000);
    });
  });
});
