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

/////////
// Pie //
/////////

function hoverPieSlice( id, name )
{
    var container = document.getElementById( id );

    if (!container || !container.__d3Pie)
        return false;

    var slice = container.querySelector(
        '.d3-pie-slice[data-pie-name="' + CSS.escape( name ) + '"]'
    );

    if (!slice)
        return false;

    var d = d3.select( slice ).datum( );
    var path = slice.querySelector( "path" );

    if (!path)
        return false;

    container.querySelectorAll( ".d3-pie-slice" ).forEach( function( item ) {
        item.classList.remove( "is-hovered" );
        item.classList.add( "is-dimmed" );
        item.removeAttribute( "transform" );
    } );

    slice.classList.remove( "is-dimmed" );
    slice.classList.add( "is-hovered" );

    var angle = (d.startAngle + d.endAngle) / 2;
    var distance = 3;

    var x = Math.sin( angle ) * distance;
    var y = -Math.cos( angle ) * distance;

    var hoverArc = d3.arc( ).innerRadius( 0 ).outerRadius( container.__d3Pie.radius + 5 );

    slice.setAttribute( "transform", "translate(" + x + "," + y + ")" );

    path.setAttribute( "d", hoverArc( d ) );

    var total = container.__d3Pie.data.reduce( function( sum, item ) {
        return sum + (item.hidden ? 0 : item.value);
    }, 0 );

    var percentage = total
        ? d.data.value / total * 100
        : 0;

    slice.querySelector( ".d3-pie-percentage" ).textContent =
        percentage.toFixed( 1 ) + "%";

    slice.querySelector( ".d3-pie-value" )
        .classList.add( "is-hover-hidden" );

    return true;
}

function unhoverPieSlice( id )
{
    var container = document.getElementById( id );

    if (!container || !container.__d3Pie)
        return false;

    container.querySelectorAll( ".d3-pie-slice" ).forEach( function( slice ) {
        slice.classList.remove( "is-hovered" );
        slice.classList.remove( "is-dimmed" );
        slice.removeAttribute( "transform" );

        var d = d3.select( slice ).datum( );

        slice.querySelector( "path" ).setAttribute( "d", container.__d3Pie.arc( d ) );

        slice.querySelector( ".d3-pie-percentage" ).textContent = "";

        slice.querySelector( ".d3-pie-value" )
            .classList.remove( "is-hover-hidden" );
    } );

    return true;
}

function togglePieSlice( id, name )
{
    var container = document.getElementById( id );

    if (!container || !container.__d3Pie)
        return false;

    var item = container.__d3Pie.data.find( function( d ) {
        return d.name === name;
    } );

    if (!item)
        return false;

    item.hidden = !item.hidden;

    container.__d3Pie.update( );

    return true;
}

