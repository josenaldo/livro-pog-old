var App = (function (){

    var self = this;

    self.initGoogleAnalytics = function (){
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
      
        gtag('config', 'UA-160840751-1');
    };

    self.initKatex = function() {
        $("script[type='math/tex']").replaceWith(
            function () {
                var tex = $(this).text();
        
                return "<span class=\"inline-equation\">" + katex.renderToString(tex) + "</span>";
            }
        );
        
        $("script[type='math/tex; mode=display']").replaceWith(
            function () {
                var tex = $(this).text();
        
                return "<div class=\"equation\">" + katex.renderToString("\\displaystyle " + tex) + "</div>";
            }
        );
    };

    self.initNav = function() {
        $('.sidenav').sidenav();        
    };

    self.init = function() {
        self.initGoogleAnalytics()
        self.initKatex();
        self.initNav();
    };

    return {
        init: self.init
    };

})();



$(document).ready(function() {
    M.AutoInit();
    App.init();    
});

