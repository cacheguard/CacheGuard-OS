/*
###########################################################################
#
# MODULE:       GUI
# COPYRIGHT:    (C) 2009-2025 by CacheGuard Technologies Ltd (UK)
# COPYRIGHT:    (C) 2026-2026 by CacheGuard Technologies SAS (FR)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
###########################################################################
*/

/*
 * This program has been initally provided by By Dynamic Drive DHTML code library: http://www.dynamicdrive.com
 * and called Smooth Navigational Menu.
 *
 * It has been modified by CacheGuard Technologies. Modifications are as follows:
 *  - CSP compliant (no injected <style>)
 *  - No inline HTML styles
 *  - Removed obsolete IE6/7/8/9 code
 *  - The code has been made compatible with jQuery 1.12.4
 *
 */

var ddsmoothmenu = {

    ///////////////////////// Global Configuration Options: /////////////////////////

    //Specify full URL to down and right arrow images (23 is padding-right for top level LIs with drop downs, 6 is for vertical top level items with fly outs):    
    arrowimages: {down:['downarrowclass', '/image/down.gif', 23], right:['rightarrowclass', '/image/arrowbullet-right.png', 6]},
    transition: {overtime:0, outtime:0}, //duration of slide in/ out animation, in milliseconds
    shadow: true, //enable shadow? (offsets now set in ddsmoothmenu.css stylesheet)
    showhidedelay: {showdelay: 0, hidedelay: 0}, //set delay in milliseconds before sub menus appear and disappear, respectively
    zindexvalue: 100000, //set z-index value for menus
    closeonnonmenuclick: true, //when clicking outside of any "toggle" method menu, should all "toggle" menus close? 
    closeonmouseout: false, //when leaving a "toggle" menu, should all "toggle" menus close? Will not work on touchscreen
    
    /////////////////////// End Global Configuration Options ////////////////////////

    overarrowre: /(?=\.(gif|jpg|jpeg|png|bmp))/i,
    overarrowaddtofilename: '_over',
    detecttouch: !!('ontouchstart' in window) || !!('ontouchstart' in document.documentElement) || !!window.ontouchstart || !!window.Touch || !!window.onmsgesturechange || (window.DocumentTouch && window.document instanceof window.DocumentTouch),
    idevice: /ipad|iphone/i.test(navigator.userAgent),
    prevobjs: [], menus: null,

    executelink: function($, prevobjs, e){
	if (!e) {
            return;
	}

	var prevscount = prevobjs.length, link = e.target;

	while(--prevscount > -1){
	    if(prevobjs[prevscount] === this){
		prevobjs.splice(prevscount, 1);
		if(link.href !== ddsmoothmenu.emptyhash 
		   && link.href 
		   && $(link).is('a') 
		   && !$(link).children('span.' + ddsmoothmenu.arrowimages.down[0] +', span.' + ddsmoothmenu.arrowimages.right[0]).length
		   && $(link).closest('li').children('ul').length === 0){
		    if(link.target && link.target !== '_self'){
			window.open(link.href, link.target);
		    } else {
			window.location.href = link.href;
		    }
		    e.stopPropagation();
		}
	    }
	}
    },

    updateprev: function($, prevobjs, $currentItem){
	var prevscount = prevobjs.length, prevobj, $indexobj = $currentItem.parents().add(this);
	while(--prevscount > -1){
	    if($indexobj.index((prevobj = prevobjs[prevscount])) < 0){
		$(prevobj).trigger('click', [1]);
		prevobjs.splice(prevscount, 1);
	    }
	}
	prevobjs.push(this);
    },

    subulpreventemptyclose: function(e){
	var link = e.target;
	if(link.href === ddsmoothmenu.emptyhash && $(link).parent('li').find('ul').length < 1){
	    e.preventDefault();
	    e.stopPropagation();
	}
    },

    getajaxmenu: function($, setting, nobuild){ //function to fetch external page containing the panel DIVs
	var $menucontainer=$('#'+setting.contentsource[0]); //reference empty div on page that will hold menu
	$menucontainer.html("Loading Menu...");
	$.ajax({
	    url: setting.contentsource[1], //path to external menu file
	    async: true,
	    error: function(ajaxrequest){
		$menucontainer.html('Error fetching content. Server Response: '+ajaxrequest.responseText);
	    },
	    success: function(content){
		$menucontainer.html(content);
		!!!nobuild && ddsmoothmenu.buildmenu($, setting);
	    }
	});
},

    closeall: function(e){
	var smoothmenu = ddsmoothmenu, prevscount;
	if(!smoothmenu.globaltrackopen){return;}
	if(e.type === 'mouseleave' || ((e.type === 'click' || e.type === 'touchstart') && smoothmenu.menus.index(e.target) < 0)){
	    prevscount = smoothmenu.prevobjs.length;
	    while(--prevscount > -1){
		$(smoothmenu.prevobjs[prevscount]).triggerHandler('click');
		smoothmenu.prevobjs.splice(prevscount, 1);
	    }
	}
    },

    emptyhash: $('<a href="#"></a>').get(0).href,

    buildmenu: function($, setting){
	var smoothmenu = ddsmoothmenu;
	smoothmenu.globaltrackopen = smoothmenu.closeonnonmenuclick || smoothmenu.closeonmouseout;
	var zsub = 0; //subtractor to be incremented so that each top level menu can be covered by previous one's drop downs
	var prevobjs = smoothmenu.globaltrackopen? smoothmenu.prevobjs : [];
	var $mainparent = $("#"+setting.mainmenuid).removeClass("ddsmoothmenu ddsmoothmenu-v").addClass(setting.classname || "ddsmoothmenu");
	//setting.$mainparent = $mainparent;
	var $mainmenu = $mainparent.find('>ul'); //reference main menu UL
	var method = smoothmenu.detecttouch? 'toggle' : setting.method === 'toggle'? 'toggle' : 'hover';
	var $topheaders = $mainmenu.find('>li>ul').parent();//has('ul');
	//$mainparent.data('$menuItems', $topheaders);
	var orient = setting.orientation!='v'? 'down' : 'right', $parentshadow = $(document.body);
	$mainmenu.on('click', function(e){e.target.href === smoothmenu.emptyhash && e.preventDefault();});
	if(method === 'toggle') {
	    if(smoothmenu.globaltrackopen){
		smoothmenu.menus = smoothmenu.menus? smoothmenu.menus.add($mainmenu.add($mainmenu.find('*'))) : $mainmenu.add($mainmenu.find('*'));
	    }
	    if(smoothmenu.closeonnonmenuclick){
		if(orient === 'down'){
		    $mainparent.on('click', function(e){
			e.stopPropagation();
		    });
		}
		$(document).off('click.smoothmenu').on('click.smoothmenu', smoothmenu.closeall);
		if(smoothmenu.idevice){
		    document.removeEventListener('touchstart', smoothmenu.closeall, false);
		    document.addEventListener('touchstart', smoothmenu.closeall, false);
		}
	    } else if (setting.closeonnonmenuclick){
		if(orient === 'down'){
		    $mainparent.on('click', function(e){
			e.stopPropagation();
		    });
		}
		$(document).on('click.' + setting.mainmenuid, function(e){$mainmenu.find('li>a.selected').parent().trigger('click');});
		if(smoothmenu.idevice){
		    document.addEventListener('touchstart', function(e){$mainmenu.find('li>a.selected').parent().trigger('click');}, false);
		}
	    }
	    if(smoothmenu.closeonmouseout){
		var $leaveobj = orient === 'down'? $mainparent : $mainmenu;
		$leaveobj.on('mouseleave.smoothmenu', smoothmenu.closeall);
	    } else if (setting.closeonmouseout){
		var $leaveobj = orient === 'down'? $mainparent : $mainmenu;
		$leaveobj.on('mouseleave.smoothmenu', function(){$mainmenu.find('li>a.selected').parent().trigger('click');});
	    }
	    var shadowstimer;
	    $(window).on('resize', function(){
		clearTimeout(shadowstimer);
		var $selected = $mainmenu.find('li>a.selected').parent(),
		    $submenuShadows = $('.ddshadow').addClass('ddsmoothmenushadowsnone');
		$selected.eq(0).trigger('click');
		$selected.trigger('click');
		shadowstimer = setTimeout(function(){$submenuShadows.removeClass('ddsmoothmenushadowsnone');}, 100);
		});
	}

	$topheaders.each(function(){
	    var $currentItem=$(this).css({zIndex: (setting.zindexvalue || smoothmenu.zindexvalue) + zsub--}); //reference current LI header
	    var $submenu=$currentItem.children('ul:eq(0)').css({display:'block'}).data('timers', {});
	    var $link = $currentItem.children("a:eq(0)")
		.addClass("ddsm-has-arrow")
		.append(
		    '<span class="' + smoothmenu.arrowimages[orient][0] + ' ddsm-arrow"></span>'
		);
	    var dimensions = {
		w	: $link.outerWidth(),
		h	: $currentItem.innerHeight(),
		subulw	: $submenu.outerWidth(),
		subulh	: $submenu.outerHeight()
	    };
	    $submenu.css({top: orient === 'down'? dimensions.h : 0});
	    function restore(){$link.removeClass('selected');}
	    method === 'toggle' && $submenu.on('click', smoothmenu.subulpreventemptyclose);

	    var openHandler = function(e){
		if(!$currentItem.data('headers')){
		    smoothmenu.buildsubheaders($, $submenu.find('>li>ul').parent(), setting, method, prevobjs);
		    $currentItem.data('headers', true).find('>ul').css({display:'none', visibility:'visible'});
		}
		method === 'toggle' && smoothmenu.updateprev.call(this, $, prevobjs, $currentItem);
		clearTimeout($submenu.data('timers').hidetimer);
		$link.addClass('selected');
		$submenu.data('timers').showtimer=setTimeout(function(){
		    var menuleft = orient === 'down'? 0 : dimensions.w;
		    menuleft=($currentItem.offset().left+menuleft+dimensions.subulw>$(window).width())? (orient === 'down'? -dimensions.subulw+dimensions.w : -dimensions.w) : menuleft;
		    $submenu.css({left:menuleft, width:dimensions.subulw}).stop(true, true).animate({height:'show',opacity:'show'}, smoothmenu.transition.overtime);
		}, smoothmenu.showhidedelay.showdelay);
	    };

	    var closeHandler = function(e, speed){
		var $submenuShadow = $currentItem.data('$submenuShadow');
		if(method === 'hover'){restore();}
		else{smoothmenu.executelink.call(this, $, prevobjs, e);}
		clearTimeout($submenu.data('timers').showtimer);
		$submenu.data('timers').hidetimer=setTimeout(function(){
		    $submenu.stop(true, true).animate({height:'hide', opacity:'hide'}, speed || smoothmenu.transition.outtime, function(){method === 'toggle' && restore();});
		}, smoothmenu.showhidedelay.hidedelay);
	    };

	    if (method === 'hover') {
		$currentItem.on('mouseenter.smoothmenu', function(e){
		    openHandler.call(this, e);
		});

		$currentItem.on('mouseleave.smoothmenu', function(e){
		    closeHandler.call(this, e);
		});
	    } else {
		$currentItem.on('click.smoothmenu', function(e){
		    if (!$currentItem.data('smoothmenu-open')) {
			e.preventDefault();
			e.stopPropagation();

			$currentItem.data('smoothmenu-open', true);
			openHandler.call(this, e);
		    } else {
			$currentItem.data('smoothmenu-open', false);
			closeHandler.call(this, e);
		    }
		});
	    }
	}); //end $topheaders.each()
    },

    buildsubheaders: function($, $menuItems, setting, method, prevobjs){
	//setting.$mainparent.data('$menuItems').add($menuItems);
	$menuItems.each(function(){ //loop through each LI header
	    var smoothmenu = ddsmoothmenu;
	    var $currentItem=$(this).css({zIndex: $(this).parent('ul').css('z-index')}); //reference current LI header
	    var $submenu=$currentItem.children('ul:eq(0)').css({display:'block'}).data('timers', {}), $parentshadow;
	    method === 'toggle' && $submenu.on('click', smoothmenu.subulpreventemptyclose);
	    var $link = $currentItem.children("a:eq(0)").append( //add arrow images
		'<span class="' + smoothmenu.arrowimages["right"][0] + ' ddsm-arrow"></span>'
	    );

	    var dimensions = {
		w	: $link.outerWidth(),
		subulw	: $submenu.outerWidth(),
		subulh	: $submenu.outerHeight()
	    };
	    $submenu.css({top: 0});
	    function restore(){$link.removeClass('selected');}

	    var openHandler = function(e){
		if(!$currentItem.data('headers')){
		    smoothmenu.buildsubheaders($, $submenu.find('>li>ul').parent(), setting, method, prevobjs);
		    $currentItem.data('headers', true).find('>ul').css({display:'none', visibility:'visible'});
		}
		method === 'toggle' && smoothmenu.updateprev.call(this, $, prevobjs, $currentItem);
		clearTimeout($submenu.data('timers').hidetimer);
		$link.addClass('selected');
		$submenu.data('timers').showtimer=setTimeout(function(){
		    var menuleft= dimensions.w;
		    menuleft=($currentItem.offset().left+menuleft+dimensions.subulw>$(window).width())? -dimensions.w : menuleft; //calculate this sub menu's offsets from its parent
		    $submenu.css({left:menuleft, width:dimensions.subulw}).stop(true, true).animate({height:'show',opacity:'show'}, smoothmenu.transition.overtime);
		}, smoothmenu.showhidedelay.showdelay);
	    };

	    var closeHandler = function(e, speed){
		var $submenuShadow = $currentItem.data('$submenuShadow');
		if(method === 'hover'){restore();}
		else{smoothmenu.executelink.call(this, $, prevobjs, e);}
		clearTimeout($submenu.data('timers').showtimer);
		$submenu.data('timers').hidetimer=setTimeout(function(){
		    $submenu.stop(true, true).animate({height:'hide', opacity:'hide'}, speed || smoothmenu.transition.outtime, function(){
			method === 'toggle' && restore();
		    });
		}, smoothmenu.showhidedelay.hidedelay);
	    }

	    if (method === 'toggle') {
		$currentItem.on('click.smoothmenu', function(e){
		    if ($(e.target).closest('a')[0] === $link[0]) {
			if ($currentItem.data('smoothmenu-open')) {
			    $currentItem.data('smoothmenu-open', false);
			    closeHandler.call(this, e);
			}
			else {
			    e.preventDefault();
			    e.stopPropagation();

			    $currentItem.data('smoothmenu-open', true);
			    openHandler.call(this, e);
			}
		    }
		});
	    }
	    else {
		$currentItem.on('mouseenter.smoothmenu', function(e){
		    openHandler.call(this, e);
		});

		$currentItem.on('mouseleave.smoothmenu', function(e){
		    closeHandler.call(this, e);
		});
	    }	    
	}); //end $menuItems.each() for subheaders
    },

    init: function(setting){
	jQuery(function($){
            if(typeof setting.contentsource === "object"){
		ddsmoothmenu.getajaxmenu($, setting);
            }
            else{
		ddsmoothmenu.buildmenu($, setting);
            }
	    
	});
    }
}; //end ddsmoothmenu variable
