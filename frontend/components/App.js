import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {push, history, Link} from 'react-router-dom';
import { withRouter } from 'react-router'
import Layout from '../components/layout/layout';

// import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
// import { Navbar, ProgressBar, Col,Row ,Preloader } from 'react-materialize';
// import Navbar from '../components/navbar/navbar';
// import Logo from '../components/navbar/logo-header.png';

export default class App extends Component {

    constructor(props) {
        super(props);
        this.state = {
            open: false,

        };

    }

    render() {

        return (
            <div className="container">
            <Layout />

                <div className="row center" style={{paddingTop:"300px"}}>

                </div>
                <div className="row center">
                    <div className="col s12">
                        <Link to={"/tradesview/" }> GO TO TRADES</Link>
                    </div>
                </div>

            </div>

    );
    }
}