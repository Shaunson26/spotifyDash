// Audio features polar plot
//
// Wrapper for plotly scatterpolargl using an audioFeatures json
//

// The call
drawCJSRadial(audioFeatures)

// The call pieces - 2 functions
function featuresToDataset(featureData, features) {
    // Extract features to array [[x1,y1],[x2,y2],[...]]

    function extractFeatures(audio_feature, features) {
        // extract features from the object into array {acou:x1,danc:y1,...}
        return features.map(feature => audio_feature[feature])
    }
    // apply extractFeatures to array of features [{acou:x1,danc:y1...},{{acou:x2,danc:y2...}}]
    let feature_dataset = featureData.audio_features.map(audio_feature => {
        return extractFeatures(audio_feature, features)
    });

    return (feature_dataset)
}

function applyDatasetTemplate(d, i, a) {
    let dataTemplate = {
        fill: true,
        backgroundColor: `rgba(88, 61, 114, ${1/a.length})`,
        borderColor: 'rgba(88, 61, 114,1)',
        borderWidth: 0.5,
        tension: 0.1,
        pointRadius: 0,
        //order: i,
        data: d
    };

    return dataTemplate;
}

// * data building
function createCJSRadialData(data, features) {
    // dataObj = {labels:[],data:[{},{}]}
    let dataOut = {
        labels: features,
        datasets: data.map(applyDatasetTemplate)
    };

    return dataOut;
}

function drawCJSRadial(data) {

    // Wrangle data
    const features = ["acousticness", "danceability", "energy", "instrumentalness", "liveness"/*, 'loudness'*/, "speechiness", "valence", "acousticness"]
    const featureData = featuresToDataset(data, features)
    const cjsData = createCJSRadialData(featureData, features);

    // Plot objects
    const legend = {
        display: false
    };

    const rAxisConfig = {
        // axis global
        //max: 100,
        //min: 0,
        // specifics
        angleLines: {
            display: false,
            color: "red"
        },
        grid: {
            display: false,
            color: "rgba(255,0,0,0.25)"
        },
        ticks: {
            display: false,
            stepSize: 25 // know min/max
        },
        pointLabels: {
            color: 'rgba(88, 61, 114,1)',
            font: {
                size: 14,
            }
        }
    };

    const config = {
        type: "radar",
        data: cjsData,
        options: {
            plugins: {
                legend: legend
            },
            scales: {
                r: rAxisConfig
            }
        }
    };
    
    var cjsRadial = new Chart(document.getElementById("audio-feature-radial-plot"), config);

}