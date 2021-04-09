import {Socket} from "phoenix";

// switch out hard-coded url to a config
let socket = null;
let channel = null;

let users_cb = null;
let monsters_cb = null;

function update(st) {
    let users = st.users;
    users_cb(users);
}

function updatemonsters(st) {
    let monsters = st.monsters;
    monsters_cb(monsters);
}

export function set_user_cb(func) {
    users_cb = func;
}

export function set_monster_cb(func) {
    monsters_cb = func;
}

export function ch_connect(session) {

    socket = new Socket("ws://monster-browser.tkwaffle.site/socket", {params: {token: session.token}});

    socket.connect();

    channel = socket.channel("game", {token: session.token})
    channel.on("update", update);
    channel.on("updatemonsters", updatemonsters);
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