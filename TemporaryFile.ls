
  do ->

    { create-filesystem } = dependency 'os.win32.com.FileSystem'
    { build-path } = dependency 'os.filesystem.Path'
    { special-folders, special-folder, folder-exists } = dependency 'os.filesystem.Folder'
    { temporary-filename, delete-file } = dependency 'os.filesystem.File'
    { temporary-folderpath } = dependency 'os.filesystem.Path'
    { read-textfile, write-textfile } = dependency 'os.filesystem.TextFile'
    { each-env-var, expand } = dependency 'os.shell.EnvVar'
    { lower-case } = dependency 'unsafe.StringCase'
    { debug } = dependency 'os.shell.IO'
    { value-as-string } = dependency 'reflection.Value'

    temporary-folderpath = ->

      is-valid-userprofile = folder-exists expand '%userprofile%'

      folderpath = void ; folder-names = <[ temp tmp ]>

      each-env-var 'user', (name, value) ->

        if folderpath is void

          var-name = lower-case name

          if var-name in folder-names

            if folder-exists expand value

              folderpath := expand value

      if folderpath is void

        folderpath = special-folder special-folders.temporary .Path

      folderpath

    create-temporary-file = ->

      filepath = build-path [ temporary-folderpath!, temporary-filename! ]

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