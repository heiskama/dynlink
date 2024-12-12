"use strict";

// Simple logger to differentiate between log levels based on an environment variable
// Level of verbosity: ERROR < WARN < INFO < LOG < DEBUG < TRACE

const trace = (...params) => console.trace(...params)
const debug = (...params) => console.log(...params)
const log = (...params) => console.log(...params)
const info = (...params) => console.info(...params)
const warn = (...params) => console.warn(...params)
const error = (...params) => console.error(...params)
const disabled = () => {}

// Choose log level
if (typeof process.env.LOG_LEVEL === 'string' && process.env.LOG_LEVEL.toUpperCase() === 'TRACE') {
  module.exports = {
    trace: trace, debug: debug, log: log, info: info, warn: warn, error: error
  }
}
else if (typeof process.env.LOG_LEVEL === 'string' && process.env.LOG_LEVEL.toUpperCase() === 'DEBUG') {
  module.exports = {
    trace: disabled, debug: debug, log: log, info: info, warn: warn, error: error
  }
}
else if (typeof process.env.LOG_LEVEL === 'string' && process.env.LOG_LEVEL.toUpperCase() === 'LOG') {
  module.exports = {
    trace: disabled, debug: disabled, log: log, info: info, warn: warn, error: error
  }
}
else if (typeof process.env.LOG_LEVEL === 'string' && process.env.LOG_LEVEL.toUpperCase() === 'INFO') {
  module.exports = {
    trace: disabled, debug: disabled, log: disabled, info: info, warn: warn, error: error
  }
}
else if (typeof process.env.LOG_LEVEL === 'string' && process.env.LOG_LEVEL.toUpperCase() === 'WARN') {
  module.exports = {
    trace: disabled, debug: disabled, log: disabled, info: disabled, warn: warn, error: error
  }
}
else if (typeof process.env.LOG_LEVEL === 'string' && process.env.LOG_LEVEL.toUpperCase() === 'ERROR') {
  module.exports = {
    trace: disabled, debug: disabled, log: disabled, info: disabled, warn: disabled, error: error
  }
}
// Default: debug and trace levels disabled
else {
  module.exports = {
    trace: disabled, debug: disabled, log: log, info: info, warn: warn, error: error
  }
}
