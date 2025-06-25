
  do ->

    { create-filesystem } = dependency 'os.win32.com.FileSystem'
    { build-path } = dependency 'os.filesystem.Path'
    { special-folders, special-folder } = dependency 'os.filesystem.Folder'
    { temporary-filename, delete-file } = dependency 'os.filesystem.File'
    { read-textfile, write-textfile } = dependency 'os.filesystem.TextFile'

    create-temporary-file = ->

      filepath = build-path [ (special-folder special-folders.temporary), temporary-filename! ]

      read-and-remove = ->

        try content = read-textfile @filepath ; return null unless content?

        try delete-file @filepath

        content

      { filepath, read-and-remove }

    create-temporary-file-with-content = (content) ->

      tempfile = create-temporary-file!

      try write-textfile tempfile.filepath, content
      catch => return null

      tempfile

    {
      create-temporary-file,
      create-temporary-file-with-content
    }