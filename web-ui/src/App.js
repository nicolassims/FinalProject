import { Container } from 'react-bootstrap';
import { Switch, Route } from 'react-router-dom';

import "./App.scss";
import Users from "./Users";
import Nav from "./Nav";
import Feed from "./Feed";

import * as socket from './socket.js'
import { useEffect } from 'react'

function App() {

  return (
    <Container>
      <Nav />
      <Switch>
        <Route path="/" exact>
          <Feed />
        </Route>
        <Route path="/users" exact>
          <Users />
        </Route>
      </Switch>
    </Container>
  );
}

export default App;