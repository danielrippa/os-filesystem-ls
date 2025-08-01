
  do ->

    { create-filesystem } = dependency 'os.win32.com.FileSystem'
    { result-or-error } = dependency 'flow.Conditional'

    fs = create-filesystem! ; io-modes = reading: 1, writing: 2, appending: 8

    open-textstream = (filepath, mode) -> result-or-error -> fs.OpenTextFile filepath, mode, yes

    use-textstream = (stream, fn) -> result-or-error -> result = fn stream ; stream.Close! ; return result

    close-textstream = -> result-or-error -> it.Close!

    {
      io-modes,
      open-textstream, use-textstream, close-textstream
    }