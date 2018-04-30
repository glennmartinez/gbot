import React, { Component } from 'react';
import { withRouter } from 'react-router'
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import {Row,  Col, Button, ProgressBar, Icon, Badge} from 'react-materialize';
import { getTrades } from '../../actions/trades';
import Layout from '../../components/layout/layout'
// import { Chart } from 'react-google-charts';
// import ChartView from '../chartsview/chart';
// import ChartBuildTimes from '../chartsview/chartbuildtimes';
// import ChartFailedTests from '../chartsview/chartfailedtests';
// import PieChartView from '../chartsview/piechartview';
// import TestTableView from '../chartsview/testtableview';
// import Navbar from '../navbar/navbar';

class Trades extends Component {

    constructor(props){
        super(props);

        this.state = {
            columns: [
                {
                    type: 'number',
                    label: 'Time',
                },
                {
                    type: 'number',
                    label: 'Job',
                },
            ],

            // options:{legend:true, hAxis:{title:"Jobs"},
            //     vAxis:{title:'Seconds',minValue: 0, maxValue: 5000}}
            options: {
                title: 'Historical build run time (seconds)',
                hAxis: { title: 'Job' },
                vAxis: { title: 'Time' },
                legend: 'none',
            },
            planname:''
        }
        this.componentDidMount = this.componentDidMount.bind(this);
        this.clickHandler = this.clickHandler.bind(this);
        this.divStyle = this.divStyle.bind(this);


    }

    componentDidMount(){
        this.props.getTrades();

    }

    clickHandler(project){
         this.props.getBuilds(project);
         this.setState({planname: project})
        console.log("viewing clickhandler", this.state.planname);
     }

    divStyle(){
        divStyle = {
            padding: '10px',
        };
        return divStyle;
    }

    render(){
        const { trades} = this.props.tradesReducer;
        const buttonStyle = {
            padding: "10px"
        }
        return(
            <div className="container">
                <Layout />
                <div className="row">

                { trades.length && trades.map(TRADE =>{
                    console.log(TRADE.time)
                    return (
                        <p key={TRADE.time}>{TRADE.time}</p>
                    )
                }) }
                </div>

            </div>

        )
    }
}

function mapStateToProps({tradesReducer}) {
        console.log("In the view");
        console.log(tradesReducer);
    return { tradesReducer: tradesReducer, isFetching: tradesReducer.isFetching };
}

function mapDispatchToProps(dispatch) {
    return bindActionCreators({ getTrades} , dispatch);
}


export default withRouter(connect(mapStateToProps, mapDispatchToProps )(Trades));