module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # Updating the package manifest files
    noflo_manifest:
      update:
        files:
          'component.json': ['graphs/*', 'components/*']
          'package.json': ['graphs/*', 'components/*']

    # Directory cleaning
    clean:
      'asset-server-components':
        src: ['components/*/']
      'asset-server':
        src: ['build']

    # Install components
    component:
      'asset-server':
        options:
          action: 'install'

    # Compiled all components into one file
    componentbuild:
      'asset-server':
        options:
          name: 'asset-server-pre'
          noRequire: true
          configure: (builder) ->
            # Enable Component plugins
            json = require 'component-json'
            builder.use json()
            # Coffee compilation
            coffee = require 'component-coffee'
            builder.use coffee
            # FBP compilation to JSON
            fbp = require 'component-fbp'
            builder.use fbp()
        dest: 'build'
        src: './'
        scripts: true
        styles: false

    # Fix broken Component aliases, as mentioned in
    # https://github.com/anthonyshort/component-coffee/issues/3
    combine:
      'asset-server':
        input: 'build/asset-server-pre.js'
        output: 'build/asset-server-pre.js'
        tokens: [
          token: '\\.coffee'
          string: '.js'
        ]

    # Combine custom version of component-require
    concat:
      'asset-server':
        src: ['node_modules/component-require/lib/require.js', 'build/asset-server-pre.js']
        dest: 'build/asset-server.js'
      'asset-server-bin':
        src: ['header.js', 'build/asset-server.js', 'aliases.js', 'server.js']
        dest: 'build/asset-server-bin'

    # JavaScript minification (Because it's FAST!!!)
    uglify:
      'asset-server':
        options:
          report: 'min'
        files:
          './build/asset-server.min.js': ['./build/asset-server.js']

    # Exec
    exec:
      'asset-server-bin':
        command: 'chmod +x build/asset-server-bin'

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-noflo-manifest'
  @loadNpmTasks 'grunt-component'
  @loadNpmTasks 'grunt-component-build'
  @loadNpmTasks 'grunt-combine'
  @loadNpmTasks 'grunt-contrib-concat'
  @loadNpmTasks 'grunt-contrib-uglify'
  @loadNpmTasks 'grunt-contrib-clean'
  @loadNpmTasks 'grunt-exec'

  # Our local tasks
  @registerTask 'build-components', ['noflo_manifest', 'component:asset-server', 'componentbuild:asset-server', 'combine:asset-server', 'concat:asset-server', 'uglify:asset-server']
  @registerTask 'build', ['build-components', 'concat:asset-server-bin', 'exec:asset-server-bin']

  @registerTask 'nuke', ['clean:asset-server-components', 'clean:asset-server']

  @registerTask 'default', ['build']
