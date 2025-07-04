
  do ->

    { get-namespace-by-csidl } = dependency 'os.win32.com.ShellNamespace'
    { invalid-value-error } = dependency 'reflection.ValueError'
    { object-member-pairs } = dependency 'unsafe.Object'
    { map-array-items: map } = dependency 'unsafe.Array'
    { folder-exists } = dependency 'os.filesystem.Folder'

    known-folder-csidls =

      admin-tools: 0x30
      alt-startup: 0x1d
      app-data: 0x1a
      bit-bucket: 0x0a
      desktop: 0x00
      desktop-directory: 0x10
      profile: 0x28
      program-files: 0x26
      program-files-x86: 0x2a
      programs: 0x02
      send-to: 0x09
      start-menu: 0x0b
      start-up: 0x07
      system: 0x25
      system-x86: 0x29
      windows: 0x24

      local-app-data: 0x1c

      program-files-common: 0x28
      program-files-common-x86: 0x2c

      common-app-data: 0x23
      common-desktop-directory: 0x19
      common-documents: 0x2e
      common-favorites: 0x1f
      common-music: 0x35
      common-pictures: 0x36
      common-programs: 0x17
      common-start-menu: 0x16
      common-start-up: 0x18

    csidl-as-string = ([ key, value ]) -> "#value (#key)"

    valid-csidl-values = -> known-folder-csidls |> object-member-pairs |> map _ , csidl-as-string

    valid-csidl = -> invalid-value-error it, "Valid CSIDL values are: #{ valid-csidl-values! * ', ' }"

    get-known-folderpath-by-csidl = (csidl) -> get-namespace valid-csidl csidl .Self.Path

    {
      known-folder-csidls,
      get-known-folderpath-by-csidl,
    }