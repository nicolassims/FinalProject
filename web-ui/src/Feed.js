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
    let choices = ['Dragon', 'Medusa', 'Pikachu', 'Werewolf', 'Jerry', 'Creeper', 'Ghost', 'Demon', 'Mimic', 'Ooze', 'Skeleton'];
    let randchoice = choices[Math.floor(Math.random() * choices.length)];

    let nickchoices = ['Draco', 'Dusa', 'Sparky', 'Howler', 'Jerry', 'Ssboom', 'Boo', 'Satanael', 'Doopliss', 'Rimuru', 'Sans'];
    let randnickchoice = nickchoices[Math.floor(Math.random() * nickchoices.length)];

    let monster = {
      name: randchoice,
      nickname: randnickchoice, 
      power: 1,
      location: 0,
      user_id: user.id
    }

    user.food -= cost;
    update_user(user);
    create_monster(monster);
  }
}

function NicknameMonster(monster) {
  let nickname = prompt("What would you like to nickname this " + monster.name + "?");
  if (nickname != null) {
    monster.nickname = nickname;
    update_monster(monster);
  }
}

function Post({monster}) {
  let location = monster.location === 0 ? "The Farm" : "The Wild";
  return (
    <Col>
      <Card className = "card">
        <Card.Title title="Click to rename monster!"
          className="cardbody nickname" 
          onClick={() => NicknameMonster(monster)}>
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

    api_tweet(tweet === "" ? "Join me in Monster Browser! Feed my monsters by liking this tweet!" : tweet).then((resp) => {
      if (resp.error) {
        alert("Sorry, we've encountered an error while attempting to send your tweet. Try again?");
      } else {
        alert("Tweet sent!");
      }
    });
  }

  return (
    <Row>
      <Form onSubmit={on_submit} inline>
        <Form.Control name="tweet"
                      className="longbox"
                      type="text"
                      onChange={(ev) => setTweet(ev.target.value)}
                      placeholder="Join me in Monster Browser! Feed my monsters by liking this tweet!"
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
    cards = monsters
      .sort((a, b) => (a.power < b.power) ? 1 : -1)
      .reduce((acc, monster) => {
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