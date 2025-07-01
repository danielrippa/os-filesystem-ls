
  do ->

    { create-filesystem } = dependency 'os.win32.com.FileSystem'
    { build-path, path-separator } = dependency 'os.filesystem.Path'
    { string-split-by-first-segment } = dependency 'unsafe.String'

    fs = create-filesystem!

    temporary-filename = -> fs.GetTempName!

    file-exists = -> fs.FileExists it

    compose-filename = (folder-path, filename, extension) -> build-path [ folder-path, "#filename.#extension" ]

    as-drive-filepath = ([ prefix, suffix ])->

      [ drive, filepath ] = if suffix is void
        [ void, prefix ]
      else
        [ prefix, suffix ]

      { drive, filepath }

    drive-filepath = (string) -> string `string-split-by-first-segment` ':' |> as-drive-filepath

    drive-paths-filename = ({ drive, filepath }) -> filepath `string-split-by-last-segment` path-separator |> ([ folderpath, filename ]) -> { drive, filepath, folderpath, filename }

    basename-extension = (string) -> [ basename, extension ] = string `string-split-by-last-segment` '.' ; { basename, extension }

    drive-paths-filename-extension = -> { filename } = it ; { basename, extension } = basename-extension filename ; it <<< { basename, extension }

    decompose-filepath = (filepath) -> filepath |> drive-filepath |> drive-paths-filename |> drive-paths-filename-extension

    {
      temporary-filename,
      file-exists,
      compose-filename
    }