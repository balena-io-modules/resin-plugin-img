_ = require 'lodash'
fs = require 'fs'
imageFs = require 'resin-image-fs'
es = require 'event-stream'
Stream = require 'stream'

BOOT_PARTITION = 1
CONFIG_PRIMARY_PARTITION = 4
CONFIG_LOGICAL_PARTITION = 1

streamToPromise = (stream) ->
	new Promise (resolve, reject) ->
		stream.on('error', reject)
		stream.on('close', resolve)

objToStream = (obj) ->
	stream = new Stream.Readable()
	stream.push(JSON.stringify(obj))
	stream.push(null)
	return stream

readConfig = (image) ->
	imageFs.read
		image: image
		partition:
			primary: CONFIG_PRIMARY_PARTITION
			logical: CONFIG_LOGICAL_PARTITION
		path: 'config.json'
	.then (configStream) ->
		new Promise (resolve, reject) ->
			configStream
			.on('error', reject)
			.pipe(es.parse())
			.on('error', reject)
			.on('data', resolve)

updateConfig = (image, newFile) ->
	readConfig(image)
	.then (config) ->
		config.customBootFiles ?= []
		if config.customBootFiles.indexOf(newFile) < 0
			config.customBootFiles.push(newFile)

		configStream = objToStream(config)

		imageFs.write(
			image: image
			partition:
				primary: CONFIG_PRIMARY_PARTITION
				logical: CONFIG_LOGICAL_PARTITION
			path: 'config.json'
		, configStream)
	.then (writeStream) ->
		streamToPromise(writeStream)

cp =
	signature: 'img cp <image> <from> <to>'
	description: 'copy a file into the boot partition of a resin OS disk image'
	action: (params, options, done) ->
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
			streamToPromise(writeStream)
			.catch (e) ->
				console.error("Error while writing to #{params.image}", e)
				throw e
		.then ->
			updateConfig(params.image, params.to)
			.catch (e) ->
				console.error('Error updating configuration file', e, e.stack)
				throw e
		.nodeify(done)

module.exports = [ cp ]
