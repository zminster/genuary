# genuary
Starting late, but fun (very) short daily experiments matching genuary.art prompts!

Hopefully I'm able to do one of these every day throughout January!

## January 17 -- "3 Colors"
This little one just uses some basic HSB color geometry to create a triadic color scheme based on wherever you click. Triadic colors create an equilateral "triangle" on the proverbial "color wheel." Might be interesting to show this one to help folks better understand how HSB more closely models color theory as it's studied in art classes.

## January 18 -- "VHS"
This cheeky one generates a bunch of lines that look like the old "VHS noise," both randomly throughout the screen and clustered closely around discrete "bands" that slowly move down the screen (just like those old weird VHS tape deals). There's a unique (cheap) blur pass method here (had to be cheap to run it competently at 4K). Rather than use a kernel we just do a box blur where we first cache all the "clamped" blur kernel values and add them after they've been computed. There's more in the editorial note inside -- saves a lot of divisions and preserves realtime framerate.

While you type, it displays the message on screen over top the noise using a special font. Backspace and enter work as expected; the delete key clears your message.

That special font is not packaged here because there's no available license for it, but you can grab it here: https://www.dafont.com/vcr-osd-mono.font (stick it in the data/ folder inside of sketch_18_vcr).

