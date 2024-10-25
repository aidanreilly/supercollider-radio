// F. Uwe Laysiepen / Marina Abramoviç "Bioguarde" (4:43), 1982

s.waitForBoot {
    // Load the sample into a buffer
    ~buffer = Buffer.read(s, "./Live-To-Air_6-4-FULaysiepen+MAbramovic.wav");

    {
        // Play the buffer in stereo (2 channels), looping continuously
        var player = PlayBuf.ar(2, ~buffer, BufRateScale.kr(~buffer), loop: 1);

        // Simple delay chain
        var delay = Mix.fill(5, { |i|
            DelayC.ar(player, 1.5, 1 / (2 ** (i + 1))) * (0.5 ** (i + 1))
        });

        // Simple reverb using JPverb with supported parameters
        var reverb = JPverb.ar(delay, 
            t60: 10,
            damp: 0.3,
            size: 3,
            earlyDiff: 0.606,
            modDepth: 0.4,
            modFreq: 5,
            low: 0.2,
            mid: 0.3,
            high: 0.6,
            lowcut: 200,
            highcut: 5000
        );

        // Combine dry and wet signals
        var mix = player + (reverb * 0.5);
        Out.ar(0, mix);

    }.play;
};
