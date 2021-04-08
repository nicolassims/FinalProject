import { useLocation } from 'react-router-dom';
import { api_tokenauth } from './api';
import { connect } from 'react-redux';
import { useHistory } from 'react-router-dom';

// Found in https://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
function getParameterByName(name, search) {
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
        results = regex.exec(search);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
}

function TwitterAuth({twitter}) {

    let loc = useLocation();

    let search = loc.search;
    console.log(search);

    let oauth_token = getParameterByName("oauth_token", search);
    console.log(oauth_token);

    let oauth_verifier = getParameterByName("oauth_verifier", search);
    console.log(oauth_verifier);

    console.log(twitter.req_token);

    api_tokenauth(oauth_verifier, oauth_token);

    let hist = useHistory();

    hist.push("/");

    return (
        <div>
        </div>
    );
}

export default connect(({twitter}) => ({twitter}))(TwitterAuth);