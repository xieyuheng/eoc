(import-all "format-after-prompt")

(write
 (format-after-prompt
  "=> "
  (pretty 30 [[1 2 3]
              [4 5 6]
              [7 8 9]])))
