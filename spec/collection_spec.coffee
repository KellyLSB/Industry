$        = require('jquery')
test     = require('../lib/test.coffee')
industry = require('../lib/Industry.coffee')

describe "Industry Collection: ", ->

  it "Create new empty collection", ->
    collection = industry.CollectionFactory.define()

    expect(collection._data).toEqual({})
    expect(typeof collection._base).toEqual('function')
    expect(collection._base()).toEqual({})
    expect(collection._klass).toEqual(false)
    expect(Object.keys(collection.traits).length).toEqual(0)

    result = collection.create()
    expect(result).toEqual([])


  it "Create collection with 1 model", ->

    model = industry.ModelFactory.define(data: {input: 'value'})

    expect(model._data).toEqual(input: 'value')
    expect(typeof model._base).toEqual('function')
    expect(model._base()).toEqual({})
    expect(model._klass).toEqual(false)
    expect(Object.keys(model.traits).length).toEqual(0)

    collection = industry.CollectionFactory.define(klass: test.MyCollection, model: model)

    expect(collection._data).toEqual({})
    expect(typeof collection._base).toEqual('function')
    expect(collection._base()).toEqual({})
    expect(collection._klass).toEqual(test.MyCollection)
    expect(Object.keys(collection.traits).length).toEqual(0)

    result = collection.create(null, 1)
    expect(result.data.length).toEqual(1)


  it "Create collection with traits", ->

    traits = {
      new: ->
        other: 'one'
    }

    model = industry.ModelFactory.define(data: {input: 'value'}, klass: test.MyClass, traits: traits)

    expect(model._data).toEqual(input: 'value')
    expect(typeof model._base).toEqual('function')
    expect(model._base()).toEqual({})
    expect(model._klass).toEqual(test.MyClass)
    expect(Object.keys(model._traits).length).toEqual(1)

    collection = industry.CollectionFactory.define klass: test.MyCollection, (f) ->
      f.trait 'pizza', ->
        pizza: 'pie'

    expect(collection._data).toEqual({})
    expect(typeof collection._base).toEqual('function')
    expect(collection._base()).toEqual({})
    expect(collection._klass).toEqual(test.MyCollection)
    expect(Object.keys(collection._traits).length).toEqual(1)

    result = collection.create(null, 5, model, 'pizza', 'new').getResults()

    expect(result.length).toEqual(5)
    expect(Object.keys(result[0].data)).toEqual(['input', 'pizza', 'other'])
