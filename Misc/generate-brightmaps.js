// JavaScript (Node.js)
var fs = require('fs');

var pathToBrightmaps = process.argv[2] || './brightmaps/';
var pathInPk3 = process.argv[3] || 'brightmaps/sprites/';
var outputFilePath = process.argv[4] || './';

fs.readdir(pathToBrightmaps, function(err, sprites) {
    // If we cared more about performance, we'd stream write contents to an existing file
    // but at this point that's not a necessary optimization
    var newFileContents = '';

    sprites.forEach(function(spriteName) {
        newFileContents += `BRIGHTMAP SPRITE ${spriteName.split('.')[0]} { MAP "brightmaps/sprites/${spriteName}" }`;

        newFileContents += '\n';
    });

    fs.writeFile(`${outputFilePath}/output.txt`, newFileContents, () => {});
});
