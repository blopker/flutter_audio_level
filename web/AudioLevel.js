window.AudioLevels = {
    _timerID: null,
    _stream: null,
    stopAudioStream: () => {
        if (this._timerID) {
            clearInterval(this._timerID);
        }
        if (this._stream) {
            this._stream.getTracks().forEach(function (track) {
                track.stop();
            });
            this._stream = null;
        }
    },
    getAudioLevel: (cb) => {
        if (this._stream) {
            this.stopAudioStream();
        }
        navigator.mediaDevices.getUserMedia({ audio: true, video: false }).then((_stream) => {
            this._stream = _stream;
            const audioContext = new AudioContext();
            const mediaStreamAudioSourceNode = audioContext.createMediaStreamSource(this._stream);
            const analyserNode = audioContext.createAnalyser();
            mediaStreamAudioSourceNode.connect(analyserNode);
            const pcmData = new Float32Array(analyserNode.fftSize);
            const _tick = () => {
                analyserNode.getFloatTimeDomainData(pcmData);
                let sumSquares = 0.0;
                for (const amplitude of pcmData) { sumSquares += amplitude * amplitude; }
                if (cb) {
                    cb(Math.sqrt(sumSquares / pcmData.length));
                }
            };
            this._timerID = setInterval(_tick, 100);
        });
    },
}
