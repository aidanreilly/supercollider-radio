// F. Uwe Laysiepen / Marina Abramoviç "Bioguarde" (4:43), 1982
// Play the mp3 file in a loop
// 15 seconds later, start playing the same file again over the top of the first, but at 75% volume, with some low end rolled off the playback of the file. Playback in a loop
// 45 seconds later, start playing the same file again for a third time over the top of the first and second instance, but at 50% volume, with even more low end rolled off the playback of the file. Playback in a loop
// Add some light delay on top of the whole mix
// Add a sprinkle of reverb on top of the whole mix + delay

s.waitForBoot {
    s.record(duration: 1800);

    // Load the MP3
    ~buffer = Buffer.read(s, "./Live-To-Air_6-4-FULaysiepen+MAbramovic.mp3");

    // Ensure the buffer is loaded correctly
    if (~buffer.isNil or: { ~buffer.numFrames < 1 }) {
        "Buffer not loaded. Check the MP3 file.".postln;
        s.meter; // Optionally, to visualize if there's sound
        ^; // Exit if the buffer is not loaded
    }

    // Define a simple playback function with adjustable volume and EQ
    ~playFile = { |volume = 1.0, lowFreqCutoff = 0, reverbMix = 0.2, delayTime = 0.3|

        var player, reverb, delay, eq;

        // Play in loop
        player = PlayBuf.ar(2, ~buffer, BufRateScale.kr(~buffer), loop: 1);

        // Sprinkle a touch of EQ
        eq = HPF.ar(player, lowFreqCutoff);

        // Add twist of reverb
        reverb = FreeVerb.ar(eq, reverbMix, 0.5, 0.1);  // Light reverb

        // Smidge of delay
        delay = CombN.ar(reverb, delayTime, delayTime, 1);

        // Output volume
        Out.ar(0, delay * volume); // Mix output
    };

    // Playback Routine
    Routine {
        // Play first instance (full volume, no EQ)
        ~playFile.value(1.0, 0, 0.2, 0.3); // Play with light reverb and delay

        // After 15 seconds, play a second instance at 3/4 volume with low-end rolloff
        15.wait;
        
        ~playFile.value(0.75, 100, 0.2, 0.3);  // 100 Hz cutoff for the low-end rolloff

        // After 45 seconds, play a third instance at 1/2 volume with more low-end rolloff
        45.wait;
        
        ~playFile.value(0.5, 200, 0.2, 0.3);  // 200 Hz cutoff for stronger low-end rolloff
    }.play;
};
