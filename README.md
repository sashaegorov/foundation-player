# Foundation-player.js

Dead simple player plugin for [Foundation](http://foundation.zurb.com/). The [demo](http://qatsi.github.io/foundation-player.js/index.htm).

`Foundation-player.js` featuring:
- Play/puase buttons!
- All you looking from a player
- Waveform generation

## Documentation

Provides player indicator to show how secure a users password is.

## Install

Make sure assets below added after `foundation.js`  and `foundation.css`.

```
<script type='text/javascript' src='../src/foundation-player.js'></script>
<link href='../src/foundation-player.css' rel='stylesheet' type='text/css'>
```

Create a `password` input field within `form`.

```
<form class='player player-1'>
...
<input class='radius' type='password' placeholder='Password'>
...
</form>
```

Initiate the plugin.

```
<script>
  $(document).ready(function($) {
    $('.player-1').player();
    $(document).foundation();
  });
</script>
```

## Making Coffee

'Build' now as simple as on line `coffee --compile --bare --watch --no-header **/*.coffee`.

## Todo

- Make minified version
- Use some build tools
