import store from './store';

export async function api_get(path) {
    let text = await fetch("http://localhost:4000/api/v1" + path, {});
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
    let text = await fetch("http://localhost:4000/api/v1" + path, opts);
    return await text.json();
  }

export function fetch_users() {
    api_get("/users").then((data) => store.dispatch({
        type: 'users/set',
        data: data,
    }));
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
    });
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