jasmine.DEFAULT_TIMEOUT_INTERVAL = 20000;

describe('example test', function() {
  it('publishes successfully', function(done) {
    OT.initPublisher(function(err) {
      expect(err).toBeFalsy();
      done();
    });
  });
});
