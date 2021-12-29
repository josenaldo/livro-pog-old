var App = (function () {
    var self = this;
    self.theme = 'darkly';
    self.font_name = 'sans'
    self.font_size = 6

    self.supports_html5_storage = function () {
        try {
            return "localStorage" in window && window["localStorage"] !== null;
        } catch (e) {
            return false;
        }
    };

    self.set_theme = function (theme_name) {
        let theme = "/assets/css/theme/" + theme_name + ".css";
        $('link[href*="assets/css/theme"]').attr("href", theme);

        self.theme = theme_name;
        let supports_storage = supports_html5_storage();

        if (supports_storage) {
            localStorage.theme = theme_name;
        }
    };

    self.set_font_name = function (font_name) {
        let font = "/assets/css/font/" + font_name + ".css";
        $('link[href*="assets/css/font"]').attr("href", font);

        self.font_name = font_name;
        let supports_storage = supports_html5_storage();

        if (supports_storage) {
            localStorage.font_name = font_name;
        }
    }

    self.get_font_size_class = function() {
        var classList = $("#main-text").attr("class");
        var classArr = classList.split(/\s+/);

        fontSizeClass = '';

        $.each(classArr, function(index, value){
            if(value.indexOf("fs-") == 0){
                fontSizeClass = value;
            }
        });

        if(fontSizeClass === '') {
            fontSizeClass = 'fs-6';
        }

        return fontSizeClass;
    }

    self.set_font_size = function (font_size) {

        let current_font_size_class = self.get_font_size_class();
        let font_style = "fs-" + font_size;

        $('#main-text').removeClass(current_font_size_class);
        $('#main-text').addClass(font_style);

        self.font_size = font_size;
        let supports_storage = supports_html5_storage();

        if (supports_storage) {
            localStorage.font_size = font_size;
        }
    }

    self.increase_font_size = function () {
        if(self.font_size > 1) {
            self.font_size = self.font_size - 1;
        }

        self.set_font_size(self.font_size);
    }

    self.decrease_font_size = function () {
        if(self.font_size < 6) {
            self.font_size = self.font_size + 1;
        }

        self.set_font_size(self.font_size);
    }

    self.init_theme = function () {
        let supports_storage = supports_html5_storage();
        if (supports_storage) {
            var theme_name = localStorage.theme;
            if (theme_name) {
                self.set_theme(theme_name);
            } else {
                self.set_theme("darkly");
            }
        } else {
            self.set_theme("darkly");
            $("#theme-chooser").hide();
        }
    };

    self.init_font_name = function () {
        let supports_storage = supports_html5_storage();
        if (supports_storage) {
            let font_name = localStorage.font_name;
            if (font_name) {
                self.set_font_name(font_name);
            } else {
                self.set_font_name("sans");
            }
        } else {
            self.set_font_name("sans");
            $("#font-chooser").hide();
        }
    };

    self.init_font_size = function () {
        let supports_storage = supports_html5_storage();
        if (supports_storage) {
            let font_size = localStorage.font_size;
            if (font_size) {
                self.set_font_size(font_size);
            } else {
                self.set_font_size(5);
            }
        } else {
            self.set_font_size(5);
            $("#font-size-chooser").hide();
        }
    };

    self.initThemeSelector = function () {
        $(':radio[name="themeChoice"]').click(function () {
            let theme_name = $(this).val();
            self.set_theme(theme_name);
        });
    };

    self.initFontSettingsModal = function () {
        let settingsModal = document.getElementById('settingsModal')

        settingsModal.addEventListener("show.bs.modal", function (event) {
            let theme_name = self.theme;
            $("#theme_" + theme_name).prop("checked", true);

            let font_name = self.font_name;
            $("#font_" + font_name).prop("checked", true);
        });
    };

    self.initFontSelector = function () {
        $(':radio[name="fontChoice"]').click(function () {
            let font_name = $(this).val();
            self.set_font_name(font_name);
        });
    };

    self.initFontSizeButtons = function () {
        $('#btnIncreaseFont').click(function () {
            self.increase_font_size();
        });

        $('#btnDecreaseFont').click(function () {
            self.decrease_font_size();
        });
    };

    self.init = function () {
        self.initThemeSelector();
        self.initFontSelector();
        self.initFontSettingsModal();
        self.initFontSizeButtons();
        self.init_theme();
        self.init_font_name();
        self.init_font_size();
    };

    return {
        init: self.init,
        theme: self.theme,
    };
})();

$(document).ready(function () {
    App.init();
});
