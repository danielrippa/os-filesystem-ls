
  do ->

    { create-filesystem } = dependency 'os.win32.com.FileSystem'
    { build-path } = dependency 'os.filesystem.Path'
    { special-folders, special-folder, folder-exists } = dependency 'os.filesystem.Folder'
    { temporary-filename, delete-file } = dependency 'os.filesystem.File'
    { temporary-folderpath } = dependency 'os.filesystem.Path'
    { read-textfile, write-textfile } = dependency 'os.filesystem.TextFile'
    { each-env-var, expand } = dependency 'os.shell.EnvVar'
    { lower-case } = dependency 'unsafe.StringCase'
    { knwon-folder-by-csidl, known-folder-csidls } = dependency 'os.filesystem.KnownFolder'

    temporary-folderpath = void

    set-temporary-folderpath = (value) ->

      return no if value is void

      temporary-folderpath := value ; yes

    appdata-local-folderpath = ->

      folderpath = known-folder-by-csidl known-folder-csidls.local-app-data

      for suffix in [ 'Low', '' ]

        "#folderpath#suffix" => return .. if folder-exists ..

      void

    special-temporary-folderpath = ->

      special-folders

        windows-folderpath = special-folder ..windows

        folderpath = special-folder ..temporary

      return void if folderpath is windows-folderpath

      folderpath

    user-env-var-temp-folderpath = ->

      folderpath = void ; names = <[ temp tmp ]>

      each-env-var 'user', (name, value) ->

        env-var = lower-case name ; return unless env-var in names

        if folder-exists value => folderpath := value ; return no

      folderpath

    get-temporary-folderpath = ->

      temporary-folderpath => return .. unless .. is void

      appdata-local-folderpath! => return .. if set-temporary-folderpath ..

      special-temporary-folderpath! => return .. if set-temporary-folderpath ..

      user-env-var-temp-folderpath! => return .. if set-temporary-folderpath ..

      void

    create-temporary-file = ->

      folderpath = get-temporary-folderpath!

      throw new Error "Unable to locate user temp folderpath for TemporaryFile" \
        if folderpath is void

      filepath = build-path [ folderpath, temporary-filename! ]

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
      get-temporary-folderpath,
      create-temporary-file,
      create-temporary-file-with-content
    }