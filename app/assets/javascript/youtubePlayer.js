const playBtn = '<svg xmlns="http://www.w3.org/2000/svg" height="20" width="15" viewBox="0 0 384 512"><path d="M73 39c-14.8-9.1-33.4-9.4-48.5-.9S0 62.6 0 80L0 432c0 17.4 9.4 33.4 24.5 41.9s33.7 8.1 48.5-.9L361 297c14.3-8.7 23-24.2 23-41s-8.7-32.2-23-41L73 39z"/></svg>'
const pauseBtn = '<svg xmlns="http://www.w3.org/2000/svg" height="20" width="12.5" viewBox="0 0 320 512"><path d="M48 64C21.5 64 0 85.5 0 112L0 400c0 26.5 21.5 48 48 48l32 0c26.5 0 48-21.5 48-48l0-288c0-26.5-21.5-48-48-48L48 64zm192 0c-26.5 0-48 21.5-48 48l0 288c0 26.5 21.5 48 48 48l32 0c26.5 0 48-21.5 48-48l0-288c0-26.5-21.5-48-48-48l-32 0z"/></svg>'
const activeColor = "var(--blue)";
const inactiveColor = "#ccc";

var reloadYoutube = function () {
    /* if YT already initialized return */
    if (window.YT) { return; };
    var tag = document.createElement('script');
    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
};
reloadYoutube();

let player = null;
let playlist;
let is_looping = false;
let is_shuffled = false;
const range = document.getElementById('range');

