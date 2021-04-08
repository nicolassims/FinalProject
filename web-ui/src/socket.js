import {Socket} from "phoenix";

// switch out hard-coded url to a config
let socket = null;
let channel = null;

let users_cb = null;

function update(st) {
    let users = st.users;
    console.log("Users:");
    users.forEach(u => console.log(u));
    users_cb(users)
}

export function set_user_cb(func) {
    users_cb = func;
}

export function ch_connect(session) {

    socket = new Socket("ws://localhost:4000/socket", {params: {token: session.token}});

    socket.connect();

    channel = socket.channel("game", {token: session.token})
    channel.on("update", update)
    channel.join()
        .receive("ok", resp => { console.log("Authorized", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })
}

export function ch_disconnect() {
    if (channel) {
        channel.leave();
    }
    channel = null;

    console.log("Disconnecting");
}