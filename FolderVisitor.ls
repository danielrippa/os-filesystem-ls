
  do ->

    { type } = dependency 'reflection.Type'
    { create-process } = dependency 'os.shell.Process'
    { double-quotes } = dependency 'unsafe.Circumfix'
    { string-as-lines } = dependency 'unsafe.Text'
    { trimmed-string } = dependency 'unsafe.Whitespace'
    { drop-array-items, map-array-items, each-array-item } = dependency 'unsafe.Array'
    { object-from-keys-and-values, each-object-member } = dependency 'unsafe.Object'
    { value-as-string } = dependency 'reflection.Value'
    { build-path } = dependency 'os.filesystem.Path'

    dir = -> create-process "%comspec%", <[ /c dir ]> ++ [ double-quotes it ] ++ <[ /ad /b ]>

    drop-empty-lines = (lines) -> drop-array-items lines, -> (trimmed-string it) is ''

    get-subfolders = (folderpath) ->

      builld-folder-path = (foldername) -> build-path [ folderpath, foldername ]

      { errorlevel, stdout: output }  = dir folderpath

      return [] if errorlevel isnt 0 ; return [] if output is null

      output

        |> string-as-lines
        |> drop-empty-lines
        |> map-array-items _ , builld-folder-path

    #

    visit-subfolders = (folderpath, callback) ->

      type '< String >' folderpath ; type '< Function >' callback

      subfolders = get-subfolders folderpath

      for subfolderpath in subfolders

        callback subfolderpath

        visit-subfolders subfolderpath, callback

    {
      visit-subfolders
    }