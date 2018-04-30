

import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {push, history, Link} from 'react-router-dom';
import { withRouter } from 'react-router';


// import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
 import { Navbar,NavItem, ProgressBar, Col,Row ,Preloader } from 'react-materialize';
// import Navbar from '../components/navbar/navbar';
// import Logo from '../components/navbar/logo-header.png';

export default class Layout extends Component {

    constructor(props) {
        super(props);
        this.state = {
            open: false,

        };

    }

    render() {

        return (
            <div>
            <Navbar brand='Gbot' right>
                <NavItem href='/tradesview'>Trades</NavItem>
                <NavItem href='components.html'>Charts</NavItem>
            </Navbar>

                { this.props.children }

            </div>
    );
    }
}