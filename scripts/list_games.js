var fs = require('fs');

var dirname = './games/';
var output = {};

function getGameName(gamepath, mainFile, gamename) {
    var game = fs.readFileSync(gamepath + '/' + mainFile, 'utf-8');
    var name = game.match(/\$Name\(ru\)\s*:\s*([^\$\n]+)/);
    if (name) {
        return name[1].trim();
    }
    name = game.match(/\$Name\s*:\s*([^\$\n]+)/);
    if (name) {
        return name[1].trim();
    }
    return gamename;
}

function walkSync(dir, filelist, gamedir) {
    var files = filelist;
    fs.readdirSync(dir).forEach(function readDir(file) {
        var fullpath = dir + '/' + file;
        if (fs.statSync(fullpath).isDirectory()) {
            files = walkSync(fullpath, files, gamedir);
        } else if (file.match(/(jpg|jpeg|png|gif|bmp|tiff|tif)$/i)) {
            files.push(fullpath.replace(gamedir + '/', ''));
        }
    });
    return files;
}


fs.readdir(dirname, function readFn(err, filenames) {
    if (err) {
        return;
    }
    filenames.forEach(function processFn(filename) {
        var gamepath = dirname + filename;
        var gameName;
        var images;
        var hasTheme = false;
        var stead = null;
        var mainFile;
        if (fs.lstatSync(gamepath).isDirectory()) {
            if (fs.existsSync(gamepath + '/main.lua')) {
                stead = 2; // stead 2.x
                mainFile = 'main.lua';
            }
            if (fs.existsSync(gamepath + '/main3.lua')) {
                stead = 3; // stead 3.x
                mainFile = 'main3.lua';
            }
            if (stead) {
                gameName = getGameName(gamepath, mainFile, filename);
                images = walkSync(gamepath, [], gamepath);
                if (fs.existsSync(gamepath + '/theme.ini')) {
                    hasTheme = true;
                }
                output[filename] = {
                    name: gameName,
                    stead: stead,
                    theme: hasTheme,
                    preload: images
                };
            }
        }
    });
    fs.writeFile(dirname + 'games_list.json',  JSON.stringify(output), {flag: 'w'});
});
