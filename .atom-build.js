module.exports = {
    cmd: "./build.sh test",
    functionMatch: function(terminal_output) {
        var matches = [];
        var regexes = [
            /([^:]+)\:([0-9]+)\: (characters|lines) ([0-9]+)\-([0-9]+) \: (.+)/
        ];

        terminal_output.split(/\n/).forEach(function(line) {
            for (var i in regexes) {
                var m = line.match(regexes[i]);

                if (m !== null) {
                    var lint = {
                        file: m[1],
                        line: m[2],
                        message: m[6]
                    };

                    if(m[3] == 'characters') {
                        lint['col'] = m[4];
                        lint['col_end'] = m[5];
                    }

                    if(m[3] == 'lines') {
                        // TODO
                    }

                    matches.push(lint);
                }
            }
        });

        return matches;
    }
}
