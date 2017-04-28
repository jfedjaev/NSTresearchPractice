import sys
import json
import urllib

# ip = sys.argv[1] if len(sys.argv) > 1 else "172.26.5.101"
# ip = sys.argv[1] if len(sys.argv) > 1 else "192.168.168.232"
ip = sys.argv[1] if len(sys.argv) > 1 else "10.162.242.242"

base_url = "http://" + ip + "/cgi-bin/"

verbose = True


def _request(request_path):
    answer = urllib.urlopen(base_url + request_path).read()
    if verbose:
        print(base_url + request_path)
        print(answer)
    return answer


def _buf_to_json(buf):
    key_to_val = {}
    for line in buf.decode("ascii").split("\n"):
        try:
            key, val = line.split("=")
        except:
            continue
        key_to_val[key] = val

    return json.dumps(key_to_val, indent=4, sort_keys=True)


def diagnose():
    print(_buf_to_json(_request("ReadFile.exe?Diagnose_Logfiles")))


def calibrate():
    _request("writeVal.exe?CALIBRATE+1")


def move(axis, position):
    if not 1 <= axis <= 6:
        print("axis must be between 1 and 6")
        raise
        # could change destination for multiple axes 
    _request("writeVal.exe?M{0}_DESTINATION+{1}".format(
        str(axis), str(position)))
    _request("writeVal.exe?MOVE_ALL_TO_ENC+1")


def disconnect():
    _request("writeVal.exe?DISCONNECT+1")


def connect():
    _request("writeVal.exe?CONNECT+1")


def get_pos_err(axis):
    if not 1 <= axis <= 6:
        print("axis must be between 1 and 6")
        raise
    _request("writeVal.exe?GET_POS_ERR_{0}+1".format(axis))


def set_pos_err(axis, pos_err):
    if not 1 <= axis <= 6:
        print("axis must be between 1 and 6")
        raise
    _request("writeVal.exe?POS_ERR_{0}+{1}".format(axis, pos_err))
    _request("writeVal.exe?SET_POS_ERR_{0}+1".format(axis))


def set_vel(axis, vel):
    if not 1 <= axis <= 6:
        print("axis must be between 1 and 6")
        raise
    _request("writeVal.exe?VEL_ERR_{0}+{1}".format(axis, vel))
    _request("writeVal.exe?SET_VEL_ERR_{0}+1".format(axis))


def control():
    print(_buf_to_json(_request("ReadFile.exe?Steuerung")))


# def get_srv_info():
#     print(_buf_to_json(_request("GetSrvInfo.exe")))


# def start_info_server():
#     _request("OrderValues.exe?Start+dummy+100+SENSOR_CONFIG+DATASERVER_ENABLED")
#     _request("ReadFile.exe?Start")


def init():
    disconnect()
    connect()
