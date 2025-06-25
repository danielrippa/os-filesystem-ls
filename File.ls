
  do ->

    { create-filesystem } = dependency 'os.win32.com.FileSystem'

    fs = create-filesystem!

    temporary-filename = -> fs.GetTempName!

    file-exists = -> fs.FileExists it

    {
      temporary-filename,
      file-exists
    }