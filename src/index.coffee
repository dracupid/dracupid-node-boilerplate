"use strict"

path = require 'path'
kit = require 'nokit'
fs = kit.fs
Promise = kit.Promise
kit.require 'colors'

shebang = '#!/usr/bin/env node'

_dirs = ['src', 'test']
_files = ['CHANGELOG.md', 'src/index.coffee']

renderReadme = ->
    fs.readFile './Readme.md', encoding: 'utf8'
    .then (content) ->
        tpl = kit._.template(content)
        tpl(name: path.basename process.cwd())
    .then (readme) ->
        fs.writeFile './Readme.md', readme

module.exports =
    init: (opts) ->
        console.log "Creating Files...".green
        fs.glob path.join(__dirname, '../res/*'), all: true
        .then (files) ->
            Promise.all files.map (f) ->
                fs.copy f, '.'
        .then ->
            fs.rename './git.ignore', '.gitignore'
        .then ->
            Promise.all _dirs.map (dir) ->
                fs.mkdirs dir
        .then ->
            Promise.all _files.map (file) ->
                fs.touch file
        .then ->
            renderReadme()
        .then ->
            console.log "git init...".green
            kit.exec 'git init'
        .then ->
            console.log "npm init...".green
            kit.spawn 'npm', ['init']
        .then ->
            console.log 'done!'.green
        .catch (e) ->
            console.error e.stack or e

    clean: ->
        Promise.all [fs.remove('*', all: true), fs.remove('.*', all: true)]

    readFile: (name) ->
        name = path.join(__dirname, '../res/' + name + '*')
        fs.glob name, all: true
        .then (name) ->
            if name[0]
                fs.readFile name[0], encoding: 'utf8'
            else
                Promise.reject "File Not Found!"

    update: (name) ->
        name = path.join(__dirname, '../res/' + name + '*')
        fs.glob name, all: true
        .then (name) ->
            if name[0]
                fs.readFile name[0], encoding: 'utf8'
                .then (content) ->
                    fs.writeFile path.basename(name[0]), content
            else
                Promise.reject "File Not Found!"

    shebang: '#!/usr/bin/env node'

