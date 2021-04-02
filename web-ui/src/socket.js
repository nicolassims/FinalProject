import {Socket} from "phoenix"

// switch out hard-coded url to a config
let socket = null;

export function connect(session) {

    socket = new Socket("ws://localhost:4000/socket", {params: {token: session.token}});

    socket.connect();

    let channel = socket.channel("game", {token: session.token})

    channel.join()
        .receive("ok", resp => { console.log("Authorized", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })
}