import { Row, Col, Card, Form, Button } from 'react-bootstrap'
import { connect } from 'react-redux';
import { useState } from 'react';
import { api_tweet } from './api';



function Post({monster}) {
  return (
    <Col>
      <Card>
        <Card.Title>
          {monster.name}
        </Card.Title>
        <Card.Text>
          {monster.nickname}
        </Card.Text>
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
    <Form onSubmit={on_submit} inline>
      <Form.Control name="tweet"
                    type="text"
                    onChange={(ev) => setTweet(ev.target.value)}
                    value={tweet} />   
      <Button variant="primary" type="submit">
        Tweet  
      </Button>          
    </Form>
  );
}

function Feed({monsters}) {
  let cards = monsters.reduce((acc, monster) => {
    let sess = JSON.parse(localStorage.getItem("session"));
    if (sess != null && monster.user.id === sess.user_id) {
      acc.push(<Post monster={monster} key={monster.id} />);
    }
    return acc;
  }, [])

  return (
    <Row>
      { cards }
      <TweetForm />
    </Row>
  );
}

export default connect(({monsters}) => ({monsters}))(Feed);