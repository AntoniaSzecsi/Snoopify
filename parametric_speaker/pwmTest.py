import pigpio

PWM_PIN = 13  # GPIO pin for PWM output

pi = pigpio.pi()
if not pi.connected:
    print("Failed to connect to pigpio daemon!")
    exit()

pi.hardware_PWM(PWM_PIN, 40000, 500000)  # Duty cycle in 0-1000000 range

input('Enter to stop...')

pi.set_mode(PWM_PIN, pigpio.INPUT)
pi.stop()