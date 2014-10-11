chai = require 'chai'
chai.should()
expect = chai.expect
sinon = require 'sinon'
MiyoFilters = require '../talking.js'

describe 'initialize', ->
	ms = null
	request = null
	id = null
	stash = null
	beforeEach ->
		ms = sinon.stub()
		ms.dictionary = {}
		ms.variables_temporary = {}
		request = sinon.stub()
		id = 'OnTest'
		stash = null
	it 'should initialize', ->
		argument =
			talking_initialize:
				timeout: 30
		return_argument = MiyoFilters.talking_initialize.call ms, argument, request, id, stash
		return_argument.should.be.deep.equal argument
		ms.variables_temporary.talking_timeout.should.be.equal argument.talking_initialize.timeout
		ms.variables_temporary.talking.should.be.false
		ms.dictionary.OnTalkingFilterTalkBegin.should.exist
		ms.dictionary.OnTalkingFilterTalkEnd.should.exist

describe 'talking value filter', ->
	ms = null
	request = null
	id = null
	stash = null
	beforeEach ->
		ms = sinon.stub()
		request = sinon.stub()
		id = 'OnTest'
		stash = null
	it 'should set value', ->
		value = '\\h\\s[0]test\\e'
		return_value = MiyoFilters.talking.call ms, value, request, id, stash
		return_value.should.be.equal '\\![raise,OnTalkingFilterTalkBegin]' + value.replace(/\\e/, '') + '\\![raise,OnTalkingFilterTalkEnd]' + '\\e'

describe 'talking begin', ->
	ms = null
	request = null
	id = null
	stash = null
	clock = null
	beforeEach ->
		ms = sinon.stub()
		ms.dictionary = {}
		ms.variables_temporary = {}
		request = sinon.stub()
		id = 'OnTest'
		stash = null
		clock = sinon.useFakeTimers()
	afterEach ->
		clock.restore()
	it 'should return empty', ->
		argument =
			talking_initialize:
				timeout: 30
		MiyoFilters.talking_initialize.call ms, argument, request, id, stash
		return_value = MiyoFilters.talking_begin.call ms, {}, request, id, stash
		return_value.should.be.equal ''
	it 'should set flag and set timeout on non-zero timeout', ->
		argument =
			talking_initialize:
				timeout: 30
		MiyoFilters.talking_initialize.call ms, argument, request, id, stash
		MiyoFilters.talking_begin.call ms, {}, request, id, stash
		ms.variables_temporary.talking.should.be.true
		expect(ms.variables_temporary.talking_timer).exist
		clock.tick(argument.talking_initialize.timeout * 1000)
		ms.variables_temporary.talking.should.be.false
	it 'should set flag and not set timeout on zero timeout', ->
		argument =
			talking_initialize:
				timeout: 0
		MiyoFilters.talking_initialize.call ms, argument, request, id, stash
		MiyoFilters.talking_begin.call ms, {}, request, id, stash
		ms.variables_temporary.talking.should.be.true
		expect(ms.variables_temporary.talking_timer).not.exist
	it 'should clear previous timer', ->
		argument =
			talking_initialize:
				timeout: 30
		MiyoFilters.talking_initialize.call ms, argument, request, id, stash
		MiyoFilters.talking_begin.call ms, {}, request, id, stash
		clock.tick(20 * 1000)
		MiyoFilters.talking_begin.call ms, {}, request, id, stash
		clock.tick(10 * 1000)
		ms.variables_temporary.talking.should.be.true
		clock.tick(20 * 1000)
		ms.variables_temporary.talking.should.be.false

describe 'talking end', ->
	ms = null
	request = null
	id = null
	stash = null
	clock = null
	beforeEach ->
		ms = sinon.stub()
		ms.dictionary = {}
		ms.variables_temporary = {}
		request = sinon.stub()
		id = 'OnTest'
		stash = null
		clock = sinon.useFakeTimers()
	afterEach ->
		clock.restore()
	it 'should return empty', ->
		argument =
			talking_initialize:
				timeout: 30
		MiyoFilters.talking_initialize.call ms, argument, request, id, stash
		return_value = MiyoFilters.talking_end.call ms, {}, request, id, stash
		return_value.should.be.equal ''
	it 'should unset flag and clear timeout', ->
		argument =
			talking_initialize:
				timeout: 30
		MiyoFilters.talking_initialize.call ms, argument, request, id, stash
		MiyoFilters.talking_begin.call ms, {}, request, id, stash
		MiyoFilters.talking_end.call ms, {}, request, id, stash
		ms.variables_temporary.talking.should.be.false
		ms.variables_temporary.talking = true
		clock.tick(40 * 1000)
		ms.variables_temporary.talking.should.be.true
