import { Container } from 'react-bootstrap';
import { Switch, Route } from 'react-router-dom';

import "./App.scss";
import Nav from "./Nav";
import Feed from './Feed';
import UsersList from './Users/List';
import UsersNew from './Users/New';
import store from './store';
import { set_user_cb, ch_connect } from './socket';
import { connect } from 'react-redux';
import { get_twitter_auth } from './api';

function App({session}) {
  
  // set socket cb to allow updating users from server through socket
  set_user_cb((data) => {
    store.dispatch({
      type: 'users/set',
      data: data,
    })
  });

  // if session is saved, connect socket, and get twitter auth url
  if (session) {
    ch_connect(session); // TODO: Move if needed?
    get_twitter_auth();
  }

  return (
    <Container>
      <Nav />
      <Switch>
        <Route path="/" exact>
          <Feed />
        </Route>
        <Route path="/users" exact>
          <UsersList />
        </Route>
        <Route path="/users/new">
          <UsersNew />
        </Route>
      </Switch>
    </Container>
  );
}

export default connect(({session}) => ({session}))(App);