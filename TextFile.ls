
  do ->

    { create-filesystem } = dependency 'os.win32.com.FileSystem'
    { string-as-lines } = dependency 'unsafe.Text'

    fs = create-filesystem!

    io-modes = reading: 1, writing: 2, appending: 8

    open-textstream = (filepath, mode) ->

      # try type '< String >' filepath ; type '< Number >' mode
      # catch => WScript.Echo e.message

      fs.OpenTextFile filepath, mode, yes

    use-stream = (stream, fn) -> try result = fn stream ; stream.close! ; return result

    read-textfile = (filepath) ->

      open-textstream filepath, io-modes.reading |> use-stream _ , (.ReadAll!)

    read-textfile-lines = (filepath) ->

      read-textfile filepath |> string-as-lines

    write-textfile = (filepath, content) ->

      open-textstream filepath, io-modes.writing |> use-stream _ , (.Write content)

    {
      read-textfile, read-textfile-lines,
      write-textfile
    }