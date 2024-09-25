// Reorder tracks
document.addEventListener("turbo:load", function() {
    var tracklist = document.getElementById("sortable-tracklist");

    if (tracklist) {
        var sortable = Sortable.create(tracklist, {
            onEnd: function (evt) {
                var itemEl = evt.item;
                var itemIds = Array.from(tracklist.children).map(item => item.dataset.track);

                fetch('/tracks/reorder', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                    },
                    body: JSON.stringify({ item_ids: itemIds })
                });
            }
        });
    }
});