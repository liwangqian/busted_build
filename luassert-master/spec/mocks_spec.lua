describe("Tests dealing with mocks", function()
  local test = {}

  before_each(function()
    test = {
      key = function()
        return "derp"
      end
    }
  end)

  it("makes sure we're returning the same table", function()
    local val = tostring(test)
    assert(type(mock(test)) == "table")
    assert(tostring(mock(test)) == val)
  end)

  it("makes sure function calls are spies", function()
    assert(type(test.key) == "function")
    mock(test)
    assert(type(test.key) == "table")
    assert(test.key() == "derp")
  end)

  it("makes sure function calls are stubs when specified", function()
    assert(type(test.key) == "function")
    mock(test, true)
    assert(type(test.key) == "table")
    assert(test.key() == nil)
  end)

  it("makes sure call history can be cleared", function()
    test.foo = { bar = function() return "foobar" end }
    mock(test)
    test.key()
    test.key("test")
    test.foo.bar()
    test.foo.bar("hello world")
    assert.spy(test.key).was.called()
    assert.spy(test.foo.bar).was.called()
    mock.clear(test)
    assert.spy(test.key).was_not.called()
    assert.spy(test.foo.bar).was_not.called()
  end)

  it("makes sure table can be reverted to pre-mock state", function()
    local val = tostring(test)
    mock(test)
    mock.revert(test)
    assert(type(test.key) == "function")
    assert(test.key() == "derp")
    assert(tostring(test) == val)
  end)
end)
