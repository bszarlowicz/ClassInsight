# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "jquery", to: "jquery.min.js", preload: true
pin "jquery_ujs", to: "jquery_ujs.js", preload: true
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.2/lib/index.js"
pin "select2", to: "select2.js", preload: true
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "slim-select" # @2.9.0
pin_all_from "app/javascript/controllers", under: "controllers"
pin "tui-calendar", to: "https://ga.jspm.io/npm:tui-calendar@1.15.3/dist/tui-calendar.js"
pin "tui-code-snippet", to: "https://ga.jspm.io/npm:tui-code-snippet@1.5.2/dist/tui-code-snippet.js"
pin "tui-date-picker", to: "https://ga.jspm.io/npm:tui-date-picker@4.3.3/dist/tui-date-picker.js"
pin "tui-time-picker", to: "https://ga.jspm.io/npm:tui-time-picker@2.1.6/dist/tui-time-picker.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.1.3-4/app/assets/javascripts/rails-ujs.esm.js"
