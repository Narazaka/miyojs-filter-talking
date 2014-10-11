### (C) 2014 Narazaka : Licensed under The MIT License - http://narazaka.net/license/MIT?2014 ###

unless MiyoFilters?
	MiyoFilters = {}

MiyoFilters.talking_initialize = (argument, request, id, stash) ->
	timeout = 25
	if argument.talking_initialize?.timeout? then timeout = argument.talking_initialize.timeout
	@variables_temporary.talking_timeout = timeout
	@variables_temporary.talking = false
	@dictionary.OnTalkingFilterTalkBegin =
		filters: ['talking_begin']
	@dictionary.OnTalkingFilterTalkEnd =
		filters: ['talking_end']
	argument

MiyoFilters.talking_begin = (argument, request, id, stash) ->
	@variables_temporary.talking = true
	clearTimeout @variables_temporary.talking_timer
	if @variables_temporary.talking_timeout
		@variables_temporary.talking_timer = setTimeout (=> @variables_temporary.talking = false), @variables_temporary.talking_timeout * 1000
	''

MiyoFilters.talking_end = (argument, request, id, stash) ->
	clearTimeout @variables_temporary.talking_timer
	@variables_temporary.talking = false
	''

MiyoFilters.talking = (value, request, id, stash) ->
	'\\![raise,OnTalkingFilterTalkBegin]' + value.replace(/\\e/, '') + '\\![raise,OnTalkingFilterTalkEnd]' + '\\e'

if module? and module.exports?
	module.exports = MiyoFilters
