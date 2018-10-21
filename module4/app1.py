import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import pandas as pd
import plotly.graph_objs as go
import dash_auth

USERNAME_PASSWORD_PAIRS = [['username', 'password'], ['data608proj4', '1234']]

df = pd.read_json('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?$limit=10000')
# df = pd.read_csv('2015_Street_Tree_Census_-_Tree_Data.csv')
# df = df.rename(columns={'borough': 'boroname'})

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
auth = dash_auth.BasicAuth(app, USERNAME_PASSWORD_PAIRS)
server = app.server

colors = {
    'background': '#8cb8ff',
    'text': '#2376c4'
}

app.layout = html.Div(children=[

    html.Div([
        html.H1('Health of various tree species across each borough'),
        html.H2('NYC Open Data - 2015 Street Tree Census'),
        html.H3('Fall 2018, Rose Koh')
    ], style={'backgroundColor': colors['background']}),

    html.Div([
        html.P('''
              Build a dash app for a arborist studying the health of various tree species (as defined by the variable ‘spc_common’)
              across each borough (defined by the variable ‘borough’).
              This arborist would like to answer the following two questions for each species and in each borough:'''),
        html.H6('1. What proportion of trees are in good, fair, or poor health according to the ‘health’ variable?'),
        html.H6(
            '2. Are stewards (steward activity measured by the ‘steward’ variable) having an impact on the health of trees?'),
        html.Br()
    ]),

    html.Div([
        html.H6(
            'Please select borough in drop-down to filter the data in order to view the data tables and visualizations.')
    ], style={'backgroundColor': colors['background']}),

    dcc.Dropdown(id='drop-down',
                 options=[
                     {'label': 'All', 'value': 'all'},
                     {'label': 'Bronx', 'value': 'bronx'},
                     {'label': 'Brooklyn', 'value': 'brooklyn'},
                     {'label': 'Manhattan', 'value': 'manhattan'},
                     {'label': 'Queens', 'value': 'queens'},
                     {'label': 'Staten Island', 'value': 'staten'}
                 ],
                 value='all'
                 ),

    html.Div([
        html.Div([
            html.H2('Tree species by health proportion (DataTable)'),
            dcc.Graph(id='table1')
        ]),
        html.Div([
            html.H2('Tree species by health proportion (BarStack)'),
            dcc.Graph(id='graph1')
        ]),
        html.Div([
            html.H2('Steward impact on the health of trees (DataTable)'),
            dcc.Graph(id='table2')
        ]),
        html.Div([
            html.H2('Steward impact on the health of trees(BarStack)'),
            dcc.Graph(id='graph2')
        ]),
        html.Div([
            html.H2('Steward impact on the health of trees(Bubble)'),
            dcc.Graph(id='graph3'),
        ])
    ], style={'color': colors['text']}),

    html.Div(id='data-filter', style={'display': 'none'})
])


@app.callback(
    Output('data-filter', 'children'),
    [Input('drop-down', 'value')]
)
def filter_data(dropdown):
    if dropdown == 'bronx':
        df_copy = df[df['boroname'] == 'Bronx'].copy()
    elif dropdown == 'brooklyn':
        df_copy = df[df['boroname'] == 'Brooklyn'].copy()
    elif dropdown == 'queens':
        df_copy = df[df['boroname'] == 'Queens'].copy()
    elif dropdown == 'staten':
        df_copy = df[df['boroname'] == 'Staten Island'].copy()
    elif dropdown == 'manhattan':
        df_copy = df[df['boroname'] == 'Manhattan'].copy()
    else:
        df_copy = df.copy()
    return df_copy.to_json(orient='split')


@app.callback(
    Output('table1', 'figure'),
    [Input('data-filter', 'children')]
)
def update_table1(data):
    df_copy = pd.read_json(data, orient='split')
    df_health = df_copy.groupby(['health', 'spc_common'])[['tree_id']].count().reset_index()
    return {
        'data': [
            go.Table(
                header=dict(values=df_health.columns,
                            fill=dict(color='#C2D4FF'),
                            align=['left'] * 5),
                cells=dict(values=[df_health.health,
                                   df_health.spc_common,
                                   df_health.tree_id],
                           fill=dict(color='#F5F8FF'),
                           align=['left'] * 5))
        ],
        'layout': {
            'title': 'Data Table filtered by borough'
        }
    }


