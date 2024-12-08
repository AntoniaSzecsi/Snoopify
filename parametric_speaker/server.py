
from flask import Flask, request
import RPi.GPIO as GPIO

# GPIO setup
LED_PIN = 13
GPIO.setmode(GPIO.BCM)
GPIO.setup(LED_PIN, GPIO.OUT)
GPIO.output(LED_PIN, GPIO.LOW)

app = Flask(__name__)

# Endpoint to control LED
@app.route('/toggle_led', methods=['POST'])
def toggle_led():
    data = request.json
    print(data)
    status = data.get('status')
    if status == "on":
        GPIO.output(LED_PIN, GPIO.HIGH)
    elif status == "off":
        GPIO.output(LED_PIN, GPIO.LOW)
    else:
        return {"status": "error", "message": "Invalid state"}, 400
    return {"status": "success", "state": status}

if __name__ == '__main__':
    try:
        app.run(host='0.0.0.0', port=5000)
    except KeyboardInterrupt:
        GPIO.cleanup()
