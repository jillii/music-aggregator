
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
        }
    }

    const play = document.getElementById("play"),
          stop = document.getElementById("stop"),
          prev = document.getElementById("prev"),
          next = document.getElementById("next"),
          loop = document.getElementById("loop");

    play.addEventListener("click", function() {
        if (player.getPlayerState() == YT.PlayerState.PLAYING) {
            player.pauseVideo();
            play.innerHTML = "Play";
        } else {
            player.playVideo();
            play.innerHTML = "Pause";
        }
    });
    stop.addEventListener("click", function() {
        if (player.getPlayerState() == YT.PlayerState.PLAYING) {
            player.stopVideo();
            play.innerHTML = "Play";
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
                    play.innerHTML = "Pause";
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
            play.innerHTML = "Pause";
        });
    }
}