function initPieChart( config, width, height )
{
    var container = document.getElementById( config.id );

    if (!container)
        return false;

    var data;

    if (config.data)
    {
	data = config.data;
    }
    else
    {
	data = [
            {
		name:config.freeName,
		value:Number( config.free ),
		color:config.freeColor,
		hidden:false
            },
            {
		name:config.usedName,
		value:Number( config.used ),
		color:config.usedColor,
		hidden:false
            }
	];
    }

    d3.select( container )
        .selectAll( "*" )
        .remove( );

    var margin = {
        top:10,
        right:10,
        bottom:10,
        left:10
    };

    var gap = 15;
    var legendRowHeight = 18;
    var legendBottomPadding = 10;

    var radius = Math.min(
        width - margin.left - margin.right,
        height - margin.top - margin.bottom
    ) / 2;

    var pieCenterY = margin.top + radius;

    var compact = width < 200;

    var legendRows = compact ? data.length : 1;

    var legendY = pieCenterY + radius + gap;

    var svgHeight =
        legendY +
        (legendRows * legendRowHeight) +
        legendBottomPadding;

    var svg = d3.select( container )
        .append( "svg" )
        .attr( "width", width )
        .attr( "height", svgHeight );

    var group = svg.append( "g" )
        .attr(
            "transform",
            "translate(" +
            (width / 2) +
            "," +
            pieCenterY +
            ")"
        );

    var pie = d3.pie( )
        .sort( null )
        .value(
            function( d )
            {
                return d.hidden ? 0 : d.value;
            }
        );

    var arc = d3.arc( )
        .innerRadius( 0 )
        .outerRadius( radius );

    var labelArc = d3.arc( )
        .innerRadius( radius * 0.55 )
        .outerRadius( radius * 0.55 );

    var legend = svg.append( "g" )
        .attr( "class", "d3-pie-legend" )
        .attr(
            "transform",
            "translate(" +
            margin.left +
            "," +
            legendY +
            ")"
        );

    var legendItems = legend.selectAll( ".d3-pie-legend-item" )
	.data( data )
	.enter( )
	.append( "g" )
	.attr( "class", "d3-pie-legend-item" )
	.attr(
            "data-action",
            "pie-toggle"
	)
	.attr(
            "data-pie-id",
            config.id
	)
	.attr(
            "data-pie-name",
            function( d )
            {
		return d.name;
            }
	);

    legendItems.append( "rect" )
	.attr( "class", "d3-pie-legend-color" )
	.attr( "x", 0 )
	.attr( "y", 0 )
	.attr( "width", 10 )
	.attr( "height", 10 )
	.attr(
            "fill",
            function( d )
            {
		return d.color;
            }
	);

    legendItems.append( "text" )
	.attr( "x", 15 )
	.attr( "y", 9 )
	.attr( "text-anchor", "start" )
	.text(
            function( d )
            {
		return d.name;
            }
	);

    legendItems.each(
	function( d, i )
	{
            var item = d3.select( this );
            var text = item.select( "text" );
            var textWidth = text.node( ).getComputedTextLength( );
            var itemWidth = 15 + textWidth;

            if (compact)
            {
		item.attr(
                    "transform",
                    "translate(" +
			((width - itemWidth) / 2) +
			"," +
			(i * legendRowHeight) +
			")"
		);
            }
            else
            {
		var columnWidth = width / data.length;
		item.attr(
                    "transform",
                    "translate(" +
			(
			    i * columnWidth +
				(columnWidth - itemWidth) / 2
			) +
			",0)"
		);
            }
	}
    );

    container.__d3Pie = {
        data:data,
        update:update,
        arc:arc,
        radius:radius
    };

    function update( )
    {
        var arcs = pie( data );

        var slices = group.selectAll( ".d3-pie-slice" )
            .data(
                arcs,
                function( d )
                {
                    return d.data.name;
                }
            );

        slices.exit( ).remove( );

        var slicesEnter = slices.enter( )
            .append( "g" )
            .attr( "class", "d3-pie-slice" );

        slicesEnter.append( "path" );

        slicesEnter.append( "text" )
            .attr( "class", "d3-pie-value" )
            .attr( "text-anchor", "middle" );

        slicesEnter.append( "text" )
            .attr( "class", "d3-pie-percentage" )
            .attr( "text-anchor", "middle" );

        slices = slicesEnter.merge( slices );

        slices
            .attr( "data-action", "pie-hover" )
            .attr( "data-pie-id", config.id )
            .attr(
                "data-pie-name",
                function( d )
                {
                    return d.data.name;
                }
            );

        slices.select( "path" )
            .attr( "d", arc )
            .attr(
                "fill",
                function( d )
                {
                    return d.data.color;
                }
            );

        slices.select( ".d3-pie-value" )
            .attr(
                "transform",
                function( d )
                {
                    return "translate(" +
                        labelArc.centroid( d ) +
                        ")";
                }
            )
            .text(
                function( d )
                {
                    if (d.data.hidden || !d.data.value)
                        return "";

                    return d.data.value;
                }
            );

        slices.select( ".d3-pie-percentage" )
            .attr(
                "transform",
                function( d )
                {
                    return "translate(" +
                        labelArc.centroid( d ) +
                        ")";
                }
            )
            .text( "" );

        legendItems.classed(
            "is-hidden",
            function( d )
            {
                return d.hidden;
            }
        );
    }

    update( );

    return true;
}

function initGenericPieChart( id, columns, width, height )
{
    var data = columns.map(
        function( column, i )
        {
            return {
                name:column[0],
                value:Number( column[1] ),
                color:d3.schemeCategory10[
                    i % d3.schemeCategory10.length
                ],
                hidden:false
            };
        }
    );

    initPieChart(
        {
            id:id,
            data:data
        },
        Number( width ),
        Number( height )
    );
}

