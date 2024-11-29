from flask import Flask, request, jsonify
from calculator import calculate
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

@app.route('/calculate', methods=['POST'])
def calculate_endpoint():
    try:
        data = request.get_json()
        expression = data.get('expression', '')
        result = calculate(expression)
        return jsonify({'result': result})
    except Exception as e:
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
