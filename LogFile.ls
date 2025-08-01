
  do ->

    { get-datestamp } = dependency 'unsafe.Date'
    { open-textstream, close-textstream, io-modes } = dependency 'os.filesystem.TextStream'
    { create-instance } = dependency 'reflection.Instance'
    { debug } = dependency 'os.shell.IO'
    { analyze-hresult } = dependency 'os.win32.com.HResult'
    { value-as-string } = dependency 'reflection.Value'
    { log-error } = dependency 'os.win32.com.EventLog'

    error-as-string = -> "#{ it.name }: #{ error.name } #{ curly-braces value-as-string analyze-hresult it }"

    log = -> debug it ; log-error it

    create-log-file = (log-name = 'log') ->

      filename = "#{ log-name }-#{ get-datestamp! }.log"

      text-stream = void

      create-instance do

        name: getter: -> log-name

        filename: getter: -> filename

        start: member: ->

          { success, result: stream, error } = open-text-stream filename, io-mode.appending

          if success then text-stream := stream else else log "Unable to start logfile #filename: #{ error-as-string error }"

          success

        write: member: ->

          { success, result: stream, error } = result-or-error -> text-stream.WriteLine it

          if success then text-stream := stream else else log "Unable to write message '#it' to logfile #filename: #{ error-as-string error }"

          success

        stop: member: ->

          { success, result: stream, error } = close-text-stream text-stream

          if success then text-stream := stream else else log "Unable to close logfile #filename: #{ error-as-string error }"

          success

    {
      create-log-file
    }