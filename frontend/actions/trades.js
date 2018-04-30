import axios from 'axios';

const  BUILDS_URL = `/trades`
const PLANS_URL = `/reactuniqueplans`


export const GETTING_TRADES = "GETTING_TRADES"
export const GOT_TRADES = "GOT_TRADES"

// export const GETTING_PLANS = "GETTING_PLANS"
// export const GOT_PLANS = "GOT_PLANS"


export function getTrades(plan){

    return function (dispatch) {
        dispatch(gettingTrades());
        return axios.get( BUILDS_URL).then(response => dispatch(
             gotTrades(response)
        ))
    }
}


export function gettingTrades() {

    return {
        type: GETTING_TRADES
    }
}

export function gotTrades(response) {
    return {
        type: GOT_TRADES,
        data: response
    }
}

