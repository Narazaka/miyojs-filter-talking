// Generated by CoffeeScript 1.8.0

/* (C) 2014 Narazaka : Licensed under The MIT License - http://narazaka.net/license/MIT?2014 */
var MiyoFilters;

if (typeof MiyoFilters === "undefined" || MiyoFilters === null) {
  MiyoFilters = {};
}

MiyoFilters.talking_initialize = {
  type: 'through',
  filter: function(argument, request, id, stash) {
    var timeout, _ref;
    timeout = 25;
    if ((argument != null ? (_ref = argument.talking_initialize) != null ? _ref.timeout : void 0 : void 0) != null) {
      timeout = argument.talking_initialize.timeout;
    }
    if (timeout < 0) {
      throw "timeout " + timeout + " must be >= 0";
    }
    this.variables_temporary.talking_timeout = timeout;
    this.variables_temporary.talking = false;
    this.dictionary.OnTalkingFilterTalkBegin = {
      filters: ['talking_begin']
    };
    this.dictionary.OnTalkingFilterTalkEnd = {
      filters: ['talking_end']
    };
    return argument;
  }
};

MiyoFilters.talking_begin = {
  type: 'any-value',
  filter: function(argument, request, id, stash) {
    this.variables_temporary.talking = true;
    clearTimeout(this.variables_temporary.talking_timer);
    if (this.variables_temporary.talking_timeout) {
      this.variables_temporary.talking_timer = setTimeout(((function(_this) {
        return function() {
          return _this.variables_temporary.talking = false;
        };
      })(this)), this.variables_temporary.talking_timeout * 1000);
    }
    return '';
  }
};

MiyoFilters.talking_end = {
  type: 'any-value',
  filter: function(argument, request, id, stash) {
    clearTimeout(this.variables_temporary.talking_timer);
    this.variables_temporary.talking = false;
    return '';
  }
};

MiyoFilters.talking = {
  type: 'value-value',
  filter: function(value, request, id, stash) {
    return '\\![raise,OnTalkingFilterTalkBegin]' + value.replace(/\\e/, '') + '\\![raise,OnTalkingFilterTalkEnd]' + '\\e';
  }
};

if ((typeof module !== "undefined" && module !== null) && (module.exports != null)) {
  module.exports = MiyoFilters;
}

//# sourceMappingURL=talking.js.map
