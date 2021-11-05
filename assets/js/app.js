// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
// import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import Tone from "../vendor/tone.min.js"

let synth = undefined;
let reverb = undefined;
let delay = undefined;

const modeBtnId = "mode";
const audioBtnId = "audio-btn";
const adsr = "adsr";
const reverbId = "slider_reverb";
const delayId = "slider_delay";

if (document.getElementById(modeBtnId)) {
  document.getElementById(modeBtnId).addEventListener("click", (e) => {
    const body = document.body;
    body.classList.toggle("dark");
  })
}

// if (document.getElementById(audioBtnId)) {
  document.getElementById(audioBtnId).addEventListener("click", function() {
    Tone.context.resume().then(() => {
      console.log('Playback resumed successfully');
      synth = new Tone.PolySynth({
        maxPolyphony: 48,
        voice: Tone.Synth,
        volume: -6,
        options: {
          envelope : {
            attack : 2,
            decay : 1.8,
            sustain : 1,
            release : 10
          }
        }
      })

      reverb = new Tone.Reverb(0.7);
      delay = new Tone.PingPongDelay("3n", 0.5);
      const compressor = new Tone.Compressor(-30, 3);
      
      /**
       * Audio effects chain:
       *
       * [PolySynth] --> [Reverb] --> [Delay] --> [Compressor] --> Output
       */
      synth.connect(reverb);
      reverb.connect(delay);
      delay.connect(compressor);
      compressor.toDestination();

      synth.triggerAttackRelease("C4", "8n");
    });
  });
// }

let beep = (col) => {
  if (!col.classList.contains("active")) return;

  let notes = [];
  for (let i = 0; i < col.children.length; i++) {
    if (col.children[i].classList.contains("active")) {
      notes.push(col.children[i].getAttribute("data-note"));
    }
  }
  if (notes.length > 0 && synth) {
    const adsrInputs = document.getElementById(adsr).getElementsByTagName("input");
    const envelope = {};
    for (let i = 0; i < adsrInputs.length; i++) {
      envelope[adsrInputs[i].id] = parseFloat(adsrInputs[i].getAttribute("data-value"))
    }
    synth.set({
      envelope : {
        attack : envelope["a"],
        decay : envelope["d"],
        sustain : envelope["s"],
        release : envelope["r"]
      }
    });

    reverb.set({wet: parseFloat(document.getElementById(reverbId).value)/100.0 || 0.01});
    delay.set({wet: parseFloat(document.getElementById(delayId).value)/100.0});

    synth.triggerAttackRelease(notes, 0.5);
  }
}

let Hooks = {}
Hooks.ColumnActive = {
  updated() {
    let col = this.el;
    beep(col);
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// connect if there are any LiveViews` on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
