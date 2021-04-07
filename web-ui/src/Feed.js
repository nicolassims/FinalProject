import { Row, Col, Card, Form, Button } from 'react-bootstrap'
import { connect } from 'react-redux';
import { useState } from 'react';
import { api_tweet, update_monster, update_user } from './api';

function ChangeLocation(monster) {
  if (monster.location === 0) {
    monster.location = 1;
  } else {
    monster.location = 0;
  }
  update_monster(monster);
}

function FeedMonster(monster) {
  monster.user.food -= 10;
  monster.power += 1;
  update_user(monster.user);
  update_monster(monster);
}

function Post({monster}) {
  let location = monster.location === 0 ? "The Farm" : "The Wild";
  return (
    <Col>
      <Card className = "card">
        <Card.Title className="cardbody">
          {monster.nickname}
        </Card.Title>
        <Card.Text className="cardbody">
          Species: {monster.name}<br />
          Power: {monster.power}<br />
          Location: {location}<br />
        </Card.Text>
        <Button onClick={() => ChangeLocation(monster) }>Switch Location</Button>
        <Button onClick={() => FeedMonster(monster) }>Feed Monster</Button>
      </Card>
    </Col>
  );
}

function TweetForm() {
  const [tweet, setTweet] = useState("");

  function on_submit(ev) {
    ev.preventDefault();
    api_tweet(tweet);
  }

  return (
    <Row>
      <Form onSubmit={on_submit} inline>
        <Form.Control name="tweet"
                      type="text"
                      onChange={(ev) => setTweet(ev.target.value)}
                      value={tweet} />   
        <Button variant="primary" type="submit">
          Tweet  
        </Button>          
      </Form>
    </Row>
  );
}

function Feed({monsters, users}) {
  let sess = JSON.parse(localStorage.getItem("session"));
  let cards = null;
  let food = null;
  if (sess != null && users.length !== 0) {
    cards = monsters.reduce((acc, monster) => {
      if (monster.user.id === sess.user_id) {
        acc.push(<Post monster={monster} key={monster.id} />);
      }
      return acc;
    }, [])

    food = users.find(value => { return value.id === sess.user_id; }).food;

    return (
      <div>
        <TweetForm />
        <Row>
          <h1>Food: { food }</h1>
        </Row>
        <Row>
          { cards }
        </Row>
      </div>
    );
  } else {
    return (
      <h1>Log into the game to access your homepage!</h1>
    );
  }
}

export default connect(({monsters, users}) => ({monsters, users}))(Feed);