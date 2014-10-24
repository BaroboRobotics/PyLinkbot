%module(directors="1") linkbot
%{
    #include "PyLinkbotWrapper/src/linkbot_wrapper.hpp"
%}

%feature("director");

/* Set up some exception handling */
%include exception.i

%exception {
    try {
        $function
    } catch(std::exception& e) {
        SWIG_exception(SWIG_RuntimeError, e.what());
    }
}

namespace barobo {
enum MotorDir {
    FORWARD,
    BACKWARD,
    NEUTRAL,
    HOLD
};
}

class _Linkbot {
public:
    _Linkbot(const std::string& serialId) : barobo::Linkbot(serialId) {}
    _Linkbot(const char * serialId) : barobo::Linkbot(serialId) {}
    ~_Linkbot() {}
    std::string serialId () const;

    // All member functions may throw a barobo::Error exception on failure.

    void connect ();
    void disconnect ();

    // Member functions take angles in degrees.
    // All functions are non-blocking. Use moveWait() to wait for non-blocking
    // movement functions.
    void drive (int mask, double, double, double);
    void driveTo (int mask, double, double, double);
    void getJointAngles (int& timestamp, double&, double&, double&, int=10);
    void getAccelerometer (int& timestamp, double&, double&, double&);
    void move (int mask, double, double, double);
    void moveContinuous (int mask, barobo::MotorDir dir1, barobo::MotorDir dir2, barobo::MotorDir dir3);
    void moveTo (int mask, double, double, double);
    void setLedColor (int, int, int);
    void setEncoderEventThreshold (int, double);
    void setJointSpeeds (int mask, double, double, double);
    void stop ();
    void setBuzzerFrequencyOn (float);
    void getVersions (uint32_t&, uint32_t&, uint32_t&);

    void enableButtonEvent(bool enable=true);
    void enableEncoderEvent(bool enable=true);
    void enableAccelerometerEvent(bool enable=true);
    void enableJointEvent(bool enable=true);

    /* Override these */
    virtual void buttonEventCB(int buttonNo, barobo::ButtonState state, int timestamp);
    virtual void encoderEventCB(int joint, double angle, int timestamp);
    virtual void accelerometerEventCB(double x, double y, double z, int timestamp);
    virtual void jointEventCB(int joint, barobo::JointState state, int timestamp);
};
