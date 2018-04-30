import React from 'react'
import ReactDOM from 'react-dom'
import { createStore, combineReducers, applyMiddleware,compose } from 'redux'
import { Provider } from 'react-redux'
import ReduxPromise from 'redux-promise';
import {BrowserRouter} from 'react-router-dom';
import { Router, Route, Switch } from 'react-router'
//import { syncHistoryWithStore, routerReducer } from 'react-router-redux'
import thunkMiddleware from 'redux-thunk'
import createHistory from 'history/createBrowserHistory'
import Trades from './components/trades/trades';
import reducers from './reducers';
import App from './components/App';
// import BuildsView from './components/buildsview/buildsview';


const createStoreWithMiddleware = compose(
        applyMiddleware(ReduxPromise,thunkMiddleware),
        typeof window === 'object' && typeof window.devToolsExtension !== 'undefined' ? window.devToolsExtension() : f => f
)(createStore);

const store = createStore(
    combineReducers({
        reducers,
        //routing: routerReducer
    })
)

const history = createHistory();


// Create an enhanced history that syncs navigation events with the store
// const history = syncHistoryWithStore(browserHistory, store)

ReactDOM.render(
<Provider store={createStoreWithMiddleware(reducers)}>
    { /* Tell the Router to use our enhanced history */ }
    <Router history={history}>

    <Switch>
        <Route path="/tradesview" component={Trades}/> 
        <Route path="/**" component={App}/>
    </Switch>
    </Router>
    </Provider>,
    document.querySelector('#react')
)