addEventListener('turbo:load', () => {
    // check if playlist already exists
    const currentPlaylist = player ? player.getPlaylist() : null,
    currentIndex    = player ? player.getPlaylistIndex() : null,
    currentStart    = player ? player.getCurrentTime() : null,
    currentState    = player ? player.getPlayerState() : null;

    const queue = document.getElementById('queue');

    // initiallize youtube player
    if (!player) {
        player = new YT.Player('youtube-player', {
            width: 300,
            height: 200,
            events: {
                onReady: onReadyEvent,
                onStateChange: handleChange,
                onError: onPlayerError
            }
        });
    }
    
    // handle seek / ff
    const range = document.getElementById('range');
    const time = document.getElementById('current-time');
    function updateTimerDisplay() {
        // Update current time text display.
        if (player && player.getCurrentTime()) {
            time.innerHTML = formatTime( player.getCurrentTime() );
        }
    }
    function updateProgressBar() {
        // Update the value of our progress bar accordingly.
        if (player) {
            const ratio = player.getCurrentTime() / player.getDuration() * 100 || 0;
            range.value = ratio;
            range.style.background = `linear-gradient(90deg, ${activeColor} ${ratio}%, ${inactiveColor} ${ratio}%)`;
        }
    }

    range.addEventListener('change', updateTime, false);

    function updateTime (e) {
        // Calculate the new time for the video.
        // new time in seconds = total duration in seconds * ( value of range input / 100 )
        var newTime = player.getDuration() * (e.target.value / 100);
        // Skip video to new time.
        player.seekTo(newTime);
    }

    function onPlayerError(event) {
        // Handle the error based on the event.data (error code)
        switch (event.data) {
            case 2:
                console.error('Invalid parameter or video not found.');
                break;
            case 100:
                console.error('Video not found or marked as private.');
                break;
            case 101:
            case 150:
                console.error('Video owner does not allow embedding.');
                break;
            default:
                console.error('An unknown error occurred:', event.data);
        }
    }

    function onReadyEvent () {
        if (currentPlaylist) {
            if (currentState == YT.PlayerState.PLAYING) { // player is playing
                player.loadPlaylist(currentPlaylist, currentIndex, currentStart);
            } else {
                player.cuePlaylist(currentPlaylist, currentIndex, currentStart);
            }
            
            if (is_looping) {
                player.setLoop(1); // set loop to true
            }
            range.value = currentStart;
            time.innerHTML = formatTime(currentStart);
        } else {            
            playlist = Array.from(queue.querySelectorAll('.play-tracks')).map(track => track.dataset.id)
            player.cuePlaylist(playlist)
        }
        // Update the controls on load
        updateTimerDisplay();
        updateProgressBar();

        
        // Start interval to update elapsed time display and
        // the elapsed part of the progress bar every second.
        const time_update_interval = setInterval(function () {
            updateTimerDisplay();
            updateProgressBar();
        }, 1000)
    }

    const play = document.getElementById("play"),
          stop = document.getElementById("stop"),
          prev = document.getElementById("prev"),
          next = document.getElementById("next"),
          loop = document.getElementById("loop"),
          shuffle = document.getElementById("shuffle");

    play.addEventListener("click", function() {
        if (player.getPlayerState() == YT.PlayerState.PLAYING) {
            player.pauseVideo();
        } else {
            player.playVideo();
        }
    });
    stop.addEventListener("click", function() {
        if (player.getPlayerState() == YT.PlayerState.PLAYING) {
            player.stopVideo();
        }
    });
    prev.addEventListener("click", function() {
        if (player.getPlayerState() == YT.PlayerState.PLAYING) {
            player.previousVideo();
        } else {
            player.previousVideo();
            player.pauseVideo();
        }
    });
    next.addEventListener("click", function() {
        if (player.getPlayerState() == YT.PlayerState.PLAYING) {
            player.nextVideo();
        } else {
            player.nextVideo();
            player.pauseVideo();
        }
    });
    loop.addEventListener("click", function() {
        if (is_looping) {
            player.setLoop(0);
            is_looping = false;
        } else {
            player.setLoop(1);
            is_looping = true;
        }
    });
    shuffle.addEventListener("click", function() {
        if (is_shuffled) {
            player.setShuffle(0)
            is_shuffled = false
        } else {
            player.setShuffle(1)
            player.playVideoAt(0)
            is_shuffled = true
        }
    })
    // update title that displays in media player marquee
    let titleElem = document.getElementById('track-title') || null;

    function handleChange(event) {
        const playerState = player.getPlayerState()
        const playerIndex = player.getPlaylistIndex()
        const playerTime  = player.getCurrentTime()
        // update document title
        if (event.target.videoTitle !== titleElem.innerHTML && playerState == YT.PlayerState.PLAYING) {
            titleElem.innerHTML = event.target.videoTitle;
            document.title = event.target.videoTitle;
        } else {
            document.title = 'Playlists With Friends';
        }
        // set background of current track
        Array.from(queue.querySelectorAll(".play-track-wrapper")).map((track,index) => {index === playerIndex ? track.classList.add('active') : track.classList.remove('active')})

        // set play or pause
        if (playerState == YT.PlayerState.PLAYING) {
            play.innerHTML = pauseBtn
        } else {
            play.innerHTML = playBtn
        }

        // check if playlist changed
        if (playerState === YT.PlayerState.UNSTARTED) {
            if (JSON.stringify(playlist) !== JSON.stringify(player.getPlaylist())) {
                player.loadPlaylist(playlist, playerIndex, playerTime)
            }
        }
    }
});

document.addEventListener("click", function(e) {
    // play from clicked track if target contains 'play-tracks' class
    if (e.target.parentElement.classList.contains("play-tracks")) {
        const tracklist = document.getElementById("tracklist") || document.getElementById("sortable-tracklist")
        const new_playlist = Array.from(tracklist.querySelectorAll('.track')).map(item => item.dataset.id)
        const index = parseInt(e.target.getAttribute('data-index'));

        playlist = new_playlist
        player.loadPlaylist(new_playlist, index) 
    }
    // cue playlist
    if (e.target.id === 'cuePlaylist') {
        const tracklist = document.getElementById("tracklist") || document.getElementById("sortable-tracklist")
        const new_playlist = Array.from(tracklist.querySelectorAll('.track')).map(item => item.dataset.id)
        
        playlist.push(...new_playlist)
    }
})

function formatTime(time){
    time = Math.round(time);

    var minutes = Math.floor(time / 60),
    seconds = time - minutes * 60;
    seconds = seconds < 10 ? '0' + seconds : seconds;
    return minutes + ":" + seconds;
}