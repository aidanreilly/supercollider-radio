// F. Uwe Laysiepen / Marina Abramoviç "Bioguarde" (4:43), 1982

s.waitForBoot {
    // Load the sample into a buffer
    ~buffer = Buffer.read(s, "./Live-To-Air_6-4-FULaysiepen+MAbramovic.wav");

    {
        // Play the buffer in stereo (2 channels), looping continuously
        var player = PlayBuf.ar(2, ~buffer, BufRateScale.kr(~buffer), loop: 1);

        // Simple ping-pong delay
        var ping = DelayC.ar(player, 1.5, 2.2);
        var pong = DelayC.ar(ping, 2.5, 1.2);
        var panned = Pan2.ar(pong, SinOsc.kr(0.8).range(-1, 1)); // Panning left and right

        // Throw some verb on it
        var reverb = JPverb.ar(panned, 
            lpFreq: 1000,
            size: 0.9,
            revtime: 10.0,
            damping: 0.3,
            earlydiff: 0.7,
            taildiff: 0.9
        );

        var mix = player + (reverb * 0.2);
        Out.ar(0, mix);

    }.play;
};
