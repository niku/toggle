(require 'ert)

(require 'quick-toggle)

(defun my-fixture (body)
  (unwind-protect
      (progn
        ; set up part
        (let ((map #s(hash-table test equal
                                 data(
                                      "spec/lib/\\(.+\\)_spec\.rb" "lib/\1.rb"
                                      "lib/\\(.+\\)\.rb" "spec/lib/\1_spec.rb"
                                      ))))
          ; test part
          (funcall body))
          )
    (
     ; tear down part
     )))

(ert-deftest quick-toggle-find-matcher:when-matched-first ()
  (my-fixture
   (lambda ()
     (should (string=
              (quick-toggle-find-matcher map "/home/niku/projects/foo/lib/foo.rb")
              "lib/\\(.+\\)\.rb")))))

(ert-deftest quick-toggle-find-matcher:when-matched-second ()
  (my-fixture
   (lambda ()
     (should (string=
              (quick-toggle-find-matcher map "/home/niku/projects/foo/spec/lib/foo_spec.rb")
              "spec/lib/\\(.+\\)\_spec\.rb")))))

(ert-deftest quick-toggle-find-matcher:when-unmatched ()
  (my-fixture
   (lambda ()
     (should (eq
              (quick-toggle-find-matcher map "/home/niku/projects/foo/ext/bar.rb")
              nil)))))
