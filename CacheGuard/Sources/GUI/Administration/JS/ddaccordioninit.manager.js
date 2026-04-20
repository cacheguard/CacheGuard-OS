ddaccordion.init( {
	headerclass: "left-menu-administration-manager",
	contentclass: "left-menu-administration-items",
	revealtype: "click",
	mouseoverdelay: 200,
	collapseprev: true,
	defaultexpanded: [0],
	onemustopen: false,
	animatedefault: false,
	persiststate: true,
	toggleclass: ["", "openheader"],
	togglehtml: ["prefix", "", ""],
	animatespeed: "fast",
	oninit:function(headers, expandedindices){
	},
	onopenclose:function(header, index, state, isuseractivated){
	}
})

ddaccordion.init({
	headerclass: "left-submenu-administration-manager",
	contentclass: "left-submenu-administration-items",
	revealtype: "click",
	mouseoverdelay: 200,
	collapseprev: true,
	defaultexpanded: [],
	onemustopen: false,
	animatedefault: false,
	persiststate: true,
	toggleclass: ["closedsubheader", "opensubheader"],
	togglehtml: ["none", "", ""],
	animatespeed: "fast",
	oninit:function(headers, expandedindices){
	},
	onopenclose:function(header, index, state, isuseractivated){
	}
})

ddaccordion.init( {
	headerclass: "board-menu-administration-manager",
	contentclass: "board-menu-administration-items",
	revealtype: "click",
	mouseoverdelay: 200,
	collapseprev: true,
	defaultexpanded: [0],
	onemustopen: false,
	animatedefault: false,
	persiststate: true,
	toggleclass: ["", "openheader"],
	togglehtml: ["prefix", "", ""],
	animatespeed: "fast",
	oninit:function(headers, expandedindices){
	},
	onopenclose:function(header, index, state, isuseractivated){
	}
})
