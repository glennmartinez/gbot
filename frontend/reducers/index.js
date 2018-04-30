
import { combineReducers } from 'redux';
import tradesReducer from './trades';

const rootReducer = combineReducers({

    tradesReducer: tradesReducer
});

export default rootReducer;