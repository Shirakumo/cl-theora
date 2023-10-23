(defpackage #:org.shirakumo.fraf.theora.cffi
  (:use #:cl)
  (:shadow #:open #:close #:error)
  (:export
   #:libtheorafile
   #:error
   #:pixel-format
   #:seek
   #:callbacks
   #:callbacks-read-func
   #:callbacks-seek-func
   #:callbacks-close-func
   #:page
   #:page-header
   #:page-header-length
   #:page-body
   #:page-body-length
   #:sync-state
   #:sync-state-data
   #:sync-state-storage
   #:sync-state-fill
   #:sync-state-returned
   #:sync-state-unsynced
   #:sync-state-header-bytes
   #:sync-state-body-bytes
   #:dsp-state
   #:dsp-state-analysis-p
   #:dsp-state-info
   #:dsp-state-pcm
   #:dsp-state-pcm-ret
   #:dsp-state-pcm-storage
   #:dsp-state-pcm-returned
   #:dsp-state-pre-extrapolate
   #:dsp-state-eof-flag
   #:dsp-state-lw
   #:dsp-state-w
   #:dsp-state-nw
   #:dsp-state-center-w
   #:dsp-state-granule-pos
   #:dsp-state-sequence
   #:dsp-state-glue-bits
   #:dsp-state-time-bits
   #:dsp-state-floor-bits
   #:dsp-state-res-bits
   #:dsp-state-backend-state
   #:pack-buffer
   #:pack-buffer-end-byte
   #:pack-buffer-end-bit
   #:pack-buffer-buffer
   #:pack-buffer-ptr
   #:pack-buffer-storage
   #:vorbis-block
   #:vorbis-block-pcm
   #:vorbis-block-buffer
   #:vorbis-block-lw
   #:vorbis-block-w
   #:vorbis-block-nw
   #:vorbis-block-pcm-end
   #:vorbis-block-mode
   #:vorbis-block-eof-flag
   #:vorbis-block-granule-pos
   #:vorbis-block-sequence
   #:vorbis-block-dsp-state
   #:vorbis-block-local-store
   #:vorbis-block-local-top
   #:vorbis-block-local-alloc
   #:vorbis-block-total-use
   #:vorbis-block-reap
   #:vorbis-block-glue-bits
   #:vorbis-block-time-bits
   #:vorbis-block-floor-bits
   #:vorbis-block-res-bits
   #:vorbis-block-internal
   #:file
   #:file-sync-state
   #:file-page
   #:file-eos
   #:file-t-packets
   #:file-v-packets
   #:file-t-stream
   #:file-v-stream
   #:file-t-info
   #:file-v-info
   #:file-t-comment
   #:file-v-comment
   #:file-v-tracks
   #:file-v-track
   #:file-t-tracks
   #:file-t-track
   #:file-t-dec
   #:file-v-dsp-init
   #:file-v-dsp
   #:file-v-block-init
   #:file-v-block
   #:file-callbacks
   #:file-data-source
   #:open-callbacks
   #:open
   #:close
   #:has-video
   #:has-audio
   #:video-info
   #:audio-info
   #:eos
   #:reset
   #:read-video
   #:read-audio
   #:set-audio-track
   #:set-video-track))

(defpackage #:org.shirakumo.fraf.theora
  (:use #:cl)
  (:local-nicknames
   (#:theora #:org.shirakumo.fraf.theora.cffi)
   (#:mem #:org.shirakumo.memory-regions))
  (:export
   #:theora-error
   #:file
   #:code
   #:init
   #:file
   #:width
   #:height
   #:framerate
   #:pixel-format
   #:channels
   #:samplerate
   #:audio-track
   #:video-track
   #:free
   #:reset
   #:done-p
   #:read-video
   #:read-audio))
