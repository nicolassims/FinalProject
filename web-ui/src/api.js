import store from './store';
import { ch_connect } from './socket.js'

function set_token(opts) {
  let state = store.getState();
  let token = state?.session?.token;

  if (opts.headers) {
      opts.headers['x-auth'] = token
  }
  else {
      opts.headers = 
          {
              'x-auth': token
          };
  }
  
  return opts;
}

export function get_twitter_auth() {
  api_get("/twitter").then((data) => {
    console.log("TWITTER AUTH PART 1")
    console.log(data);
    store.dispatch({
      type: "twitter/set",
      data: data,
    });
  });
}

export function api_pinauth(pin, token) {
  return api_post("/twitter", {pin, token});
}

export function api_tokenauth(verifier, token) {
  return api_post("/twitter", {verifier, token}).then((data) => {
    console.log(data);
    if (data.error) {
      alert("Authentication seems to have failed. Try again?");
    } else {
      alert("Authentication succeeded!");
    }
  });
}

export function api_tweet(tweet) {
  return api_post("/twitter", {tweet})
}

export async function api_get(path) {
  let text = await fetch("http://monster-browser.tkwaffle.site/api/v1" + path, set_token({}));
  let resp = await text.json();
  return resp.data;
}

async function api_post(path, data) {
  let opts = {
    method: 'POST',
    headers: { 
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(data)
  };
  console.log(opts);
  let text = await fetch("http://monster-browser.tkwaffle.site/api/v1" + path, set_token(opts));
  return await text.json();
}

async function api_patch(path, data) {
  let opts = {
    method: 'PATCH',
    headers: { 
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(data)
  };
  console.log(opts);
  let text = await fetch("http://monster-browser.tkwaffle.site/api/v1" + path, set_token(opts));
  return await text.json();
}

export function create_user(user) {
  return api_post("/users", {user});
}

export function create_monster(monster) {
  return api_post("/monsters", {monster});
}

export function fetch_users() {
  api_get("/users").then((data) => store.dispatch({
      type: 'users/set',
      data: data,
  }));
}

export function update_user(user) {
  return api_patch("/users/" + user.id, {user});
}

export function api_login(name, password) {
  api_post("/session", {name, password}).then((data) => {
    if (data.session) {
      let action = {
        type: 'session/set',
        data: data.session
      }
      store.dispatch(action);
    } else if (data.error) {
      let action = {
        type: 'error/set',
        data: data.error
      };
      store.dispatch(action);
    }
    if (data.session) {
      ch_connect(data.session); // TODO: Move if needed?
      get_twitter_auth();
    }
  });
}

export function update_monster(monster) {
  return api_patch("/monsters/" + monster.id, {monster});
}

export function fetch_monsters() {
  api_get("/monsters").then((data) => store.dispatch({
      type: 'monsters/set',
      data: data,
  }));
}

export function load_defaults() {
  fetch_users();
  fetch_monsters();
}