;;; GNU Guix package definition for InfernoCog (Inferno OS)
;;; This package provides the Inferno distributed operating system.

(use-modules (guix packages)
             (guix download)
             (guix build-system gnu)
             (guix build-system trivial)
             (guix licenses)
             (gnu packages)
             (gnu packages base)
             (gnu packages gcc)
             (gnu packages xorg)
             (gnu packages fontutils)
             (gnu packages compression))

(define-public infernocog-base
  (package
    (name "infernocog-base")
    (version "1.0.0")
    (source (local-file "." "inferno-source" #:recursive? #t
                        #:select? (lambda (file stat)
                                    (not (or (string-contains file ".git")
                                             (string-contains file "Linux/386"))))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f  ; No test suite
       #:make-flags (list (string-append "ROOT=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)  ; No configure script
         (add-before 'build 'setup-build-environment
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               ;; Set up the build environment
               (setenv "ROOT" (getcwd))
               (setenv "SYSHOST" "Linux")
               (setenv "SYSTARG" "Linux")
               (setenv "OBJTYPE" "386")
               
               ;; Configure mkconfig for Linux build
               (substitute* "mkconfig"
                 (("ROOT=/usr/inferno") (string-append "ROOT=" (getcwd)))
                 (("SYSHOST=Plan9") "SYSHOST=Linux")
                 (("SYSTARG=\\$SYSHOST") "SYSTARG=Linux")
                 (("OBJTYPE=\\$objtype") "OBJTYPE=386"))
               
               ;; Remove 32-bit flags for compatibility with 64-bit systems
               (substitute* "mkfiles/mkfile-Linux-386"
                 (("-m32") ""))
               
               ;; Set up platform include directory
               (mkdir-p "Linux/386/include")
               (copy-recursively "include" "Linux/386/include")
               
               ;; Copy lib9.h from another platform as template
               (copy-file "Linux/power/include/lib9.h" "Linux/386/include/lib9.h")
               #t)))
         (replace 'build
           (lambda* (#:key make-flags #:allow-other-keys)
             ;; Build mk tool first
             (invoke "sh" "makemk.sh")
             
             ;; Add mk to PATH
             (setenv "PATH" (string-append (getcwd) "/Linux/386/bin:"
                                           (getenv "PATH")))
             
             ;; Build essential libraries only to avoid segfault issues
             (invoke "Linux/386/bin/mk" "lib9/install")
             (invoke "Linux/386/bin/mk" "libbio/install")
             (invoke "Linux/386/bin/mk" "libmp/install")
             (invoke "Linux/386/bin/mk" "libsec/install")
             (invoke "Linux/386/bin/mk" "libmath/install")
             (invoke "Linux/386/bin/mk" "utils/iyacc/install")))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               ;; Install binaries
               (when (file-exists? "Linux/386/bin")
                 (copy-recursively "Linux/386/bin" 
                                   (string-append out "/bin")))
               ;; Install libraries
               (when (file-exists? "Linux/386/lib")
                 (copy-recursively "Linux/386/lib"
                                   (string-append out "/lib")))
               ;; Install include files
               (copy-recursively "include"
                                 (string-append out "/include"))
               ;; Install platform include files
               (when (file-exists? "Linux/386/include")
                 (copy-recursively "Linux/386/include"
                                   (string-append out "/include/platform")))
               ;; Install man pages
               (when (file-exists? "man")
                 (copy-recursively "man"
                                   (string-append out "/share/man")))
               ;; Install documentation
               (mkdir-p (string-append out "/share/doc/infernocog-base"))
               (install-file "README.md" (string-append out "/share/doc/infernocog-base"))
               (install-file "INSTALL" (string-append out "/share/doc/infernocog-base"))
               #t))))))
    (native-inputs
     `(("gcc" ,gcc)))
    (inputs
     `(("fontconfig" ,fontconfig)
       ("freetype" ,freetype)))
    (synopsis "Inferno distributed operating system")
    (description
     "Inferno is a distributed operating system originally developed at Bell Labs.
It provides a concurrent programming environment with the Limbo language and
a portable virtual machine.  This package includes the hosted version that
runs under Linux, providing the essential libraries and tools for Inferno
development.")
    (home-page "https://github.com/K-Oz/infernocog")
    (license (list gpl2+ lgpl2.1+))))

;; Return the base package for 'guix install -f guix.scm'
infernocog-base