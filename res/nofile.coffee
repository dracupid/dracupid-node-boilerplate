kit = require 'nokit'
{fs, _} = kit
Promise ?= kit.Promise
drives = kit.require 'drives'

module.exports = (task, option) ->
    option '-a, --all', 'build without cache'

    task 'build', "Build Project", (opts) ->
        kit.warp ''
        .load drives.reader isCache: not opts.all
        .load drives.auto 'compile'
        .run ''

    task 'default', ['build']
