import SOAPpy


class KatanaSoap:
    def __init__(self, ip="10.162.242.242", port="8000"):
        self.katana = SOAPpy.SOAPProxy("http://" + ip + ":" + port)

    def calibrate(self):
        self.katana.calibrate()

    def moveMotAndWait(self, axis, pos):
        self.katana.moveMotAndWait(axis, pos)
