/* jquery.nicescroll.plus
-- the addon for nicescroll
-- version 1.0.0 BETA
-- copyright 13 InuYaksa*2013
-- licensed under the MIT
--
-- http://areaaperta.com/nicescroll
-- https://github.com/inuyaksa/jquery.nicescroll
--
*/
(function(jQuery){

  var $ = jQuery;  // sandbox

  if (!$||!("nicescroll" in $)) return;

  $.extend($.nicescroll.options,{

    styler:false

  });

  var _super = {
    "niceScroll":$.fn.niceScroll,
    "getNiceScroll":$.fn.getNiceScroll
  }

  $.fn.niceScroll = function(wrapper,opt) {

    if (!(typeof wrapper == "undefined")) {
      if (typeof wrapper == "object") {
        opt = wrapper;
        wrapper = false;
      }
    }

    var styler = (opt&&opt.styler)||$.nicescroll.options.styler||false;

    if (styler) {
      nw=preStyler(styler);
      $.extend(nw,opt);
      opt = nw;
    }

    var ret = _super.niceScroll.call(this,wrapper,opt);

    if (styler) doStyler(styler,ret);

    ret.scrollTo = function(el) {
      var off = this.win.position();
      var pos = this.win.find(el).position();
      if (pos) {
        var top = Math.floor(pos.top-off.top+this.scrollTop());
        this.doScrollTop(top);
      }
    }

    return ret;
  }

  $.fn.getNiceScroll = function(index) {
    var ret = _super.getNiceScroll.call(this,index);
    ret.scrollTo = function(el) {
      this.each(function(){
        this.scrollTo.call(this,el);
      });
    }
    return ret;
  }

  function preStyler(styler) {
    var opt = {};
    switch(styler) {
      case "fb":
        opt.autohidemode = false;
        opt.cursorcolor = "{{ site.scroll-cursor }}";
        opt.railcolor = "";
        opt.cursoropacitymax = 1.0;
        opt.cursorwidth = 10;
        opt.cursorborder = "0px solid #868688";
        opt.cursorborderradius = "0px";
        break;
    }
    return opt;
  }

  function doStyler(styler,nc) {
    if (!nc.rail) return;

    switch(styler) {
      case "fb":

        nc.rail.css({
          "-webkit-border-radius":"0px",
          "-moz-border-radius":"0px",
          "border-radius":"0px"
        });

        nc.cursor.css({width:5});

        var obj = (nc.ispage) ? nc.rail : nc.win;

        function endHover() {
          nc._stylerfbstate = false;
          nc.rail.css({
            "backgroundColor":""
          });
          nc.cursor.stop().animate({width:5},200);
        }

        obj.hover(function(){
          nc._stylerfbstate = true;
          nc.rail.css({
            "backgroundColor":"{{ site.scroll-rail }}"
          });
          nc.cursor.stop().css({width:10});
        },
        function(){
          if (nc.rail.drag) return;
          endHover();
        });

        $(document).mouseup(function(){
          if (nc._stylerfbstate) endHover();
        });

        break;
    }

  }

})( jQuery );
