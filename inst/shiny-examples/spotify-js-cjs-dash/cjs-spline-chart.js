// Audio features "density" histograms
//
//

// the call
Chart.defaults.font.family = "'Patrick Hand', cursive";
addHistograms(audioFeatures)

// Build containers, add plots and append results
function addHistograms(featureData) {

    let spfeatures = ["acousticness", "danceability", "energy", "instrumentalness",
        "liveness"/*, 'loudness'*/, "speechiness", "valence", "acousticness"]

    spfeatures.forEach((d, i) => {
        function nodeSelect(x) {
            return x <= 1 ? 0
                : x <= 3 ? 1
                    : x <= 5 ? 2
                        : 3;
        }
        let histHalf = document.querySelector("#hist-half").children // 4 hardcoded
        let divHalf = document.createElement('div')
        divHalf.classList.add("w3-half")
        divHalf.classList.add("plot-half")
        let plotDiv = document.createElement('div')
        plotDiv.classList.add("plot-spline-container")
        plotDiv.style.height = '100px'
        let plotCanvas = document.createElement('canvas')
        plotCanvas.id = `plot-spline-${i}`
        plotDiv.append(plotCanvas)
        divHalf.append(plotDiv)
        histHalf[nodeSelect(i)].append(divHalf)

        let histData = createHistData(featureData, d)
        console.log(histData.countsNorm)
        cjsSpline(`plot-spline-${i}`, histData)
    })
}

// Extract data from JSON
function createHistData(featureData, feature, thresholds = 10) {

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



function cjsSpline(graphDiv, data) {

    let dataSpline = {
        labels: data.midsNorm,
        datasets: [{
            data: data.countsNorm,
            borderWidth: 2,
            tension: 0.25,
            pointRadius: 0,
            backgroundColor: `rgba(88, 61, 114, 0.1)`,
            borderColor: 'rgba(88, 61, 114,1)',
            fill: true
        }]
    };

    console.log(dataSpline)

    const config = {
        type: "scatter",
        data: dataSpline,
        options: {
            showLine: true,
            scales: {
                y: {
                    // defining min and max so hiding the dataset does not change scale range
                    min: 0,
                    max: 1.05,
                    display: false,
                    ticks: {
                        // Include a dollar sign in the ticks
                        callback: function (value, index, values) {
                            return ['low', 'high'][index]
                        }
                    },
                    grid: {
                        display: false
                    }
                },
                x: {
                    // defining min and max so hiding the dataset does not change scale range
                    min: 0,
                    max: 1,
                    ticks: {                      
                        stepSize: 1,
                        // Include a dollar sign in the ticks
                        callback: function (value, index, values) {
                            return ['low', 'high'][index]
                        }
                    },
                    grid: {
                        display: false
                    }
                },
            },
            plugins: {
                title: {
                    display: true,
                    text: data.title
                },
                legend: {
                    display: false
                }
            }
        }
    };

    var myChart = new Chart(document.getElementById(graphDiv), config);
}

/*function highlightHist(dataInd, highlightInd = 1) {

    // Object literal
    let afFull = audioFeatures.audio_features[dataInd]
    // Iterate over tusing these key selector
    let ff = ["acousticness", "danceability", "energy", "instrumentalness",
        "liveness",
        //'loudness',
         "speechiness", "valence", "acousticness"]

    // The value array in ff order
    let af = ff.map(d => afFull[d])

    af.forEach((d, i) => {
        let highlightData = {
            x: [d],
            y: [0],
            mode: 'marker',
            marker: {
                color: 'rgba(255,0,0,0.5)',
                size: 10
            },
            showlegend: false
        }
        // The data and trace index
        Plotly.addTraces(`plot-spline-${i}`, highlightData, highlightInd)
    })

}
function clearHighlightHist(highlightInd = 1) {
    document.querySelectorAll(".plot-spline").forEach((d, i) => {
        Plotly.deleteTraces(`plot-spline-${i}`, highlightInd)
    })
}

*/

