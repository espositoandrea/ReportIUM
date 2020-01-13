module.exports.chartsToSVG = function () {
    const vega = require('vega');
    const path = require('path');
    const fs = require('fs');
    
    const directoryPath = path.join(__dirname, 'src/graphs');

    fs.readdir(directoryPath, function (err, files) {
        if (err) {
            return console.log('Unable to scan directory: ' + err);
        }

        files.forEach(function (file) {
            let rawdata = fs.readFileSync(path.join(directoryPath, file));
            let spec = JSON.parse(String(rawdata));
            let view = new vega.View(vega.parse(spec), {renderer: 'none'});

            view.toSVG()
                .then(function (svg) {
                    let output = path.join(__dirname, 'src/documentazione/images', path.basename(file, path.extname(file)) + ".svg");
                    fs.writeFile(output, svg, function (error) {
                        if (error) return console.log(error);
                    })
                })
                .catch(function (err) {
                    console.error(err);
                });
        });
    });
};
