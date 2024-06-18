;; extends

; vue2? templates
(pair 
  key: ((property_identifier) @key 
    (#eq? @key "template"))
  value: (
    (_) @injection.content
    (#set! injection.include-children)
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "vue")))
