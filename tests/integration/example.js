describe('Example Test', function() {
  beforeEach(function() {
    browser.ignoreSynchronization = true;
    browser.get('');
  });
  it('has the right title', function() {
    expect(browser.getTitle()).toEqual('Example Test');
  });
});
