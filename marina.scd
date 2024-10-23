// F. Uwe Laysiepen / Marina Abramoviç "Bioguarde" (4:43), 1982

s.waitForBoot {
    // Load the sample into a buffer
    ~buffer = Buffer.read(s, "./Live-To-Air_6-4-FULaysiepen+MAbramovic.wav");

    {
        // Play the buffer in stereo (2 channels), looping continuously
        var player = PlayBuf.ar(2, ~buffer, BufRateScale.kr(~buffer), loop: 1);

        // ping-pong delay with feedback
        var ping = DelayC.ar(player, 1.5, 1.2);
        var pong = DelayC.ar(ping, 1.5, 1.0) * 0.7;  // Feedback level
        var panned = Pan2.ar(pong, SinOsc.kr(0.4).range(-1, 1)); // Slower panning for effect

        // Verb
        var reverb = JPverb.ar(panned, 
            lpFreq: 800,
            size: 1.2,
            revtime: 20.0,
            damping: 0.2,
            earlydiff: 0.8,
            taildiff: 0.95
        );

        // Increased reverb mix for more pronounced effect
        var mix = player + (reverb * 0.5);
        Out.ar(0, mix);

    }.play;
};
