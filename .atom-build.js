module.exports = {
    cmd: "./build.sh test",
    functionMatch: function(terminal_output) {
        var matches = [];
        var regexes = [
            /([^:]+)\:([0-9]+)\: characters ([0-9]+)\-([0-9]+) \: (.+)/,
            /([^:]+)\:([0-9]+)\: lines ([0-9]+)\-([0-9]+) \: (.+)/
        ];

        terminal_output.split(/\n/).forEach(function(line) {
            for (var i in regexes) {
                var m = line.match(regexes[i]);

                if (m !== null) {
                    matches.push({
                        file: m[1],
                        line: m[2],
                        message: m[5]
                    });
                }
            }
        });

        return matches;
    }
}
