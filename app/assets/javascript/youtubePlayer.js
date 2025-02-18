const playBtn = '<svg xmlns="http://www.w3.org/2000/svg" height="20" width="15" viewBox="0 0 384 512"><path d="M73 39c-14.8-9.1-33.4-9.4-48.5-.9S0 62.6 0 80L0 432c0 17.4 9.4 33.4 24.5 41.9s33.7 8.1 48.5-.9L361 297c14.3-8.7 23-24.2 23-41s-8.7-32.2-23-41L73 39z"/></svg>'
const pauseBtn = '<svg xmlns="http://www.w3.org/2000/svg" height="20" width="12.5" viewBox="0 0 320 512"><path d="M48 64C21.5 64 0 85.5 0 112L0 400c0 26.5 21.5 48 48 48l32 0c26.5 0 48-21.5 48-48l0-288c0-26.5-21.5-48-48-48L48 64zm192 0c-26.5 0-48 21.5-48 48l0 288c0 26.5 21.5 48 48 48l32 0c26.5 0 48-21.5 48-48l0-288c0-26.5-21.5-48-48-48l-32 0z"/></svg>'
const activeColor = "limegreen";
const inactiveColor = "#ccc";

var reloadYoutube = function () {
/* if YT already initialized return */
if (window.YT) { return; };
    console.log('you tube not ready');
    var tag = document.createElement('script');
    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
};
reloadYoutube();

let player;
let is_looping = false;
const range = document.getElementById('range');

addEventListener('turbo:load', () => {
    // check if playlist already exists
    const currentPlaylist = player ? player.getPlaylist() : null,
          currentIndex    = player ? player.getPlaylistIndex() : null,
          currentStart    = player ? player.getCurrentTime() : null,
          currentState    = player ? player.getPlayerState() : null;
    // initiallize youtube player
    player = new YT.Player('youtube-player', {
        width: 300,
        height: 200,
        events: {
            onReady: onReadyEvent,
            onStateChange: updateTitle
        }
    });
    
    // handle seek / ff
    const range = document.getElementById('range');
    const time = document.getElementById('current-time');
    function updateTimerDisplay() {
        // Update current time text display.
        if (player) {
            time.innerHTML = formatTime( player.getCurrentTime() );
        }
    }
    function updateProgressBar() {
        // Update the value of our progress bar accordingly.
        if (player) {
            const ratio = player.getCurrentTime() / player.getDuration() * 100;
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
          loop = document.getElementById("loop");

    play.addEventListener("click", function() {
        if (player.getPlayerState() == YT.PlayerState.PLAYING) {
            player.pauseVideo();
            play.innerHTML = playBtn;
        } else {
            player.playVideo();
            play.innerHTML = pauseBtn;
        }
    });
    stop.addEventListener("click", function() {
        if (player.getPlayerState() == YT.PlayerState.PLAYING) {
            player.stopVideo();
            play.innerHTML = playBtn;
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
        if (player.getPlaylist() && player.getPlaylistIndex() + 1 < player.getPlaylist().length || is_looping) {
            if (player.getPlayerState() == YT.PlayerState.PLAYING) {
                player.nextVideo();
            } else {
                player.nextVideo();
                player.pauseVideo();
            }
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
    // update title that displays in media player marquee
    let titleElem = document.getElementById('track-title') || null;
    function updateTitle(event) {
        if (event.target.videoTitle !== titleElem.innerHTML && player.getPlayerState() == YT.PlayerState.PLAYING) {
            titleElem.innerHTML = event.target.videoTitle;
            document.title = event.target.videoTitle;
        } else {
            document.title = 'Greatdj3';
        }
    }
});

addEventListener('turbo:load', youtube_player, false);
addEventListener('turbo:frame-load', youtube_player, false);

function youtube_player () {
    const playTracks = document.getElementsByClassName('play-tracks');

    if (playTracks.length > 0) {
        let playlist = document.getElementById('cuePlaylist').dataset.playlist.split(',');
        // start playlist from clicked item
        for (var i = 0; i < playTracks.length; i++) {
            playTracks[i].addEventListener("click", function(e){
                e.preventDefault();
                const index = this.getAttribute('data-index');
                player.loadPlaylist(playlist, index);
            });
        }

        // define media player controls
        const playAll = document.getElementById("playPlaylist"),
            cue  = document.getElementById("cuePlaylist");

        cue.addEventListener("click", function(e){
            e.preventDefault();
            if (player.getPlaylist()) {
                const new_playlist = player.getPlaylist().concat(playlist);
                if (player.getPlayerState() == YT.PlayerState.PLAYING) {
                    player.loadPlaylist(new_playlist, player.getPlaylistIndex(), player.getCurrentTime());
                    play.innerHTML = pauseBtn;
                } else {
                    player.cuePlaylist(new_playlist);
                }
            } else {
                player.cuePlaylist(playlist);
            }
        });

        playAll.addEventListener("click", function(e) {
            e.preventDefault();
            player.loadPlaylist(playlist);
            play.innerHTML = pauseBtn;
        });
    }
}

function formatTime(time){
    time = Math.round(time);

    var minutes = Math.floor(time / 60),
    seconds = time - minutes * 60;
    seconds = seconds < 10 ? '0' + seconds : seconds;
    return minutes + ":" + seconds;
}