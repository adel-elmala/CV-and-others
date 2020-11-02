;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1

;; CHANGE (put your solutions here)

(define (racketlist->mupllist rlist)
  (cond [(null? rlist) (aunit)]
        [#t 
         (let ([hd (car rlist)]
               [tl (cdr rlist)])
           (cond
             [(list? hd) (apair (racketlist->mupllist hd)(racketlist->mupllist tl))]
             [(pair? hd)
              (let ([first (car hd)]
                    [second (cdr hd)])

                (apair (apair first second)(racketlist->mupllist tl)))]
             [#t (apair hd (racketlist->mupllist tl))] ))]))


(define (mupllist->racketlist mlist)
  (cond [(aunit? mlist) null]
        [#t
         (let ([hd (apair-e1 mlist)]
               [tl (apair-e2 mlist)])
           (cons hd (mupllist->racketlist tl))
           )
         ]))





;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        ;; CHANGE add more cases here
        [(aunit? e) e]
        [(int? e) e] ;; is already  a value 
        [(fun? e) (closure env e)] ;; return a closure holding the function and the current env.
        [(closure? e) e]
        [(ifgreater? e) (let ([v1 (eval-under-env (ifgreater-e1 e) env) ]
                              [v2 (eval-under-env (ifgreater-e2 e) env) ])
                          (if (and (int? v1) (int? v2))
                              (let ([i1 (int-num v1)]
                                    [i2 (int-num v2)])
                                (cond [(> i1 i2) (eval-under-env (ifgreater-e3 e) env)]
                                      [#t (eval-under-env (ifgreater-e4 e) env)]))
                              (error "MUPL ifgreater applied to non-number")))]

        [(mlet? e) (letrec ([name (mlet-var e)] ;; is a racket string as the preconditions says, so no need to check 
                            [v1 (eval-under-env (mlet-e e) env)] 
                            [new-env (cons (cons name v1) env)]) ;; extend the current env with the variable binding
                     (eval-under-env (mlet-body e) new-env))]

        [(call? e) (let ([cfun (eval-under-env (call-funexp e) env)] 
                         [actual (eval-under-env (call-actual e) env)])
                     (if (closure? cfun)
                         (letrec ([fun-env (closure-env cfun)] ;; should extend it to hold the actual paramater binded to the fun formal par. + the fun name to the closure for recursion 
                                  [fun (closure-fun cfun)]
                                  [fun-name (fun-nameopt fun)]
                                  [fun-param (fun-formal fun)]
                                  [body (fun-body fun)]) 
                           (if fun-name ;; not fasle 
                               (let ([new-env (cons (cons fun-param actual) (cons (cons fun-name cfun) fun-env))])
                                 (eval-under-env body new-env))
                           
                               (let ([new-env (cons (cons fun-param actual) fun-env)])
                                 (eval-under-env body new-env))

                               ))

                         
                         (error (format "MUPL call on a non-function: ~v" cfun))
                         ))]

        [(apair? e) (let ([e1 (eval-under-env (apair-e1 e) env)]
                          [e2 (eval-under-env (apair-e2 e) env)])

                      (apair e1 e2)

                      )]

        [(fst? e) (let ([exp (eval-under-env (fst-e e) env)])
                    (if (apair? exp)
                        (apair-e1 exp)
                        (error (format "MUPL fst applied on a non-apair: ~v" exp))))
                  ]

        [(snd? e) (let ([exp (eval-under-env (snd-e e) env)])
                    (if (apair? exp)
                        (apair-e2 exp)
                        (error (format "MUPL fst applied on a non-apair: ~v" exp))))
                  ]

        [(isaunit? e) (let ([exp (eval-under-env (isaunit-e e) env)])
                        (if (aunit? exp)
                            (int 1)
                            (int 0)))]     
        


        
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

(define (ifaunit e1 e2 e3) (ifgreater (isaunit e1) (int 0) e2 e3))

;; i think it would work if i added a string construct to MUPL
;; Not Complete
;;(define (mlet* lstlst e2)
;;  (mlet "mlst" (racketlist->mupllist lstlst)
;;        (fun  "mlt" "lst"
;;              (ifaunit (var "lst")
;;                       e2
;;                      (mlet (fst (fst (var "lst"))) (snd (fst (var "lst"))) (call ;;(var "mlt") (snd (var "lst")))))
;;
;;              )))

(define (mlet* lstlst e2)
  (if (null? lstlst)
      e2 
      (mlet (car (car lstlst)) (cdr (car lstlst)) (mlet* (cdr lstlst) e2)))
  )

(define (ifeq e1 e2 e3 e4)
  (mlet* (list (cons "_x" e1) (cons "_y" e2))
         (ifgreater (var "_x") (var "_y") e4 (ifgreater (var "_y") (var "_x") e4 e3)))

  )

;; Problem 4

(define mupl-map
  (fun "map" "func"
       (fun "helper" "mlst"
            (ifaunit (var "mlst")
                     (aunit)
                     (mlet* (list (cons "hd" (fst (var "mlst"))) (cons "tl" (snd (var "mlst"))))
                   
                            (apair (call (var "func") (var "hd"))  (call (var "helper") (var "tl")))
                            )
                     )
            )
       )
  )

(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun #f "int" (call (var "map") (fun #f "xs"(add (var "xs") (var "int")))))
        ))

;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
