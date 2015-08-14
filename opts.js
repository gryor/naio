var fs = require ('fs');

var option = process.argv.slice(2)[0];

if(option)
fs.readFile('package.json', {encoding: 'utf8'}, function (error, contents) {
	if(error) {
		console.error(error);
		return;
	}

	contents = JSON.parse(contents)[option];

	if(Array.isArray(contents))
		contents = contents.join(' ');

	console.log(contents);
});
