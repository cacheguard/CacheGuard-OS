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

const scrollToTop={
    setting:{
	startline:100,
	scrollto:0,
	scrollduration:1000,
	fadeduration:[500,100]
    },

    controlId:"topcontrol",
    anchorkeyword:"#top",
    state:{
	isvisible:false
    },

    init(){
	const $=jQuery;
	this.$control=$("<button>",{
	    id:this.controlId,
	    type:"button",
	    title:"Scroll Back to Top",
	    "aria-label":"Scroll Back to Top"
	})
	    .appendTo(document.body)
	    .on("click",()=>{
		this.scrollup();
	    });
	$('a[href="'+this.anchorkeyword+'"]')
	    .on("click",(event)=>{
		event.preventDefault();
		this.scrollup();
	    });
	$(window).on("scroll resize",()=>{
	    this.togglecontrol();
	});
	this.togglecontrol();
    },

    scrollup(){
	let destination=0;
	if(typeof this.setting.scrollto==="string"){
	    const element=document.getElementById(this.setting.scrollto);
	    if(element){
		destination=element.offsetTop;
	    }
	}else{
	    destination=Number(this.setting.scrollto);
	}
	window.scrollTo({
	    top:destination,
	    behavior:"smooth"
	});
	this.$control.stop().animate(
	    {opacity:0},
	    this.setting.fadeduration[1]
	);
	this.state.isvisible=false;
    },

    togglecontrol(){
	const visible=window.scrollY>=this.setting.startline;
	if(visible&&!this.state.isvisible){
	    this.$control.stop().animate(
		{opacity:1},
		this.setting.fadeduration[0]
	    );
	    this.state.isvisible=true;
	}
	else if(!visible&&this.state.isvisible){
	    this.$control.stop().animate(
		{opacity:0},
		this.setting.fadeduration[1]
	    );
	    this.state.isvisible=false;
	}
    }
};

jQuery(function(){
scrollToTop.init();
});
