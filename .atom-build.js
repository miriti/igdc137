module.exports = {
    cmd: "./build.sh test",
    functionMatch: function(terminal_output) {
      var matches = [];
      var regex = /([^:]+)\:([0-9]+)\: characters ([0-9]+)\-([0-9]+) \: (.+)/;

      terminal_output.split(/\n/).forEach(function(line) {
        var m = line.match(regex);

        if(m!==null) {
          matches.push({
            file: m[1],
            line: m[2],
            col: m[3]+1,
            message: m[5]
          })
        }
      });

      return matches;
    }
}
