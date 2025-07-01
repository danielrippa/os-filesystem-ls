
  do ->

    { read-textfile-lines } = dependency 'os.filesystem.TextFile'
    { string-interval, string-split-by-first-segment } = dependency 'unsafe.String'
    { trimmed-string } = dependency 'unsafe.Whitespace'
    { each-array-item, keep-array-items } = dependency 'unsafe.Array'
    { camel-case } = dependency 'unsafe.StringCase'
    { file-exists } = dependency 'os.filesystem.File'

    is-member-line = ->

      line = trimmed-string it ; return no if line is ''

      initial-char = line `string-interval` [ 0, 1] ; return no if initial-char is '#'

      yes

    read-objectfile = (filepath) ->

      return null unless file-exists filepath

      member-lines = read-textfile-lines filepath |> keep-array-items _ , is-member-line

      object = {}

      each-array-item member-lines, (line) ->

        [ member-name, member-value ] = line `string-split-by-first-segment` ' '

        return if member-value is void

        object[ camel-case member-name ] := member-value

      object

    {
      read-objectfile
    }