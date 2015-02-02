module.exports = function (grunt) {

    grunt.initConfig({
        relativeRoot: {
            docpad: {
                options: {
                    root: 'out'
                },
                files: [
                    {
                        expand: true,
                        cwd: '<%= relativeRoot.docpad.options.root %>',
                        src: [
                            //'** /*.css',
                            '**/*.html'
                        ],
                        dest: 'out/'
                    }
                ]
            }
        },
        'gh-pages': {
            options: {
                base: 'out',
                dotfiles: true,
                message: 'deploy - <%= (new Date).toISOString() %>',
                user: {
                    name: 'Daniel Salamon',
                    email: 'salidani@gmail.com'
                }
            },
            src: ['**/*']
        },
        shell: {
            'docpad-clean': {
                command: 'docpad clean'
            },
            'docpad-generate-production': {
                command: 'docpad generate --env production'
            }
        }
    });

    grunt.loadNpmTasks('grunt-relative-root');
    grunt.loadNpmTasks('grunt-gh-pages');
    grunt.loadNpmTasks('grunt-shell');

    grunt.registerTask('default', ['generate']);
    grunt.registerTask('generate', ['shell:docpad-clean', 'shell:docpad-generate-production', 'relativeRoot']);
    grunt.registerTask('deploy', ['gh-pages']);

};