(defproject cli-matic "0.5.3"
  :description "Compact [sub]command line parsing library, for Clojure"
  :url "https://github.com/l3nz/cli-matic"
  :license {:name "Eclipse Public License, v2"
            :url  "http://www.eclipse.org/legal/epl-v20.html"}

  :aliases {"fix" ["cljfmt" "fix"]
            ; Kondo
            "clj-kondo" ["with-profile" "kondo"
                         "trampoline" "run" "-m"
                         "clj-kondo.main" "--" "--lint" "src/" "--cache" ".cli-kondo-cache"]
            "clj-kondo-test" ["with-profile" "kondo"
                              "trampoline" "run" "-m"
                              "clj-kondo.main" "--" "--lint" "test/" "--cache" ".cli-kondo-cache"]}

  :dependencies
  [[org.clojure/clojure "1.9.0" :scope "provided"]
   [org.clojure/clojurescript "1.10.439" :scope "provided"]
   [org.clojure/spec.alpha "0.1.143" :scope "provided"]
   [org.clojure/tools.cli "1.0.206"]
   [orchestra/orchestra "2019.02.06-1" :scope "provided"]
   [cheshire/cheshire "5.10.2" :scope "provided"]
   [clj-commons/clj-yaml "0.7.108" :scope "provided"]
   [org.clojure/core.async "0.5.527" :scope "provided"]
   ;[planck "2.22.0" :scope "provided"]
   [l3nz/planck "0.0.0" :scope "provided"]
   [expound/expound "0.9.0"]]

  ;:scm {:name "git"
  ;      ;; :tag "..."
  ;      :url  "https://github.com/l3nz/cli-matic"}

  :plugins [[lein-eftest "0.5.1"]
            [jonase/eastwood "0.2.5"]
            [lein-kibit "0.1.6"]
            [lein-cljfmt "0.6.6"]
            [lein-cljsbuild "1.1.7"]
            [lein-doo "0.1.11"]
            [lein-ancient "0.6.15"]
            [lein-cloverage "1.1.2"]
            [lein-ancient "0.6.15"]]

  :profiles {:test
             {:dependencies [[cljc.java-time "0.1.11"]]}
             :kondo
             {:dependencies [[org.clojure/clojure "1.10.1"]
                             [clj-kondo "2022.03.09"]]}}

  :cljsbuild
  {:test-commands {"unit-tests" ["node" "target/unit-tests.js"]}
   :builds
   {:tests
    {:source-paths   ["src" "test"]
     :notify-command ["node" "target/unit-tests.js"]
     :compiler       {:output-to     "target/unit-tests.js"
                      :optimizations :none
                      :target        :nodejs
                      :main          cli-matic.cljs-runner}}
    :production
    {:source-paths ["src"]
     :compiler     {:output-to     "target/production.js"
                    :optimizations :advanced}}}}

  :deploy-repositories
  [["clojars" {:sign-releases false :url "https://clojars.org/repo"}]
   ["snapshots" {:sign-releases false :url "https://clojars.org/repo"}]])

