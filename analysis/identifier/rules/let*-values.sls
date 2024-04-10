(library (scheme-langserver analysis identifier rules let*-values)
  (export let*-values-process)
  (import 
    (chezscheme) 
    (ufo-match)

    (scheme-langserver util try)

    (scheme-langserver analysis identifier reference)
    (scheme-langserver analysis identifier rules let)

    (scheme-langserver virtual-file-system index-node)
    (scheme-langserver virtual-file-system document)
    (scheme-langserver virtual-file-system file-node))

; reference-identifier-type include 
; continuation
(define (let*-values-process root-file-node document index-node)
  (let* ([ann (index-node-datum/annotations index-node)]
      [expression (annotation-stripped ann)])
    (try
      (match expression
        [(_ (((? symbol? identifier) no-use ... ) **1 ) fuzzy ... ) 
          (let loop ([include '()] 
                [rest (index-node-children (cadr (index-node-children index-node)))])
            (if (not (null? rest))
              (let* ([identifier-parent-index-node (car rest)]
                    [identifier-index-node (car (index-node-children identifier-parent-index-node))]
                    [reference-list (let-parameter-process index-node identifier-index-node index-node '() document 'continuation)])
                (index-node-excluded-references-set! 
                  identifier-parent-index-node
                  (append 
                    (index-node-excluded-references identifier-parent-index-node)
                    reference-list))
                (index-node-references-import-in-this-node-set! 
                  identifier-parent-index-node
                  (sort-identifier-references
                    (append 
                      (index-node-references-import-in-this-node identifier-parent-index-node)
                      include)))
                (loop (append include reference-list) (cdr rest)))))]
        [else '()])
      (except c
        [else '()]))))
)
