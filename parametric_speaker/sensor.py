import RPi.GPIO as GPIO
import time
import numpy as np

# GPIO setup
GPIO.setmode(GPIO.BCM)
GPIO.setup(16, GPIO.OUT)  # Use GPIO13 for PWM

# PWM setup
pwm_freq = 40000  # 40 kHz carrier
mod_freq = 1000   # 1 kHz modulating signal
pwm = GPIO.PWM(13, pwm_freq)
pwm.start(50)  # Start with 50% duty cycle

# Generate AM signal
duration = 5  # Duration in seconds
sample_rate = 100000  # High enough to simulate modulation
t = np.linspace(0, duration, int(sample_rate * duration), endpoint=False)
mod_signal = 1 + 0.5 * np.sin(2 * np.pi * mod_freq * t)  # Modulation index = 0.5
carrier_signal = 0.5 + 0.5 * np.sin(2 * np.pi * pwm_freq * t)  # Carrier

# AM Signal
am_signal = carrier_signal * mod_signal

# Normalize AM signal to [0, 1]
am_signal_normalized = (am_signal - np.min(am_signal)) / (np.max(am_signal) - np.min(am_signal))

# Output AM signal via GPIO
try:
    for value in am_signal_normalized:
        pwm.ChangeDutyCycle(value * 100)  # Scale to 0-100%
        time.sleep(1 / sample_rate)       # Maintain sample rate
finally:
    pwm.stop()
    GPIO.cleanup()