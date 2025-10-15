(export format-after-prompt)

(claim format-after-prompt
  (-> string? string? string?))

(define (format-after-prompt prompt block)
  (= (cons first-line rest-lines)
     (string-lines block))
  (= indentation (string-repeat (string-length prompt) " "))
  (= new-lines
     (cons (string-append prompt first-line)
           (list-map (string-append indentation) rest-lines)))
  (string-join "\n" new-lines))
