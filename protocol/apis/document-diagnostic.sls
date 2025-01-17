(library (scheme-langserver protocol apis document-diagnostic)
  (export 
    diagnostic)
  (import 
    (chezscheme) 

    (scheme-langserver analysis workspace)
    (scheme-langserver analysis identifier reference)
    (scheme-langserver analysis type substitutions util)
    (scheme-langserver analysis type domain-specific-language interpreter)

    (scheme-langserver protocol alist-access-object)

    (scheme-langserver util natural-order-compare)
    (scheme-langserver util association)
    (scheme-langserver util path) 
    (scheme-langserver util try) 
    (scheme-langserver util dedupe)

    (scheme-langserver virtual-file-system index-node)
    (scheme-langserver virtual-file-system document)
    (scheme-langserver virtual-file-system file-node)

    (only (srfi :13 strings) string-replace))

; https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_pullDiagnostics
(define (diagnostic workspace params)
  '()
  ;TODO
  ; (let* ([text-document (alist->text-document (assq-ref params 'textDocument))]
  ;     [path (uri->path (text-document-uri text-document))]
  ;     [file-node (walk-file (workspace-file-node workspace) path)]
  ;     [document (file-node-document file-node)]
  ;     [text (document-text document)]
  ;     [substitution-list (document-substitution-list document)])
  ;   (try
  ;     ;I'd only check leaf index-node
  ;     (vector-map 
  ;       (lambda (index-node)
  ;         (let ([s (index-node-start index-node)]
  ;             [e (index-node-end index-node)]
  ;             [types (dedupe (filter pure-identifier-reference-misture? (type:interpret-result-list (index-node-variable index-node) substitution-list)))])
  ;         (private-make-diagnostic s e 3 
  ;             (fold-left 
  ;               (lambda (remain current) 
  ;                 (if (equal? "" remain)
  ;                   current
  ;                   (string-append remain "\n" current)))
  ;               ""
  ;               (map type->string types))
  ;             text)))
  ;       (list->vector (find-leaves (document-index-node-list document))))
  ;     (except e [else '()])))
      )

; https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#diagnostic
; https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#diagnosticSeverity
(define (private-make-diagnostic range-start range-end severity message text)
  (make-alist 
    'range 
    (range->alist 
      (make-range 
        (int+text->position range-start text)
        (int+text->position range-end text))) 
    'severity severity 
    'message message))
)