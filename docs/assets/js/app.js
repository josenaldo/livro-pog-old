var App = (function () {
    var self = this;
    self.theme = 'darkly';

    self.supports_html5_storage = function () {
        try {
            return "localStorage" in window && window["localStorage"] !== null;
        } catch (e) {
            return false;
        }
    };

    self.set_theme = function (theme_name) {
        var theme = "/assets/css/theme/" + theme_name + ".css";
        $('link[href*="assets/css/theme"]').attr("href", theme);

        self.theme = theme_name;
        let supports_storage = supports_html5_storage();

        if (supports_storage) {
            localStorage.theme = theme_name;
        }
    };

    self.set_font = function (font_name) {
        var font = "/assets/css/font/" + font_name + ".css";
        $('link[href*="assets/css/font"]').attr("href", font);

        self.font = font_name;
        let supports_storage = supports_html5_storage();

        if (supports_storage) {
            localStorage.font = font_name;
        }
    }

    self.init_theme = function () {
        let supports_storage = supports_html5_storage();
        if (supports_storage) {
            var theme_name = localStorage.theme;
            if (theme_name) {
                set_theme(theme_name);
            } else {
                set_theme("darkly");
            }
        } else {
            set_theme("darkly");
            $("#theme-chooser").hide();
        }
    };

    self.init_font = function () {
        let supports_storage = supports_html5_storage();
        if (supports_storage) {
            var font_name = localStorage.font;
            if (font_name) {
                set_font(font_name);
            } else {
                set_font("sans");
            }
        } else {
            set_font("sans");
            $("#font-chooser").hide();
        }
    };

    self.initThemeSelector = function () {
        $(':radio[name="themeChoice"]').click(function () {
            let theme_name = $(this).val();
            set_theme(theme_name);
        });

        let settingsModal = document.getElementById('settingsModal')

        settingsModal.addEventListener("show.bs.modal", function (event) {
            let theme_name = self.theme;
            $("#theme_" + theme_name).prop("checked", true);
        });
    };

    self.initFontSelector = function () {
        $(':radio[name="fontChoice"]').click(function () {
            let font_name = $(this).val();
            set_font(font_name);
        });

        let settingsModal = document.getElementById('settingsModal')

        settingsModal.addEventListener("show.bs.modal", function (event) {
            let font_name = self.font;
            $("#font_" + font_name).prop("checked", true);
        });
    };

    self.init = function () {
        self.initThemeSelector();
        self.initFontSelector()
        self.init_theme();
        self.init_font();
    };

    return {
        init: self.init,
        theme: self.theme,
    };
})();

$(document).ready(function () {
    App.init();
});
