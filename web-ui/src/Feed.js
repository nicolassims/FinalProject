import { Row, Col, Card, Form, Button } from 'react-bootstrap'
import { connect } from 'react-redux';
import { useState } from 'react';
import { api_tweet, update_monster, update_user, create_monster } from './api';

function ChangeLocation(monster) {
  if (monster.location === 0) {
    monster.location = 1;
  } else {
    monster.location = 0;
  }
  update_monster(monster);
}

function FeedMonster(monster) {
  let foodamount = Math.round(monster.user.food / 10);
  monster.user.food -= foodamount;
  monster.power += foodamount;
  update_user(monster.user);
  update_monster(monster);
}

function CreateMonster(monsters, user) {
  let nummonsters = monsters.reduce((acc, monster) => {
    return monster.user.id === user.id ? acc + 1 : acc;
  }, 0);
  let cost = Math.pow(10, nummonsters) - 1;
  if (user.food >= cost) {
    let choices = ['Dragon', 'Medusa', 'Pikachu', 'Werewolf', 'Jerry', 'Creeper', 'Ghost'];
    let randchoice = choices[Math.floor(Math.random() * choices.length)];

    let nickchoices = ['Draco', 'Dusa', 'Sparky', 'Howler', 'Jerry', 'Ssboom', 'Boo'];
    let randnickchoice = nickchoices[Math.floor(Math.random() * nickchoices.length)];

    let monster = {
      name: randchoice,
      nickname: randnickchoice, 
      power: 1,
      location: 0,
      user_id: user.id
    }

    console.log(user);
    user.food -= cost;
    update_user(user);
    create_monster(monster);
  }
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
  let foodgain = 0;
  let nummonsters = 0;
  if (sess != null && users.length !== 0) {
    cards = monsters.reduce((acc, monster) => {
      if (monster.user.id === sess.user_id) {
        acc.push(<Post monster={monster} key={monster.id} />);
        foodgain += Math.round(Math.sqrt(monster.power));
        nummonsters++;
      }
      return acc;
    }, [])

    let user = users.find(value => { return value.id === sess.user_id; });
    let cost = Math.pow(10, nummonsters) - 1;
    let monstore = <h5>{cost - user.food} until your next monster!</h5>;

    if (user.food >= cost) {
      monstore = <Button onClick={() => CreateMonster(monsters, user) }>Buy new monster!</Button>;
    }

    return (
      <div>
        <TweetForm />
        <Row>
          <h1>Food: { user.food }</h1>
        </Row>
        <Row>
          <h4>Max food per second: { foodgain }</h4>
        </Row>
        <Row>
          { cards }
        </Row>
        <Row>
          <Col>
            { monstore }
          </Col>
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