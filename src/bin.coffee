"use strict"

cmder = require 'commander'
$ = require './index'

cmder
    .usage "[command]"

cmder
    .command 'init'
    .alias 'i'
    .description 'init node project'
    .action ->
        $.init()
cmder
    .command 'clean'
    .alias 'cl'
    .description 'clean current folder'
    .action ->
        $.clean()

cmder
    .command 'shebang'
    .alias 'sb'
    .description 'show node shebang'
    .action ->
        console.log $.shebang

cmder
    .command 'cat <filename>'
    .description 'see file content'
    .action (filename) ->
        $.readFile filename
        .then console.log
        , (e) ->
            console.error e.stack or e.red

cmder
    .command 'update <filename>'
    .description 'update file content'
    .action (filename) ->
        $.update filename
        .catch (e) ->
            console.error e.stack or e.red

cmder.parse process.argv
