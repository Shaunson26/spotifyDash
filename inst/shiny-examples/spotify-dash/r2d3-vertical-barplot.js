//data The R data converted to JavaScript.
//svg  The svg container for the visualization
//width  The current width of the container
//height  The current height of the container
//options  Additional options provided by the user
//theme  Colors for the current theme

// Offset plot inwards of container
const offsetWidth = 0.1 * width;
const offsetHeight = 0.1 * height;

const margin = {b: offsetHeight, l: offsetWidth, t: offsetHeight, r: offsetWidth};

// new size given offset
width = width - margin.l - margin.r;
height = height - margin.t - margin.b;

// vertical bars
let barHeight = d3
  .scaleLinear()
  .domain([0, d3.max(data.map(d => d.y))])
  .range([height, 0]);

// bar widths
let barWidth = d3
  .scaleBand()
  .domain(data.map(d => d.x))
  .range([0, width])
  .paddingInner(0.1)
  .paddingOuter(0.05);

// Axes
const leftAxis = d3
  .axisLeft(barHeight)
  .ticks(5)
  .tickSizeOuter(0);

const bottomAxis = d3
  .axisBottom(barWidth)
  .tickSizeOuter(0);

// Data
svg
  .append('g')
  .attr('transform', `translate(${margin.l},${margin.t})`)
  .attr('id', 'plot-panel');


if(svg.select(".x-axis").empty()) {
  svg
    .select('#plot-panel')
    .append('g')
    .attr('class', 'x-axis')
    .attr('transform', `translate(0,${height})`)
    .call(bottomAxis);
}

if(svg.select(".y-axis").empty()) {
  svg
    .select('#plot-panel')
    .append('g')
    .attr('class', 'y-axis')
    .call(leftAxis);
}

svg
  .select('#plot-panel')
  .selectAll('rect')
  .data(data)
  .enter()
  .append('rect')
  .attr('height', d => barHeight(d.y))
  .attr('width',  barWidth.bandwidth())
  .attr('y', d => height - barHeight(d.y))
  .attr('x', d => barWidth(d.x))
  .attr('fill', 'steelblue')
  .attr('id', d => 'bar-' + d.id);
/*
// Transitions
svg
  .select('#plot-panel')
  .selectAll('rect')
  .transition()
  .duration(300)
  .attr('width', d => barLength(d.value));

svg
  .select(".x-axis")
	.transition()
	.call(bottomAxis);

	svg
  .select(".y-axis")
	.transition()
	.call(leftAxis);*/
