insertCards(trackFeatures);

let cardDivs = [...document.querySelector('.track-row').children]

function insertCards(featureData) {

    let trackFeaturesMin = extractTrackFeatures(featureData)

    trackFeaturesMin.forEach(d => {
        document.querySelector('.track-row').append(createCard(d))
    })

}

function extractTrackFeatures(featureData) {
    out = featureData.tracks.map((d,i) => {
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

function createCard(x) {
    let base = document.createElement('div')
    let baseClass = ["w3-card-4", 'w3-round-large',"track-card"]
    baseClass.forEach(d => base.classList.add(d));
    base.id = 'card-' + x._id
    base.addEventListener("mouseenter", function(){ hoverOn(this) })
    base.addEventListener("mouseleave", function(){ hoverOff(this) })
    base.addEventListener("onclick", function () { alert('you clicked') })

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

    return base
}