@app.callback(
    Output('graph1', 'figure'),
    [Input('data-filter', 'children')]
)
def update_graph1(data):
    df_copy = pd.read_json(data, orient='split')
    df_health = df_copy.groupby(['health', 'spc_common'])[['tree_id']].count().reset_index().copy()
    good = df_health[df_health['health'] == 'Good']
    fair = df_health[df_health['health'] == 'Fair']
    poor = df_health[df_health['health'] == 'Poor']

    return {
        'data': [go.Bar(x=good['spc_common'],
                        y=good['tree_id'],
                        name='Good', marker={'color': '#1abf51'}),

                 go.Bar(x=fair['spc_common'],
                        y=fair['tree_id'],
                        name='Fair', marker={'color': '#e8d31e'}),

                 go.Bar(x=poor['spc_common'],
                        y=poor['tree_id'],
                        name='Poor', marker={'color': '#a31010'})

                 ],
        'layout': go.Layout(
            barmode='stack',
            xaxis=dict(title='Trees'),
            yaxis=dict(title='number of trees'),
        )
    }


@app.callback(
    Output('table2', 'figure'),
    [Input('data-filter', 'children')]
)
def update_table2(data):
    df_copy = pd.read_json(data, orient='split')
    df_steward = df_copy.groupby(['steward', 'health'])[['tree_id']].count().reset_index().copy()
    return {
        'data': [
            go.Table(
                header=dict(values=df_steward.columns,
                            fill=dict(color='#C2D4FF'),
                            align=['left'] * 5),
                cells=dict(values=[df_steward.steward,
                                   df_steward.health,
                                   df_steward.tree_id],
                           fill=dict(color='#F5F8FF'),
                           align=['left'] * 5))
        ],
        'layout': {
            'title': 'Data Table filtered by borough'
        }
    }


@app.callback(
    Output('graph2', 'figure'),
    [Input('data-filter', 'children')]
)
def update_graph2(data):
    df_copy = pd.read_json(data, orient='split')
    df_steward = df_copy.groupby(['steward', 'health'])[['tree_id']].count().reset_index().copy()
    good = df_steward[df_steward['health'] == 'Good']
    fair = df_steward[df_steward['health'] == 'Fair']
    poor = df_steward[df_steward['health'] == 'Poor']

    return {
        'data': [go.Bar(x=good['steward'],
                        y=good['tree_id'],
                        name='Good',
                        marker={'color': '#1abf51'}),

                 go.Bar(x=fair['steward'],
                        y=fair['tree_id'],
                        name='Fair',
                        marker={'color': '#e8d31e'}),

                 go.Bar(x=poor['steward'],
                        y=poor['tree_id'],
                        name='Poor',
                        marker={'color': '#a31010'})
                 ],
        'layout': go.Layout(
            barmode='stack',
            xaxis=dict(title='stewardship'),
            yaxis=dict(title='number of trees'),
        )
    }


@app.callback(
    Output('graph3', 'figure'),
    [Input('data-filter', 'children')]
)
def update_graph3(data):
    df_copy = pd.read_json(data, orient='split')
    df_steward = df_copy.groupby(['steward', 'health'])[['tree_id']].count().reset_index().copy()

    colormap = {'Good': 'green', 'Fair': 'yellow', 'Poor': 'red'}

    return {
        'data': [go.Scatter(
            x=df_steward['steward'],
            y=df_steward['health'],
            text=df_steward['tree_id'],
            mode='markers',
            opacity=0.7,
            marker=dict(size=0.25 * df_steward['tree_id'], color=[colormap[grade] for grade in df_steward['health']])
        )],
        'layout': go.Layout(
            title='Steward impact on the health of trees',
            xaxis=dict(title='stewardship'),
            yaxis=dict(title='health'),
            hovermode='closest'
        )
    }


if __name__ == '__main__':
    app.run_server()
