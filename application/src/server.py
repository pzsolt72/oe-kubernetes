# server.py

from flask import Flask, jsonify

app = Flask(__name__)

tasks = [
    {
        'id': 1,
        'type': 'PEO',
        'env': 'DTA01',
        'sid': 'PED'
    },
    {
        'id': 2,
        'type': 'PEO',
        'env': 'DTA01',
        'sid': 'PET'
    },
    {
        'id': 3,
        'type': 'PEO',
        'env': 'DTA02',
        'sid': 'PEA'
    },
    {
        'id': 4,
        'type': 'PEO',
        'env': 'PRD01',
        'sid': 'PEP'
    },    
]

@app.route('/sapsystems', methods=['GET'])
def get_tasks():
    return jsonify({'tasks': tasks})

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0', port=8080)