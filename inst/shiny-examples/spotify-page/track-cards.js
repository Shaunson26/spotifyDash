// Create track cards 
//
// Uses featureData object

// The call
//insertCards(trackFeatures);

function insertCards(featureData) {
    //https://softwareengineering.stackexchange.com/questions/252532/should-i-place-functions-that-are-only-used-in-one-other-function-within-that-f
    // Helper - map features into some useable
    function extractTrackFeatures(featureData) {
        out = featureData.tracks.map((d, i) => {
            let out = {
                _id: i,
                name: d.name,
                artist: d.artists[0].name, // expand,
                trackImg: d.album.images[1].url
            }
    
            return (out)
        })
    
        return out
    }

    // Get data and add
    let trackFeaturesMin = extractTrackFeatures(featureData)

    trackFeaturesMin.forEach(d => {
        document.querySelector('.track-row').append(createCard(d))
    })

}

function createCard(x) {

    function hoverOn(x) {
        let cardDivs = [...document.querySelector('.track-row').children]
        let dataInd = cardDivs.map(d => d.id).indexOf(x.id)
        plotly_polar_update('polar-plot', 'on', dataInd);
        highlightHist(dataInd)
    }
    
    function hoverOff(x) {
        let cardDivs = [...document.querySelector('.track-row').children]
        let dataInd = cardDivs.map(d => d.id).indexOf(x.id)
        plotly_polar_update('polar-plot', 'off', dataInd);
        clearHighlightHist();
    }
    
    // Card container
    let base = document.createElement('div')
    let baseClass = ["w3-card-4", 'w3-round-large', "track-card"]
    baseClass.forEach(d => base.classList.add(d));
    base.id = 'card-' + x._id
    base.addEventListener("mouseenter", function () { hoverOn(this) })
    base.addEventListener("mouseleave", function () { hoverOff(this) })
    base.addEventListener("onclick", function () { alert('you clicked') })
    
    // Add card elements
    let img = document.createElement('img')
    img.src = x.trackImg
    img.alt = "img"
    img.height = "100"
    img.width = "100"

    let trackTitle = document.createElement('p')
    trackTitle.classList.add('track-title');
    trackTitle.innerText = x.name

    let artistName = document.createElement('p')
    artistName.classList.add('artist-name');
    artistName.innerText = x.artist

    base.append(img)
    base.append(trackTitle)
    base.append(artistName)

    // Return complete element
    return base
}


