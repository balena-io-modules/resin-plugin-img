_ = require 'lodash'
fs = require 'fs'
imageFs = require 'resin-image-fs'

BOOT_PARTITION = 1

cp =
	signature: 'img cp <image> <from> <to>'
	description: 'copy a file into the boot partition of a resin OS disk image'
	options: [
		signature: 'partition'
		parameter: 'NUMBER'
		description: "write to partition NUMBER (default: #{BOOT_PARTITION})"
		alias: 'p'
	]
	action: (params, options, done) ->
		if not options.partition?
			options.partition = BOOT_PARTITION

		fromStream = fs.createReadStream(params.from)
		fromStream.on 'error', (e) ->
			console.error("Error while reading from #{params.from}", e)
			done(e)

		imageFs.write(
			image: params.image
			partition:
				primary: BOOT_PARTITION
			path: params.to
		, fromStream)
		.catch (e) ->
			console.error("Unable to write to #{params.image}", e)
			throw e
		.then (writeStream) ->
			new Promise (resolve, reject) ->
				writeStream.on 'error', (e) ->
					console.error("Error while writing to #{params.image}", e)
					reject(e)
				writeStream.on 'close', (e) ->
					resolve(e)
		.nodeify(done)

module.exports = [ cp ]