function initMemoryPieCharts( config )
{
    initPieChart( config.ram, config.width, config.height );
    initPieChart( config.swap, config.width, config.height );
}

function initQoSPieCharts( )
{
    document
        .querySelectorAll( "script[data-init-pie]" )
        .forEach(
            function( element )
            {
                var config;

                try
                {
                    config = JSON.parse( element.textContent );
                }
                catch ( error )
                {
                    console.error(
                        "Invalid pie configuration:",
                        error
                    );
                    return;
                }

                if (
                    !config.bindto ||
                    !config.data ||
                    !config.data.columns ||
                    !config.size
                )
                    return;

                var id = config.bindto.replace( /^#/, "" );

                initGenericPieChart(
                    id,
                    config.data.columns,
                    config.size.width,
                    config.size.height
                );
            }
        );
}

///////////
// Gauge //
///////////

function initGaugeChart( config )
{
    var container = document.querySelector( config.bindto );

    if (!container)
        return false;

    var column = config.data.columns[0];
    var name = column[0];
    var initialValue = Number( column[1] );
    var value = config.animation
        ? Number( config.animation.value )
        : initialValue;

    var height = Number( config.size.height );
    var width = container.clientWidth || height;

    var patterns = config.color &&
        config.color.pattern
        ? config.color.pattern
        : [
            "FireBrick",
            "DarkOrange",
            "Gold",
            "SeaGreen"
        ];

    var thresholds = config.color &&
        config.color.threshold &&
        config.color.threshold.values
        ? config.color.threshold.values.map( Number )
        : [];

    d3.select( container )
        .selectAll( "*" )
        .remove( );

    var radius = Math.min( width / 2, height ) * 0.8;
    var thickness = radius * 0.32;

    var centerX = width / 2;
    var centerY = radius + 10;

    var startAngle = -Math.PI / 2;
    var endAngle = Math.PI / 2;

    var svg = d3.select( container )
        .append( "svg" )
        .attr( "width", width )
        .attr( "height", height );

    var group = svg.append( "g" )
        .attr(
            "transform",
            "translate(" +
            centerX +
            "," +
            centerY +
            ")"
        );

    var backgroundArc = d3.arc( )
        .innerRadius( radius - thickness )
        .outerRadius( radius )
        .startAngle( startAngle )
        .endAngle( endAngle );

    group.append( "path" )
        .attr( "class", "d3-gauge-background" )
        .attr( "d", backgroundArc )
        .attr( "fill", "#ddd" );

    var foreground = group.append( "path" )
        .attr( "class", "d3-gauge-value" );

    var valueText = group.append( "text" )
        .attr( "class", "d3-gauge-value-text" )
        .attr( "text-anchor", "middle" )
        .attr( "dy", "0.35em" );

    group.append( "text" )
        .attr( "class", "d3-gauge-name" )
        .attr( "text-anchor", "middle" )
        .attr( "dy", "3em" )
        .text( name );

    function getColor( currentValue )
    {
        var color = patterns[patterns.length - 1];

        for (var i = 0; i < thresholds.length; i++)
        {
            if (currentValue <= thresholds[i])
            {
                color = patterns[i];
                break;
            }
        }

        return color;
    }

    function update( currentValue )
    {
        currentValue = Math.max(
            0,
            Math.min( 100, Number( currentValue ) )
        );

        var angle =
            startAngle +
            (
                (endAngle - startAngle) *
                currentValue /
                100
            );

        var arc = d3.arc( )
            .innerRadius( radius - thickness )
            .outerRadius( radius )
            .startAngle( startAngle )
            .endAngle( angle );

        foreground
            .attr( "d", arc )
            .attr( "fill", getColor( currentValue ) );

        valueText
            .text( currentValue.toFixed( 1 ) );
    }

    update( initialValue );

    if (config.animation)
    {
        setTimeout(
            function( )
            {
                var startValue = initialValue;
                var endValue = value;
                var startTime = null;
                var duration = 700;

                function animate( timestamp )
                {
                    if (!startTime)
                        startTime = timestamp;

                    var progress =
                        Math.min(
                            (timestamp - startTime) /
                            duration,
                            1
                        );

                    var currentValue =
                        startValue +
                        (
                            (endValue - startValue) *
                            progress
                        );

                    update( currentValue );

                    if (progress < 1)
                        requestAnimationFrame( animate );
                }

                requestAnimationFrame( animate );
            },
            Number( config.animation.timeout ) || 0
        );
    }

    container.__d3Gauge = {
        update:update
    };

    return true;
}

/////////
// Bar //
/////////

function hoverBar( id, name )
{
    var container =
        document.getElementById( id );

    if ( !container )
        return;

    var chart = container.__d3Bar;

    if ( !chart )
        return;

    var bar = chart.group.selectAll(
        ".d3-bar"
    ).filter(
        function( d )
        {
            return d.name === name;
        }
    );

    if ( bar.empty( ) )
        return;

    var d = bar.datum( );

    if ( !d || d.hidden )
        return;

    var x = Number( bar.attr( "x" ) );
    var y = Number( bar.attr( "y" ) );
    var barWidth = Number( bar.attr( "width" ) );

    var text = chart.tooltip.select(
        ".d3-bar-tooltip-text"
    );

    text.text( d.value );

    var textNode = text.node( );

    if ( !textNode )
        return;

    var bbox = textNode.getBBox( );

    var paddingX = 6;
    var paddingY = 4;

    var tooltipX =
        x + barWidth / 2;

    var tooltipY =
        y - bbox.height - paddingY * 2 - 4;

    chart.tooltip
        .attr(
            "transform",
            "translate(" +
            tooltipX +
            "," +
            tooltipY +
            ")"
        )
        .classed(
            "is-visible",
            true
        );
}

function unhoverBar( id )
{
    var container =
        document.getElementById( id );

    if ( !container )
        return;

    var chart = container.__d3Bar;

    if ( !chart )
        return;

    chart.tooltip.classed(
        "is-visible",
        false
    );
}

function toggleBar( id, name )
{
    var container =
        document.getElementById( id );

    if ( !container )
        return;

    var chart = container.__d3Bar;

    if ( !chart )
        return;

    var item = chart.data.find(
        function( d )
        {
            return d.name === name;
        }
    );

    if ( !item )
        return;

    item.hidden = !item.hidden;

    chart.update( true );
}

function initBarChart( config )
{
    var container = document.querySelector( config.bindto );

    if (!container)
        return false;

    var columns = config.data.columns || [];
    var width = Number( config.size.width );
    var height = Number( config.size.height );

    if (
        !Number.isFinite( width ) ||
        !Number.isFinite( height )
    )
        return false;

    var data = columns.map(
        function( column )
        {
            return {
                name:column[0],
                value:Number( column[1] ),
                color:
                    config.data.colors &&
                    config.data.colors[column[0]]
                        ? config.data.colors[column[0]]
                        : "SteelBlue",
                hidden:false
            };
        }
    );

    d3.select( container )
        .selectAll( "*" )
        .remove( );

    var margin = {
        top:20,
        right:20,
        bottom:50,
        left:45
    };

    var legendHeight = 35;
    var gap = 10;

    var chartHeight =
        height -
        legendHeight -
        gap;

    var innerWidth =
        width -
        margin.left -
        margin.right;

    var innerHeight =
        chartHeight -
        margin.top -
        margin.bottom;

    var chartId =
        config.bindto.replace( /^#/, "" );

    var svg = d3.select( container )
        .append( "svg" )
        .attr( "width", width )
        .attr( "height", height );

    var group = svg.append( "g" )
        .attr(
            "transform",
            "translate(" +
            margin.left +
            "," +
            margin.top +
            ")"
        );

    var tooltip = group.append( "g" )
	.attr(
            "class",
            "d3-bar-tooltip"
	);

    tooltip.append( "text" )
	.attr(
            "class",
            "d3-bar-tooltip-text"
	)
	.attr(
            "text-anchor",
            "middle"
	);

    var x = d3.scaleBand( )
        .domain(
            data.map(
                function( d )
                {
                    return d.name;
                }
            )
        )
        .range( [ 0, innerWidth ] )
        .padding( 0.1 );

    var y = d3.scaleLinear( )
        .range( [ innerHeight, 0 ] );

    var xAxis = group.append( "g" )
        .attr( "class", "d3-bar-x-axis" )
        .attr(
            "transform",
            "translate(0," +
            innerHeight +
            ")"
        );

    var yAxis = group.append( "g" )
        .attr( "class", "d3-bar-y-axis" );

    var ratio =
        config.bar &&
        config.bar.width &&
        Number( config.bar.width.ratio );

    if (
        !Number.isFinite( ratio ) ||
        ratio <= 0
    )
        ratio = 0.5;

    var legend = svg.append( "g" )
        .attr( "class", "d3-bar-legend" )
        .attr(
            "transform",
            "translate(0," +
            (chartHeight + gap) +
            ")"
        );

    var legendItems = legend.selectAll(
        ".d3-bar-legend-item"
    )
        .data( data )
        .enter( )
        .append( "g" )
        .attr(
            "class",
            "d3-bar-legend-item"
        )
        .attr(
            "data-action",
            "bar-toggle"
        )
        .attr(
            "data-bar-id",
            chartId
        )
        .attr(
            "data-bar-name",
            function( d )
            {
                return d.name;
            }
        );

    legendItems.append( "rect" )
        .attr(
            "class",
            "d3-bar-legend-color"
        )
        .attr( "x", 0 )
        .attr( "y", 0 )
        .attr( "width", 10 )
        .attr( "height", 10 )
        .attr(
            "fill",
            function( d )
            {
                return d.color;
            }
        );

    legendItems.append( "text" )
        .attr( "x", 15 )
        .attr( "y", 9 )
        .attr(
            "text-anchor",
            "start"
        )
        .text(
            function( d )
            {
                return d.name;
            }
        );

    legendItems.each(
        function( d, i )
        {
            var item = d3.select( this );
            var text = item.select( "text" );
            var textWidth =
                text.node( ).getComputedTextLength( );
            var itemWidth =
                15 + textWidth;

            var columnWidth =
                width / data.length;

            item.attr(
                "transform",
                "translate(" +
                (
                    i * columnWidth +
                    (columnWidth - itemWidth) / 2
                ) +
                ",0)"
            );
        }
    );

    function getColor( name )
    {
        if (
            config.data.colors &&
            config.data.colors[name]
        )
            return config.data.colors[name];

        return "SteelBlue";
    }

    function update( animate )
    {
        var visibleData = data.filter(
            function( d )
            {
                return !d.hidden;
            }
        );

        var maxValue = d3.max(
            visibleData,
            function( d )
            {
                return d.value;
            }
        ) || 0;

        y.domain( [ 0, maxValue ] ).nice( );

        xAxis.call( d3.axisBottom( x ) );
        yAxis.call( d3.axisLeft( y ) );

        var bars = group.selectAll(
            ".d3-bar"
        )
            .data(
                data,
                function( d )
                {
                    return d.name;
                }
            );

        bars.exit( ).remove( );

        bars = bars.enter( )
            .append( "rect" )
            .attr(
                "class",
                "d3-bar"
            )
            .merge( bars );

        bars
            .attr(
                "data-action",
                "bar-hover"
            )
            .attr(
                "data-bar-id",
                chartId
            )
            .attr(
                "data-bar-name",
                function( d )
                {
                    return d.name;
                }
            )
            .classed(
                "is-hidden",
                function( d )
                {
                    return d.hidden;
                }
            );

        var barWidth =
            x.bandwidth( ) * ratio;

        bars
            .attr(
                "x",
                function( d )
                {
                    return x( d.name ) +
                        (
                            x.bandwidth( ) -
                            barWidth
                        ) / 2;
                }
            )
            .attr(
                "width",
                barWidth
            )
            .attr(
                "fill",
                function( d )
                {
                    return getColor( d.name );
                }
            );

        if (animate)
        {
            bars
                .interrupt( )
                .attr( "y", innerHeight )
                .attr( "height", 0 )
                .transition( )
                .duration( 300 )
                .attr(
                    "y",
                    function( d )
                    {
                        return d.hidden
                            ? innerHeight
                            : y( d.value );
                    }
                )
                .attr(
                    "height",
                    function( d )
                    {
                        return d.hidden
                            ? 0
                            : innerHeight - y( d.value );
                    }
                );
        }
        else
        {
            bars
                .attr(
                    "y",
                    function( d )
                    {
                        return y( d.value );
                    }
                )
                .attr(
                    "height",
                    function( d )
                    {
                        return innerHeight - y( d.value );
                    }
                );
        }

        legendItems.classed(
            "is-hidden",
            function( d )
            {
                return d.hidden;
            }
        );
    }

    update( false );

    container.__d3Bar = {
	data:data,
	update:update,
	group:group,
	tooltip:tooltip
    };

    return true;
}

///////////
// Graph //
///////////

function hoverGraph( event, element )
{
    var id = element.dataset.graphId;
    var container = document.getElementById( id );

    if ( !container )
        return;

    var chart = container.__d3Graph;

    if ( !chart )
        return;

    var hoverArea = chart.hoverArea.node( );
    var rect = hoverArea.getBoundingClientRect( );
    var mouseX = event.clientX - rect.left;

    mouseX = Math.max( 0, Math.min( mouseX, rect.width ) );

    var xValue = chart.x.invert( mouseX );
    var index = 0;
    var smallestDistance = Infinity;

    chart.dates.forEach( function( date, i ) {
        var distance = Math.abs( date.getTime( ) - xValue.getTime( ) );

        if ( distance < smallestDistance ) {
            smallestDistance = distance;
            index = i;
        }
    } );

    var selectedDate = chart.dates[index];
    var x = chart.x( selectedDate );
    var tooltip = chart.tooltip;
    var tooltipText = tooltip.select( ".d3-graph-tooltip-text" );

    chart.hoverLine
        .attr( "x1", x )
        .attr( "x2", x )
        .attr( "y1", 0 )
        .attr( "y2", chart.innerHeight )
        .classed( "is-visible", true );

    tooltip.selectAll( ".d3-graph-tooltip-row" ).remove( );
    tooltipText.selectAll( "tspan" ).remove( );

    tooltipText.append( "tspan" )
        .attr( "x", 0 )
        .attr( "dy", 0 )
        .text( d3.timeFormat( "%H:%M:%S" )( selectedDate ) );

    var values = [];

    chart.data.forEach( function( series ) {
        if ( series.hidden || !series.values[index] )
            return;

        values.push( {
            name:series.name,
            value:series.values[index].value,
            color:series.color
        } );
    } );

    values.forEach( function( item, i ) {
        var row = tooltip.append( "g" )
            .attr( "class", "d3-graph-tooltip-row" )
            .attr( "transform", "translate(0," + (i * 18 + 16) + ")" );

        row.append( "rect" )
            .attr( "width", 10 )
            .attr( "height", 10 )
            .attr( "y", -9 )
            .attr( "fill", item.color );

        row.append( "text" )
            .attr( "x", 15 )
            .attr( "y", 0 )
            .text( item.name + ": " + item.value + " Kbps" );
    } );

    var tooltipX = x + 10;

    if ( tooltipX > chart.innerWidth - 120 ) {
        tooltipX = x - 10;
        tooltipText.attr( "text-anchor", "end" );
    }
    else {
        tooltipText.attr( "text-anchor", "start" );
    }

    tooltip
        .attr( "transform", "translate(" + tooltipX + ",15)" )
        .classed( "is-visible", true );
}

function unhoverGraph( id )
{
    var container = document.getElementById( id );

    if ( !container )
        return;

    var chart = container.__d3Graph;

    if ( !chart )
        return;

    chart.hoverLine.classed( "is-visible", false );
    chart.tooltip.classed( "is-visible", false );
}

function toggleGraphSeries( id, name )
{
    var container = document.getElementById( id );

    if ( !container )
        return;

    var chart = container.__d3Graph;

    if ( !chart )
        return;

    chart.data.forEach( function( series ) {
        if ( series.name === name )
            series.hidden = !series.hidden;
    } );

    chart.update( );
}

function initGraphChart( config )
{
    var container = document.querySelector( config.bindto );

    if ( !container )
        return false;

    var columns = config.data && config.data.columns
        ? config.data.columns
        : [];

    if ( columns.length < 2 )
        return false;

    var width = Number( config.size.width );
    var height = Number( config.size.height );

    if ( !Number.isFinite( width ) || !Number.isFinite( height ) )
        return false;

    d3.select( container ).selectAll( "*" ).remove( );

    var xName = config.data.x;

    var xColumn = columns.find( function( column ) {
        return column[0] === xName;
    } );

    if ( !xColumn )
        return false;

    var colors = config.data.colors || {};

    var dates = xColumn.slice( 1 ).map( function( value ) {
        var timestamp = Number( value );

        if ( !Number.isFinite( timestamp ) )
            return null;

        if ( Math.abs( timestamp ) < 100000000000 )
            timestamp *= 1000;

        return new Date( timestamp );
    } );

    if ( dates.some( function( date ) {
        return !date || !Number.isFinite( date.getTime( ) );
    } ) )
        return false;

    var data = columns
        .filter( function( column ) {
            return column[0] !== xName;
        } )
        .map( function( column ) {
            return {
                name:column[0],
                color:colors[column[0]] || "SteelBlue",
                values:column.slice( 1 ).map( function( value, i ) {
                    return {
                        date:dates[i],
                        value:Number( value )
                    };
                } ),
                hidden:false
            };
        } );

    var margin = {
        top:20,
        right:20,
        bottom:50,
        left:55
    };

    var legendGap = 15;
    var legendRowHeight = 18;
    var legendBottomPadding = 8;

    var chartHeight = height - legendGap - legendRowHeight - legendBottomPadding;
    var innerWidth = width - margin.left - margin.right;
    var innerHeight = chartHeight - margin.top - margin.bottom;

    var svg = d3.select( container )
        .append( "svg" )
        .attr( "width", width )
        .attr( "height", height );

    var group = svg.append( "g" )
        .attr( "transform", "translate(" + margin.left + "," + margin.top + ")" );

    var hoverArea = group.append( "rect" )
        .attr( "class", "d3-graph-hover-area" )
        .attr( "data-action", "graph-hover" )
        .attr( "data-graph-id", config.bindto.replace( /^#/, "" ) )
        .attr( "x", 0 )
        .attr( "y", 0 )
        .attr( "width", innerWidth )
        .attr( "height", innerHeight );

    var hoverLine = group.append( "line" )
        .attr( "class", "d3-graph-hover-line" )
        .attr( "x1", 0 )
        .attr( "x2", 0 )
        .attr( "y1", 0 )
        .attr( "y2", innerHeight );

    var tooltip = group.append( "g" )
        .attr( "class", "d3-graph-tooltip" );

    tooltip.append( "text" )
        .attr( "class", "d3-graph-tooltip-text" )
        .attr( "text-anchor", "start" )
        .attr( "font-weight", "normal" );

    var x = d3.scaleTime( )
        .domain( d3.extent( dates ) )
        .range( [ 0, innerWidth ] );

    var y = d3.scaleLinear( )
        .domain( [ 0, 1 ] )
        .range( [ innerHeight, 0 ] );

    var xAxis = group.append( "g" )
        .attr( "class", "d3-graph-x-axis" )
        .attr( "transform", "translate(0," + innerHeight + ")" );

    var yAxis = group.append( "g" )
        .attr( "class", "d3-graph-y-axis" );

    var legendY = chartHeight + legendGap;

    var legend = svg.append( "g" )
        .attr( "class", "d3-graph-legend" )
        .attr( "transform", "translate(0," + legendY + ")" );

    var legendItems = legend.selectAll( ".d3-graph-legend-item" )
        .data( data )
        .enter( )
        .append( "g" )
        .attr( "class", "d3-graph-legend-item" )
        .attr( "data-action", "graph-toggle" )
        .attr( "data-graph-id", config.bindto.replace( /^#/, "" ) )
        .attr( "data-graph-name", function( d ) {
            return d.name;
        } );

    legendItems.append( "rect" )
        .attr( "class", "d3-graph-legend-color" )
        .attr( "x", 0 )
        .attr( "y", 0 )
        .attr( "width", 10 )
        .attr( "height", 10 )
        .attr( "fill", function( d ) {
            return d.color;
        } );

    legendItems.append( "text" )
        .attr( "x", 15 )
        .attr( "y", 9 )
        .attr( "text-anchor", "start" )
        .attr( "font-weight", "normal" )
        .text( function( d ) {
            return d.name;
        } );

    var legendWidths = [];

    legendItems.each( function( ) {
        var text = d3.select( this ).select( "text" );
        var textWidth = text.node( ).getComputedTextLength( );
        legendWidths.push( 15 + textWidth );
    } );

    var legendSpacing = 20;

    var legendTotalWidth = legendWidths.reduce( function( total, value ) {
        return total + value;
    }, 0 ) + Math.max( 0, legendWidths.length - 1 ) * legendSpacing;

    var legendX = Math.max( 0, ( width - legendTotalWidth ) / 2 );

    legendItems.each( function( d, i ) {
        var item = d3.select( this );

        item.attr( "transform", "translate(" + legendX + ",0)" );

        legendX += legendWidths[i] + legendSpacing;
    } );

    function update( )
    {
        var visibleData = data.filter( function( d ) {
            return !d.hidden;
        } );

        var maxValue = d3.max( visibleData, function( d ) {
            return d3.max( d.values, function( point ) {
                return point.value;
            } );
        } ) || 0;

        y.domain( [ 0, maxValue ] ).nice( );

        xAxis.call(
            d3.axisBottom( x )
                .ticks( Math.max( 2, Math.min( 6, Math.floor( innerWidth / 90 ) ) ) )
                .tickFormat( d3.timeFormat( "%H:%M:%S" ) )
        );

        yAxis.call( d3.axisLeft( y ) );

        if ( config.axis && config.axis.x && config.axis.x.label ) {
            xAxis.selectAll( ".d3-graph-axis-label" ).remove( );

            xAxis.append( "text" )
                .attr( "class", "d3-graph-axis-label" )
                .attr( "x", innerWidth )
                .attr( "y", 35 )
                .attr( "text-anchor", "end" )
                .text( config.axis.x.label );
        }

        if ( config.axis && config.axis.y && config.axis.y.label ) {
            yAxis.selectAll( ".d3-graph-axis-label" ).remove( );

            yAxis.append( "text" )
                .attr( "class", "d3-graph-axis-label" )
                .attr( "transform", "rotate(-90)" )
                .attr( "x", -( innerHeight / 2 ) )
                .attr( "y", -42 )
                .attr( "text-anchor", "middle" )
                .text( config.axis.y.label );
        }

        data.forEach( function( series ) {
            var safeName = series.name.replace( /[^a-zA-Z0-9_-]/g, "_" );

            var line = d3.line( )
                .x( function( d ) {
                    return x( d.date );
                } )
                .y( function( d ) {
                    return y( d.value );
                } );

            var path = group.select( ".d3-graph-line-" + safeName );

            if ( path.empty( ) ) {
                path = group.append( "path" )
                    .attr( "class", "d3-graph-line-" + safeName )
                    .attr( "data-graph-name", series.name )
                    .attr( "fill", "none" )
                    .attr( "stroke", series.color );
            }

            path
                .attr( "d", series.hidden ? null : line( series.values ) )
                .classed( "is-hidden", series.hidden );

            var points = group.selectAll( ".d3-graph-point-" + safeName )
                .data( series.values );

            points.exit( ).remove( );

            points = points.enter( )
                .append( "circle" )
                .attr( "class", "d3-graph-point-" + safeName )
                .merge( points );

            points
                .attr( "pointer-events", "none" )
                .attr( "cx", function( d ) {
                    return x( d.date );
                } )
                .attr( "cy", function( d ) {
                    return y( d.value );
                } )
                .attr( "r", series.hidden ? 0 : 3 )
                .attr( "fill", series.color );
        } );

        legendItems.classed( "is-hidden", function( d ) {
            return d.hidden;
        } );
    }

    container.__d3Graph = {
        data:data,
        dates:dates,
        x:x,
        innerWidth:innerWidth,
        innerHeight:innerHeight,
        update:update,
        group:group,
        tooltip:tooltip,
        hoverArea:hoverArea,
        hoverLine:hoverLine
    };

    update( );

    return true;
}
