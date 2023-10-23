(in-package #:org.shirakumo.fraf.theora)

(docs:define-docs
  (type theora-error
    "Condition signalled when a Theora API call fails.

See FILE
See CODE")
  
  (function file
    "Accesses the underlying file or source that caused the error.

See THEORA-ERROR (type)
See FILE (type)")
  
  (function code
    "Accesses the returned error code.

See THEORA-ERROR (type)")
  
  (function init
    "Initialises and loads the libtheorafile library.

It is safe to call this function multiple times.")
  
  (type file
    "Representation of an ogg/theora video file.

Creating an instance of FILE will automatically call INIT for you.
When creating an instance, you must pass the SOURCE initarg to specify
the data source of the file.

SOURCE may be one of the following:

  PATHNAME
  STRING
  ORG.SHIRAKUMO.MEMORY-REGIONS:MEMORY-REGION
  VECTOR (UNSIGNED-BYTE 8)

If you have a raw CFFI:FOREIGN-POINTER, you should use
WITH-MEMORY-REGION to wrap it in a memory region during the file
construction.

If reading the file fails, an error of type THEORA-ERROR is signalled
and everything is cleaned up. Otherwise, the FILE instance will
immediately contain all the metadata information about the video and
audio data and be ready for reading.

Once you are done using the file, you must call FREE on it.

See WIDTH
See HEIGHT
See FRAMERATE
See PIXEL-FORMAT
See CHANNELS
See SAMPLERATE
See AUDIO-TRACK
See VIDEO-TRACK
See FREE
See OPEN
See RESET
See DONE-P
See READ-VIDEO
SEe READ-AUDIO")
  
  (function width
    "Returns the width of the video in pixels.

Will return NIL if there is no video stream.

See FILE (type)")
  
  (function height
    "Returns the height of the video in pixels.

Will return NIL if there is no video stream.

See FILE (type)")
  
  (function framerate
    "Returns the framerate of the video in frames per second.

Will return NIL if there is no video stream.

See FILE (type)")
  
  (function pixel-format
    "Returns the pixel format of the contained video data.

PIXEL-FORMAT may be one of the following:

  :420 --- UV width and height subsampling
  :422 --- UV width subsampling
  :444 --- no subsampling

Will return NIL if there is no video stream.

See FILE (type)")
  
  (function channels
    "Returns the number of channels of the contained audio data.

Will return NIL if there is no audio stream.

See FILE (type)")
  
  (function samplerate
    "Returns the samplerate of the audio in samples per second.

Will return NIL if there is no audio stream.

See FILE (type)")
  
  (function audio-track
    "Accesses the audio track currently in use.

This defaults to 0 if there are audio tracks, or NIL if there are
none. If switching to the requested track is not possible, an error of
type THEORA-ERROR is signalled.

Setting this is NOT thread-safe.

See FILE (type)
See THEORA-ERROR (type)")
  
  (function video-track
    "Accesses the video track currently in use.

This defaults to 0 if there are video tracks, or NIL if there are
none. If switching to the requested track is not possible, an error of
type THEORA-ERROR is signalled.

Setting this is NOT thread-safe.

See FILE (type)
See THEORA-ERROR (type)")
  
  (function free
    "Frees the file and all associated resources.

It is safe to call this function multiple times.

Using the FILE instance after freeing it in any other way leads to
undefined behaviour.

See FILE (type)")

  (function open
    "Open an ogg/theora video input.

Returns the new FILE instance if successful, signals an error
otherwise. This is equivalent to:

  (MAKE-INSTANCE 'FILE :SOURCE source)

See THEORA-ERROR (type)
See FILE (type)")
  
  (function reset
    "Resets the playback back to the start.

See FILE (type)")
  
  (function done-p
    "Returns whether the playback has reached its end.

See FILE (type)")
  
  (function read-video
    "Reads video frames to the specified buffer.

Returns the number of read frames.

The data is encoded as sequential Y U V planes, meaning each frame
consists of three planes. The size of each plane is determined by the
PIXEL-FORMAT. Each plane is 8 bits per pixel.

This is NOT thread-safe.

See FILE (type)")
  
  (function read-audio
    "Reads audio samples to the specified buffer.

Returns the number of read samples. Note that this is in samples, not
frames.

The data is encoded as single-floats, interleaved. Meaning each audio
frame consists of CHANNELS number of samples, each of which being a
float in the range of [-1,+1].

If SAMPLES is specified, reads at most that many samples.

This is NOT thread-safe.

See FILE (type)"))
