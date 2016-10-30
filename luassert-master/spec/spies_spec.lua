local match = require 'luassert.match'

describe("Tests dealing with spies", function()
  local test = {}

  before_each(function()
    test = {key = function()
      return "derp"
    end}
  end)

  it("checks if a spy actually executes the internal function", function()
    spy.on(test, "key")
    assert(test.key() == "derp")
  end)

  it("checks to see if spy keeps track of arguments", function()
    spy.on(test, "key")

    test.key("derp")
    assert.spy(test.key).was.called_with("derp")
    assert.errors(function() assert.spy(test.key).was.called_with("herp") end)
  end)

  it("checks to see if spy keeps track of returned arguments", function()
    spy.on(test, "key")

    test.key()
    assert.spy(test.key).was.returned_with("derp")
    assert.errors(function() assert.spy(test.key).was.returned_with("herp") end)
  end)

  it("checks to see if spy keeps track of number of calls", function()
    spy.on(test, "key")
    test.key()
    test.key("test")
    assert.spy(test.key).was.called(2)
  end)

  it("checks returned_with() assertions", function()
    local s = spy.new(function(...) return ... end)
    local t = { foo = { bar = { "test" } } }
    local _ = match._

    s(1, 2, 3)
    s("a", "b", "c")
    s(t)
    t.foo.bar = "value"

    assert.spy(s).was.returned_with(1, 2, 3)
    assert.spy(s).was_not.returned_with({1, 2, 3}) -- mind the accolades
    assert.spy(s).was.returned_with(_, 2, 3) -- matches don't care
    assert.spy(s).was.returned_with(_, _, _) -- matches multiple don't cares
    assert.spy(s).was_not.returned_with(_, _, _, _) -- does not match if too many args
    assert.spy(s).was.returned_with({ foo = { bar = { "test" } } }) -- matches original table
    assert.spy(s).was_not.returned_with(t) -- does not match modified table
    assert.has_error(function() assert.spy(s).was.returned_with(5, 6) end)
  end)

  it("checks called() and called_with() assertions", function()
    local s = spy.new(function() end)
    local t = { foo = { bar = { "test" } } }
    local _ = match._

    s(1, 2, 3)
    s("a", "b", "c")
    s(t)
    t.foo.bar = "value"

    assert.spy(s).was.called()
    assert.spy(s).was.called(3) -- 3 times!
    assert.spy(s).was_not.called(4)
    assert.spy(s).was_not.called_with({1, 2, 3}) -- mind the accolades
    assert.spy(s).was.called_with(1, 2, 3)
    assert.spy(s).was.called_with(_, 2, 3) -- matches don't care
    assert.spy(s).was.called_with(_, _, _) -- matches multiple don't cares
    assert.spy(s).was_not.called_with(_, _, _, _) -- does not match if too many args
    assert.spy(s).was.called_with({ foo = { bar = { "test" } } }) -- matches original table
    assert.spy(s).was_not.called_with(t) -- does not match modified table
    assert.has_error(function() assert.spy(s).was.called_with(5, 6) end)
  end)

  it("checks called() and called_with() assertions using refs", function()
    local s = spy.new(function() end)
    local t1 = { foo = { bar = { "test" } } }
    local t2 = { foo = { bar = { "test" } } }

    s(t1)
    t1.foo.bar = "value"

    assert.spy(s).was.called_with(t2)
    assert.spy(s).was_not.called_with(match.is_ref(t2))
    assert.spy(s).was.called_with(match.is_ref(t1))
  end)

  it("checks called_with(aspy) assertions", function()
    local s = spy.new(function() end)

    s(s)

    assert.spy(s).was.called_with(s)
  end)

  it("checks called_at_least() assertions", function()
    local s = spy.new(function() end)

    s(1, 2, 3)
    s("a", "b", "c")
    assert.spy(s).was.called.at_least(1)
    assert.spy(s).was.called.at_least(2)
    assert.spy(s).was_not.called.at_least(3)
    assert.has_error(function() assert.spy(s).was.called.at_least() end)
  end)

  it("checks called_at_most() assertions", function()
    local s = spy.new(function() end)

    s(1, 2, 3)
    s("a", "b", "c")
    assert.spy(s).was.called.at_most(3)
    assert.spy(s).was.called.at_most(2)
    assert.spy(s).was_not.called.at_most(1)
    assert.has_error(function() assert.spy(s).was.called.at_most() end)
  end)

  it("checks called_more_than() assertions", function()
    local s = spy.new(function() end)

    s(1, 2, 3)
    s("a", "b", "c")
    assert.spy(s).was.called.more_than(0)
    assert.spy(s).was.called.more_than(1)
    assert.spy(s).was_not.called.more_than(2)
    assert.has_error(function() assert.spy(s).was.called.more_than() end)
  end)

  it("checks called_less_than() assertions", function()
    local s = spy.new(function() end)

    s(1, 2, 3)
    s("a", "b", "c")
    assert.spy(s).was.called.less_than(4)
    assert.spy(s).was.called.less_than(3)
    assert.spy(s).was_not.called.less_than(2)
    assert.has_error(function() assert.spy(s).was.called.less_than() end)
  end)

  it("checkis if called()/called_with assertions fail on non-spies ", function()
    assert.has_error(assert.was.called)
    assert.has_error(assert.was.called_at_least)
    assert.has_error(assert.was.called_at_most)
    assert.has_error(assert.was.called_more_than)
    assert.has_error(assert.was.called_less_than)
    assert.has_error(assert.was.called_with)
    assert.has_error(assert.was.returned_with)
  end)

  it("checks spies to fail when spying on non-callable elements", function()
    local s
    local testfunc = function()
      spy.new(s)
    end
    -- try some types to fail
    s = "some string";  assert.has_error(testfunc)
    s = 10;             assert.has_error(testfunc)
    s = true;           assert.has_error(testfunc)
    -- try some types to succeed
    s = function() end; assert.has_no_error(testfunc)
    s = setmetatable( {}, { __call = function() end } ); assert.has_no_error(testfunc)
  end)

  it("checks reverting a spy.on call", function()
     local old = test.key
     local s = spy.on(test, "key")
     test.key()
     test.key("test")
     assert.spy(test.key).was.called(2)
     -- revert and call again
     s:revert()
     assert.are.equal(old, test.key)
     test.key()
     test.key("test")
     assert.spy(s).was.called(2) -- still two, spy was removed
  end)

  it("checks reverting a spy.new call", function()
     local calls = 0
     local old = function() calls = calls + 1 end
     local s = spy.new(old)
     assert.is_table(s)
     s()
     s()
     assert.spy(s).was.called(2)
     assert.are.equal(calls, 2)
     local old_s = s
     s = s:revert()
     assert.are.equal(s, old)
     s()
     assert.spy(old_s).was.called(2)  -- still two, spy was removed
     assert.are.equal(calls, 3)
  end)

  it("checks clearing a spy.on call history", function()
     local s = spy.on(test, "key")
     test.key()
     test.key("test")
     s:clear()
     assert.spy(s).was.called(0)
  end)

  it("checks clearing a spy.new call history", function()
     local s = spy.new(function() return "foobar" end)
     s()
     s("test")
     s:clear()
     assert.spy(s).was.called(0)
     assert.spy(s).was_not.returned_with("foobar")
  end)

end)
