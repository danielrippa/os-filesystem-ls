
  do ->

    { create-filesystem } = dependency 'os.win32.com.FileSystem'
    { trimmed-string, whitespace-as-separator } = dependency 'unsafe.Whitespace'
    { type } = dependency 'reflection.Type'

    fs = create-filesystem!

    path-separator = fs.BuildPath ' ', ' ' |> trimmed-string

    build-path = (string-array) -> type '< Array >' string-array ; string-array * "#path-separator"

    name-from-path = (path) -> type '< String >' path ; path |> fs.GetBaseName

    parent-folderpath = (path) -> type '< String >' path ; path |> fs.GetParentFolderName

    {
      path-separator,
      build-path,
      name-from-path,
      parent-folderpath
    }