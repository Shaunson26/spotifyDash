// Spline plots
let spfeatures = ["acousticness", "danceability", "energy", "instrumentalness",
    "liveness"/*, 'loudness'*/, "speechiness", "valence", "acousticness"]

spfeatures.forEach((d, i) => {
    function nodeSelect(x) {
        return x <= 1 ? 0
            : x <= 3 ? 1
                : x <= 5 ? 2
                    : 3;
    }
    let histHalf = document.querySelector("#hist-half").children // 4
    let divHalf = document.createElement('div')
    divHalf.classList.add("w3-half")
    divHalf.classList.add("plot-half")
    let plotDiv = document.createElement('div')
    plotDiv.classList.add("plot-spline")
    plotDiv.id = `plot-spline-${i}`
    plotDiv.style.height = '100px'
    divHalf.append(plotDiv)
    histHalf[nodeSelect(i)].append(divHalf)

    plotly_spline(`plot-spline-${i}`, createSplineData(audioFeatures, d))
})

function createSplineData(featureData, feature, thresholds = 10) {

    let featureArray = featureData.audio_features.map(d => d[feature])
    featureArray.push(0)
    featureArray.push(1)

    let dataBins = d3.bin().thresholds(thresholds)(featureArray)

    function normalise(x, wMin = 0, wMax = 1) {
        let dMax = d3.max(x)
        let dMin = d3.min(x)
        let out = x.map(d => (wMax - wMin) / (dMax - dMin) * (d - dMax) + wMax)
        return out
    }

    let dataOut = {
        mids: getMids(dataBins),
        counts: getCounts(dataBins),
        breaks: getBreaks(dataBins),
        title: feature
    }

    dataOut.midsNorm = normalise(dataOut.mids)
    dataOut.countsNorm = normalise(dataOut.counts)

    return dataOut

    function getCounts(x, normalised = true) {
        out = x.map(d => d.length)
        if (normalised) {
            out[0] = out[0] - 1
            out[out.length - 1] = out[out.length - 1] - 1
        }
        return out
    }

    function getMids(x) {
        return x.map(d => (d.x0 + d.x1) / 2)
    }

    function getBreaks(x) {
        let breaks = x.map(d => d.x0)
        breaks.push(x[x.length - 1].x1)
        return breaks
    }
}

function add_spline(graphDiv, x) {
    let newData = {
        x: [x],
        y: [0],
        mode: 'marker',
        marker: {
            color: 'rgba(255,0,0,0.5)',
            size: 10
        },
        showlegend: false
    }
    Plotly.addTraces(graphDiv, newData, 1);
}

function remove_spline(graphDiv) {
    console.log('remove')
    Plotly.deleteTraces(graphDiv, 1);
}

function plotly_spline(graphDiv, data) {

    let bgPuple = "rgb(88, 61, 114)"
    let gridPurple = 'rgb(88, 61, 114)'
    let lineCream = 'rgba(255, 201, 150, 0.33)'

    //let y = d3.shuffle(data.y).map(d => d)

    let dataSpline = [{
        x: data.midsNorm,
        y: data.countsNorm,
        text: data.title,
        type: 'scatter',
        mode: 'lines',
        fill: 'tozeroy',
        line: {
            color: bgPuple,
            shape: 'spline',
            smoothing: 1
        },
        hoverinfo:"x+y+text",
        hovertemplate: "%{y:.2f} % of tracks with<br>" + `${data.title} of %{x}<extra></extra>`,
        showlegend: false
    }];

    let layoutSpline = {
        plot_bgcolor: 'rgba(0, 0, 0, 0)',
        paper_bgcolor: 'rgba(0, 0, 0, 0)',
        title: {
            text: `<b>${data.title}</b>`,
            font: {
                size: 18,
                family: 'Patrick Hand',
                color: bgPuple
            }
        },
        margin: { l: 4, r: 4, t: 24, b: 24 },
        xaxis: {
            range: [0, 1],
            fixedrange: true,
            zeroline: false,
            showgrid: false,
            tickmode: 'array',
            nticks: 2,
            tickvals: [0.05, 0.92],
            ticktext: ['low', 'high'],
            tickfont: {
                family: 'Patrick Hand',
                size: 14,
                color: bgPuple
            }
        },
        yaxis: {
            visible: true,
            range: [0, 1.1],
            fixedrange: true,
            zeroline: true,
            zerolinecolor: bgPuple,
            showgrid: false,
            showticklabels: false,
            //tickmode: 'array',
            //tickvals: [0, 5, 10],
            ticklen: 0,
            tickcolor: 'white'
            //,
            //tickfont: {
            //    family: "Arial",
            //    size: 12
            //}
        }

    };

    let config = {
        responsive: true,
        displayModeBar: false
    }

    Plotly.newPlot(graphDiv, dataSpline, layoutSpline, config);
}

var splineHoverUpdate = {
    on: { 'marker.color': [['red', 'red', 'red']] },
    off: { 'marker.color': [['red', 'red', 'red']] }
}

// Barplots
/*var trace1 = {
    type: 'bar',
    x: [1, 2, 3],
    y: [5, 10, 2],
    marker: {
        color: ['red', 'red', 'red'],
        line: {
            width: 1
        }
    }
};

var data = [trace1];

var layout = {
    margin: { l: 16, r: 16, t: 16, b: 16 }
};

var barHoverUpdate = {
    on: { 'marker.color': [['red', 'red', 'red']] },
    off: { 'marker.color': [['red', 'red', 'red']] }
}


Plotly.newPlot('plot-2', data, layout, config);*/
