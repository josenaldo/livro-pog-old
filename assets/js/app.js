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
        $('link[title="theme-css"]').attr("href", theme);

        self.theme = theme_name;
        let supports_storage = supports_html5_storage();

        if (supports_storage) {
            localStorage.theme = theme_name;
        }
    };

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

    self.init = function () {
        self.initThemeSelector();
        self.init_theme();
    };

    return {
        init: self.init,
        theme: self.theme,
    };
})();

$(document).ready(function () {
    App.init();
});
