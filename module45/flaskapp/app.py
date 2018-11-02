from flask import Flask, jsonify
from flask_restful import Api, Resource
from sodapy import Socrata
import pandas as pd


app = Flask(__name__)

api = Api(app)


#df = pd.read_json('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?$limit=100')
client = Socrata("data.cityofnewyork.us", None)
results = client.get("nwxe-4ae8", limit=100)
df = pd.DataFrame.from_records(results)
df = df[['borocode', 'boroname', 'latitude', 'longitude', 'tree_id', 'steward', 'health', 'spc_common']]

@app.route('/')
def home():
    return "<h1>DATA608 Module 4.5</h1>" \
           "<h3>Rose Koh, Fall 2018</h3>" \
           "<p>Create a flask API that responds to information from the URL. </br>" \
           "Look through the sample API provided and test it out for yourself. </br>" \
           "This is using Flask’s jsonify method to return a json blob. </br>" \
           "Make sure you’re able to see both the hello json and are able to see the complex json return values based on the provided url.</br>" \
           "Your goal for this module is to create a rest API that returns something from the tree census. </br>" \
           "It can be anything. Your only requirement is that it needs to accept a variable from the URL.</p>"


class HealthGroup(Resource):

    def get(self):
        df_health = df.groupby(['health', 'spc_common'])[['tree_id']].count().reset_index()

        df_health_json = {
            'Health': df_health['health'].tolist(),
            'Species': df_health['spc_common'].tolist(),
            'Count': df_health['tree_id'].tolist()
        }

        return jsonify(df_health_json)


class StewardGroup(Resource):

    def get(self):
        df_steward = df.groupby(['steward', 'health'])[['tree_id']].count().reset_index()
        df_steward_json = {
            'Steward': df_steward['steward'].tolist(),
            'Health': df_steward['health'].tolist(),
            'Count': df_steward['tree_id'].tolist()
        }

        return jsonify(df_steward_json)


api.add_resource(HealthGroup, '/health')
api.add_resource(StewardGroup, '/steward')

if __name__ == '__main__':
    app.run(debug=True, port=5000)