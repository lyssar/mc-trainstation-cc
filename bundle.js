var bundle = require('luabundle');
var fs = require('fs');
var distFolder = 'dist';
var bundles = ['server.lua', 'client.lua'];

if (fs.existsSync(distFolder) === false) {
    fs.mkdirSync(distFolder);
}

bundles.forEach(function(luaFile) {
    var bundledServerLua = bundle.bundle(`./${luaFile}`);
    fs.writeFileSync(`./${distFolder}/${luaFile}`, bundledServerLua);
});
