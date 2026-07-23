; extends

; ---------------------------------------------------------------------------
; Embedded JS/JSX in <script> tags with non-standard MIME types.
;
; The bundled html query derives the injected language from the `type`
; attribute via `set-lang-from-mimetype!`, which splits on "/" and uses the
; last segment. For `type="text/babel"` that yields "babel" — a parser that
; does not exist — so the block silently loses all highlighting.
;
; Map the common transpiler/JSX MIME types to the `tsx` parser, which parses
; JS + JSX + TS supersets and gives correct highlighting for React prototypes
; served via @babel/standalone, esbuild, etc.
; ---------------------------------------------------------------------------
(script_element
  (start_tag
    (attribute
      (attribute_name) @_attr
      (#eq? @_attr "type")
      (quoted_attribute_value
        (attribute_value) @_type
        (#any-of? @_type
          "text/babel"
          "text/jsx"
          "text/tsx"
          "text/typescript"
          "text/typescript-jsx"
          "application/babel"
          "application/jsx"))))
  (raw_text) @injection.content
  (#set! injection.language "tsx"))
