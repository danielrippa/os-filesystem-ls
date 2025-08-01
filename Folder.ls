
  do ->

    { create-filesystem } = dependency 'os.win32.com.FileSystem'
    { type } = dependency 'reflection.Type'

    fs = create-filesystem!

    special-folders = windows: 0, system: 1, temporary: 2

    special-folder = (folderspec) -> type '< Number >' folderspec ; fs.GetSpecialFolder folderspec

    folder-exists = (folderpath) -> type '< String >' folderpath ; folderpath |> fs.FolderExists

    folder-not-found = -> new Error "Folder '#it' not found"

    folderpath-found = (folderpath) -> throw folder-not-found folderpath unless folder-exists folderpath ; folderpath

    {
      folder-exists, folderpath-found,
      special-folders, special-folder
    }