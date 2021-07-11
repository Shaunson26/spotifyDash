// Audio features polar plot
//
// Wrapper for plotly scatterpolargl using an audioFeatures json
//

// The call
//plotly_polar(audioFeatures, graphDiv = 'polar-plot')

// The call pieces - 2 functions
function plotly_polar(featureData, graphDiv) {

    let bgPuple = "rgb(88, 61, 114)"
    let lineCream = 'rgba(255, 201, 150, 0.33)'

    let features = ["acousticness", "danceability", "energy", "instrumentalness",
        "liveness"/*, 'loudness'*/, "speechiness", "valence", "acousticness"]

    let polarData = featureData.audio_features.map(d => {
        let feature_array = features.map(dd => d[dd])
        let trace = {
            type: "scatterpolargl",
            mode: 'lines',
            r: feature_array,
            theta: features.map(d => d.substr(0, 3).toUpperCase()),
            line: {
                width: 4,
                color: lineCream
            },
            text: features,
            hovertemplate:
                "<b>%{text}</b>:%{r}" +
                "<extra></extra>"
        }
        return trace
    })

    //console.log(polarData)

    let polarLayout = {
        margin: { l: 32, r: 32, t: 32, b: 32 },
        plot_bgcolor: 'pink',
        paper_bgcolor: 'rgba(0, 0, 0, 0)',
        showlegend: false,
        polar: {
            sector: [0, 360],
            bgcolor: bgPuple,
            radialaxis: {
                visible: true,
                color: lineCream, // everything
                range: [0, 1.02],
                tickmode: 'array',
                tickvals: [0.2, 0.4, 0.6, 0.8, 1],
                showline: false,
                ticklen: 0,
                showticklabels: false
            },
            // outer axis
            angularaxis: {
                visible: true,
                color: lineCream, // lines + ticks
                tickangle: 0,
                showline: false,
                ticklen: 0,
                tickcolor: 'white',
                showticklabels: true,
                tickfont: {
                    color: bgPuple,
                    family: 'Patrick Hand',
                    size: 16,
                }
            }
        }
    }

    let config = {
        responsive: true,
        displayModeBar: false
    }

    Plotly.newPlot(graphDiv, polarData, polarLayout, config);
}

function plotly_polar_update(graphDiv = 'polar-plot', onOff, traceInd) {

    let lineCream = 'rgba(255, 201, 150, 0.33)'

    let polarHoverUpdate = {
        on: { 'line.color': 'rgba(255,0,0,0.5)', 'line.width': 8 },
        off: { 'line.color': lineCream, 'line.width': 4 }
    }

    if (onOff == 'on') {
        Plotly.restyle(graphDiv, polarHoverUpdate.on, traceInd);
        Plotly.moveTraces(graphDiv, traceInd, -1);
    }

    if (onOff == 'off') {
        Plotly.moveTraces('polar-plot', -1, traceInd);
        Plotly.restyle('polar-plot', polarHoverUpdate.off, traceInd);
    }
}
