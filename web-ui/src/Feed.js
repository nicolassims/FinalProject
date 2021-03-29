import { Row, Col, Card } from 'react-bootstrap';
import { connect } from 'react-redux';



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

function Feed({monsters}) {
  let cards = monsters.map((monster) => <Post monster={monster} key={monster.id} />);
  return (
    <Row>
      { cards }
    </Row>
  );
}

export default connect(({monsters}) => ({monsters}))(Feed);