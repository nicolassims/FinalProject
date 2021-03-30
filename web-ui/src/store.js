import { createStore, combineReducers } from 'redux';

function users(state = [], action) {
    switch (action.type) {
    case 'users/set':
        return action.data;
    default:
        return state;
    }
}

function monsters(state = [], action) {
    switch(action.type) {
        case 'monsters/set': return action.data;
        default: return state;
    }
}

function user_form(state = {}, action) {
    switch (action.type) {
    case 'user_form/set':
        return action.data;
    default:
        return state
    }
}

function session(state = null/*restore_session()*/, action) {
    switch (action.type) {
      case 'session/set': 
        //save_session(action.data);
        return action.data;
      case 'session/clear': return null;
      default: return state;
    }
  }

function root_reducer(state, action) {
    console.log("root_reducer", state, action);
    let reducer = combineReducers({
        users, user_form, monsters, session
    });
    return reducer(state, action);
}

let store = createStore(root_reducer);
export default store;