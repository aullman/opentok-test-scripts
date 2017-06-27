describe('example test', function() {
  it('publishes successfully', function(done) {
    OT.initPublisher(function(err) {
      expect(err).toBeFalsy();
      done();
    });
  });
});
