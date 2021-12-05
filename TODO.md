New Projects:
- [ ] Write a server? Maybe in Elixir, for funsies? Or use Fibers and Websockets?
- [ ] Write a client app for the browser.
- [ ] Properly support players dynamically joining and leaving.
  - [ ] Bonus if each player can bring their own cash.
  - [ ] Bonus if a player can "step away" and keep their hand when returning.

Current Items:
- [ ] Try to come up with a more reliable test framework, such that the deck can be stacked, for testing, more appropriately.
- [ ] Complete code coverage. Many card powers are untested.
- [ ] Properly account for all edge cases. Of which there are *so many*.
  - Some tests will unreliably fail somewhat inexplicably. This is almost certainly because the deck wasn't stacked correctly enough to prepare for the situation being tested.
  - A more intelligent chooser in the test harness would also help prevent unrealistic player behaviors being tested. OTOH, no player behaviors are unrealistic in a system as simple as this.
- [x] Finish formalizing Event architecture: Evented::Array and Evented::Integer need to emit real Event::Details rather than generic willy-nilly arrays of arbitrary shape.
- [x] Probably convert Princess code to offer a succession of choices rather than a single ordering choice.
- [ ] Handle player presence a bit better
  - New players join in at the next gambit
  - Dropped players should be flagged inactive and skipped
  - How much of this should be internal game engine code and how much is server code?
