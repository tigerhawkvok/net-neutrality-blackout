/* See https://gist.github.com/tigerhawkvok/9673154 for the latest version */
function cascadeJQLoad(i) { // Use alternate CDNs where appropriate to load jQuery
    if (typeof(i) != "number") i = 0;
    // the actual paths to your jQuery CDNs. You should also have a local version here.
    var jq_paths = [
        "ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js",
        "ajax.aspnetcdn.com/ajax/jQuery/jquery-2.1.0.min.js",
        "https://code.jquery.com/jquery-2.1.0.min.js",
        "cdnjs.cloudflare.com/ajax/libs/jquery/2.1.0/jquery.min.js"
    ];
    // Paths to your libraries that require jQuery, relative to this file
    var dependent_libraries = [
        "c.js"
    ];
    if (window.jQuery === undefined && i < jq_paths.length) {
        i++;
        loadJQ(jq_paths[i], i, dependent_libraries);
    }
    if (window.jQuery === undefined && i == jq_paths.length) {
        // jQuery failed to load
        // Insert your handler here
    }
}

/***
 * You shouldn't have to modify anything below here
 ***/

function loadJQ(jq_path, i, libs) { //load jQuery if it isn't already
    if (typeof(jq_path) == "undefined") return false;
    if (typeof(i) != "number") i = 1;
    var loadNextJQ = function() {
        var src = 'https:' == location.protocol ? 'https' : 'http';
        var script_url = src + '://' + jq_path;
        loadJS(script_url, function() {
            if (window.jQuery === undefined) cascadeJQLoad(i);
        });
    }
    window.onload = function() {
        if (window.jQuery === undefined) loadNextJQ();
        else {
            // Load libraries that rely on jQuery
            if (typeof(libs) == "object") {
                try {
                    var jsFileLocation = $('script[src*=loadJQuery]').attr('src').replace('loadJQuery.js', '');
                } catch (e) {
                    var jsFileLocation = "";
                }
                $.each(libs, function() {
                    var relpath = this.toString();
                    var filepath;
                    if (relpath.search("://") === -1) filepath = jsFileLocation + relpath;
                    else filepath = relpath;
                    loadJS(filepath);
                });
            }
        }
    }
    if (i > 0) loadNextJQ();
}

function loadJS(src, callback) {
    var s = document.createElement('script');
    s.src = src;
    s.async = true;
    s.onreadystatechange = s.onload = function() {
        var state = s.readyState;
        try {
            if (!callback.done && (!state || /loaded|complete/.test(state))) {
                callback.done = true;
                callback();
            }
        } catch (e) {
            // do nothing, no callback function passed
        }
    };
    s.onerror = function() {
        try {
            if (!callback.done) {
                callback.done = true;
                callback();
            }
        } catch (e) {
            // do nothing, no callback function passed
        }
    }
    document.getElementsByTagName('head')[0].appendChild(s);
}

/*
 * The part that actually calls above
 */

if (window.readyState) { //older microsoft browsers
    window.onreadystatechange = function() {
        if (this.readyState == 'complete' || this.readyState == 'loaded') {
            cascadeJQLoad();
        }
    }
} else { //modern browsers
    cascadeJQLoad();
}
