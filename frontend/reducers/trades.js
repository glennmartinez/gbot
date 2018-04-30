
import {GETTING_TRADES, GOT_TRADES } from '../actions/trades'


export default function (state = {isFetching:false, trades:[] }, action) {

    switch (action.type) {
        case GETTING_TRADES:
            return Object.assign({}, state, {isFetching: true});

        case GOT_TRADES:
            console.log("IN THE REDUCER")
            console.log(action.data);
            return Object.assign({}, state,{ isFetching: false, trades: action.data.data})

    }

    return state;
}