import platform, os, time, copy, pygame, sys
from Crypto.Cipher import AES
from Crypto import Random

g_system_platform = platform.system()
if g_system_platform == "Windows":
    import pywinusb.hid as hid
else:
    import hidapi
    hidapi.hid_init()

g_sensor_bits = {
    'F3':  [10,  11,  12,  13,  14,  15,  0,   1,   2,   3,   4,   5,   6,   7],
    'FC5': [28,  29,  30,  31,  16,  17,  18,  19,  20,  21,  22,  23,  8,   9],
    'AF3': [46,  47,  32,  33,  34,  35,  36,  37,  38,  39,  24,  25,  26,  27],
    'F7':  [48,  49,  50,  51,  52,  53,  54,  55,  40,  41,  42,  43,  44,  45],
    'T7':  [66,  67,  68,  69,  70,  71,  56,  57,  58,  59,  60,  61,  62,  63],
    'P7':  [84,  85,  86,  87,  72,  73,  74,  75,  76,  77,  78,  79,  64,  65],
    'O1':  [102, 103, 88,  89,  90,  91,  92,  93,  94,  95,  80,  81,  82,  83],
    'O2':  [140, 141, 142, 143, 128, 129, 130, 131, 132, 133, 134, 135, 120, 121],
    'P8':  [158, 159, 144, 145, 146, 147, 148, 149, 150, 151, 136, 137, 138, 139],
    'T8':  [160, 161, 162, 163, 164, 165, 166, 167, 152, 153, 154, 155, 156, 157],
    'F8':  [178, 179, 180, 181, 182, 183, 168, 169, 170, 171, 172, 173, 174, 175],
    'AF4': [196, 197, 198, 199, 184, 185, 186, 187, 188, 189, 190, 191, 176, 177],
    'FC6': [214, 215, 200, 201, 202, 203, 204, 205, 206, 207, 192, 193, 194, 195],
    'F4':  [216, 217, 218, 219, 220, 221, 222, 223, 208, 209, 210, 211, 212, 213]
    }
g_quality_bits = [99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112]
g_battery_values = {
    "255": 100, "254": 100, "253": 100, "252": 100, "251": 100, "250": 100, "249": 100, "248": 100, "247": 99, "246": 97,
    "245": 93,  "244": 89,  "243": 85,  "242": 82,  "241": 77,  "240": 72,  "239": 66,  "238": 62,  "237": 55, "236": 46,
    "235": 32,  "234": 20,  "233": 12,  "232": 6,   "231": 4,   "230": 3,   "229": 2,   "228": 2,   "227": 2,  "226": 1,
    "225": 0,   "224": 0,
    }
g_empty_sensor_dict = {
    'PcktsTot':  {'value': -9999, 'quality': 0},
    'PcktsLoop': {'value': -9999, 'quality': 0},
    'TimeAbs':   {'value': -9999, 'quality': 0},
    'TimeRel':   {'value': -9999, 'quality': 0},
    'KeyDown':   {'value':     0, 'quality': 0},
    'F3':        {'value': -9999, 'quality': 0},
    'FC6':       {'value': -9999, 'quality': 0},
    'P7':        {'value': -9999, 'quality': 0},
    'T8':        {'value': -9999, 'quality': 0},
    'F7':        {'value': -9999, 'quality': 0},
    'F8':        {'value': -9999, 'quality': 0},
    'T7':        {'value': -9999, 'quality': 0},
    'P8':        {'value': -9999, 'quality': 0},
    'AF4':       {'value': -9999, 'quality': 0},
    'F4':        {'value': -9999, 'quality': 0},
    'AF3':       {'value': -9999, 'quality': 0},
    'O2':        {'value': -9999, 'quality': 0},
    'O1':        {'value': -9999, 'quality': 0},
    'FC5':       {'value': -9999, 'quality': 0},
    'X':         {'value': -9999, 'quality': 0},
    'Y':         {'value': -9999, 'quality': 0},
    'Battery':   {'value':     0, 'quality': 0},
    'Unknown':   {'value':     0, 'quality': 0}
    }


#globals user should set
g_is_research = False #apparently no way to auto-detect? Not clear it would work even if True
g_inter_sample_sleep_time = .001 #shouldn't really have to touch, but might want to tweak?
g_keypress_to_monitor = pygame.K_0

#globals the program sets; don't worry about these
g_battery = 0
g_raw_encryped_packets = []
g_raw_decrypted_packets = []
g_processed_packets = []
g_packet_timestamps = []
g_old_model = True
g_running = True
g_screen = None
g_packet_counter = 0
g_serial_number = ''
g_device = ''
g_os_decryption = False
g_crypto_cipher = ''
g_total_packet_counter = 0
g_ts_start = time.time()
g_key_down = False
g_key_timestamp = 0
g_outfile = 0
g_draw_keypress = False

######################
######################
def init_everything():
    global g_screen
    global g_running
    global g_system_platform
    
    if g_system_platform == "Windows":
        find_init_emotiv_windows()
    else:
        find_init_emotiv_non_windows()
    
    if g_running and g_os_decryption == False:
        init_crypto()
    
    if g_running:
        pygame.init()
        g_screen = pygame.display.set_mode((800, 600))

###############################
def find_init_emotiv_windows():
    global g_serial_number
    global g_device
    global g_old_model
    
    g_device = ''
    device_list = []
    is_emotiv = False
    try:
        for this_device in hid.find_all_hid_devices():
            if "Emotiv" in this_device.vendor_name:
                is_emotiv = True
            elif "Emotiv" in this_device.product_name:
                is_emotiv = True
            elif "EPOC" in this_device.product_name:
                is_emotiv = True
            elif "Brain Waves" in this_device.product_name:
                is_emotiv = True
            elif this_device.product_name == '00000000000':
                is_emotiv = True
            elif "EEG Signals" in this_device.product_name:
                is_emotiv = True
            
            if is_emotiv:
                device_list.append( this_device )
    except:
        pass
    
    if len(device_list) < 2: #seemingly always shows up as two devices on Windows?
        print("Could not find device.")
        shutdown_everything()
        return
    try:
        g_device = device_list[1] #seemingly the second device is always the right choice?
        g_device.open()
        g_serial_number = g_device.serial_number
        g_old_model = is_old_model(g_serial_number)
        g_device.set_raw_data_handler(windows_raw_encrypted_data_handler)
    except Exception, ex:
        print ex.message
        shutdown_everything()

###################################
def find_init_emotiv_non_windows():
    global g_serial_number
    global g_os_decryption
    global g_device
    global g_old_model
    
    device_path = ''
    devices = hidapi.hid_enumerate()
    for device in devices:
        is_emotiv = False
        try:
            if "Emotiv" in device.manufacturer_string:
                is_emotiv = True
            elif "Emotiv" in device.product_string:
                is_emotiv = True
            elif "EPOC" in device.product_string:
                is_emotiv = True
            elif "Brain Waves" in device.product_string:
                is_emotiv = True
            elif device.product_string == '00000000000':
                is_emotiv = True
            elif "EEG Signals" in device.product_string:
                is_emotiv = True

            if is_emotiv:
                g_serial_number = device.serial_number
                device_path = device.path
                break
        except:
            pass

    if g_serial_number == '':
        print("Could not find device.")
        shutdown_everything()
        return
    
    g_old_model = is_old_model(g_serial_number)
    g_os_decryption = os.path.exists('/dev/eeg/raw')
    if g_os_decryption:
        g_device = open("/dev/eeg/raw")
    else:
        try:
            g_device = hidapi.hid_open_path(device_path)
        except Exception, ex:
            print ex.message
            shutdown_everything()

##################
def init_crypto():
    global g_crypto_cipher
    global g_is_research
    global g_serial_number
    
    k = ['\0'] * 16
    k[0] = g_serial_number[-1]
    k[1] = '\0'
    k[2] = g_serial_number[-2]
    if g_is_research:
        k[3] = 'H'
        k[4] = g_serial_number[-1]
        k[5] = '\0'
        k[6] = g_serial_number[-2]
        k[7] = 'T'
        k[8] = g_serial_number[-3]
        k[9] = '\x10'
        k[10] = g_serial_number[-4]
        k[11] = 'B'
    else:
        k[3] = 'T'
        k[4] = g_serial_number[-3]
        k[5] = '\x10'
        k[6] = g_serial_number[-4]
        k[7] = 'B'
        k[8] = g_serial_number[-1]
        k[9] = '\0'
        k[10] = g_serial_number[-2]
        k[11] = 'H'
    k[12] = g_serial_number[-3]
    k[13] = '\0'
    k[14] = g_serial_number[-4]
    k[15] = 'P'
    key = ''.join(k)
    iv = Random.new().read(AES.block_size)
    g_crypto_cipher = AES.new(key, AES.MODE_ECB, iv)

##########################
def get_level(data, bits):
    """
    Returns sensor level value from data using sensor bit mask in micro volts (uV).
    MRJ note: I don't think this is actually microvolts, but a multiple of them (multiply these vals by .51 for the original EPOC to get uV?)
    MRJ note 2: Took ord() out of this function -- can do it beforehand
    """
    level = 0
    for i in range(13, -1, -1):
        level <<= 1
        b, o = (bits[i] / 8) + 1, bits[i] % 8
        level |= (data[b] >> o) & 1
    return level

################################
def is_old_model(serial_number):
    if "GM" in serial_number[-2:]:
        return False
    return True

################################
def process_incoming_raw_data():
    # for non-Windows; Windows has windows_raw_encrypted_data_handler()
    global g_os_decryption
    global g_device
    global g_raw_decrypted_packets
    global g_raw_encryped_packets
    global g_packet_timestamps
    
    #this_packet = 'xxx'
    #while this_packet != '':
    if g_os_decryption:
        this_packet = g_device.read(32)
        this_timestamp = time.time()
        if this_packet != '':
            g_raw_decrypted_packets.append( this_packet )
            g_packet_timestamps.append( this_timestamp )
    else:
        this_packet = hidapi.hid_read( g_device, 34 )
        this_timestamp = time.time()
        if len(this_packet) == 32:
            this_packet.insert(0, 0)
        if this_packet != '':
            this_packet = ''.join(map(chr, this_packet[1:]))
            g_raw_encryped_packets.append( this_packet )
            g_packet_timestamps.append( this_timestamp )

#############################################################
def windows_raw_encrypted_data_handler( raw_encrypted_data ):
    global g_raw_encryped_packets
    global g_packet_timestamps
    
    assert raw_encrypted_data[0] == 0
    this_packet = ''.join(map(chr, raw_encrypted_data[1:]))
    g_raw_encryped_packets.append( this_packet )
    g_packet_timestamps.append( time.time() )

###########################
def process_crypto_queue():
    global g_raw_encryped_packets
    global g_raw_decrypted_packets
    global g_crypto_cipher
    
    while len(g_raw_encryped_packets) > 0:
        this_packet = g_raw_encryped_packets.pop(0)
        this_packet = g_crypto_cipher.decrypt(this_packet[:16]) + g_crypto_cipher.decrypt(this_packet[16:])
        this_packet = map(ord, this_packet)
        g_raw_decrypted_packets.append(this_packet)

#####################################
def process_decrypted_packet_queue():
    global g_raw_decrypted_packets
    global g_processed_packets
    
    while len(g_raw_decrypted_packets) > 0:
        try:
            this_packet = g_raw_decrypted_packets.pop(0)
            this_timestamp = g_packet_timestamps.pop(0)
            this_packet = process_decrypted_packet(this_packet, this_timestamp)
            g_processed_packets.append(this_packet)
        except:
            print "Packet/timestamp mismatch! Look into this more later."

###################################################
def process_decrypted_packet( raw_decrypted_data, timestamp ):
    global g_battery
    global g_battery_values
    global g_empty_sensor_dict
    global g_total_packet_counter
    global g_sensor_bits
    global g_old_model
    global g_quality_bits
    global g_ts_start
    global graph_quals
    global g_key_down
    global g_key_timestamp
    
    this_packet = copy.deepcopy(g_empty_sensor_dict)
    g_total_packet_counter += 1
    packet_loop_counter = raw_decrypted_data[0]
    
    if packet_loop_counter > 127:
        g_battery = g_battery_values[str(packet_loop_counter)]
    
    this_packet['PcktsTot']['value']  = g_total_packet_counter
    this_packet['PcktsLoop']['value'] = packet_loop_counter
    this_packet['TimeAbs']['value']   = timestamp
    this_packet['TimeRel']['value']   = timestamp - g_ts_start
    if g_key_down:
        this_packet['KeyDown']['value']   = 1
        this_packet['KeyDown']['quality'] = (g_key_timestamp - g_ts_start) #not really quality, but whatever
        g_key_down = False
        g_key_timestamp = 0
    else:
        this_packet['KeyDown']['value']   = 0
        this_packet['KeyDown']['quality'] = 0 #not really quality, but whatever
    
    this_packet['X']['value']         = raw_decrypted_data[29] - 106 #possibly change to 127 for EPOC+?
    this_packet['Y']['value']         = raw_decrypted_data[30] - 105 #ditto
    for name, bits in g_sensor_bits.items():
        # Get Level for sensors subtract 8192 to get signed value
        value = get_level(raw_decrypted_data, bits) - 8192
        this_packet[name]['value']    = value
    this_packet['Battery']['value']   = g_battery
    
    #now do quality
    if g_old_model:
        current_contact_quality = get_level(raw_decrypted_data, g_quality_bits) / 540.0
    else:
        current_contact_quality = get_level(raw_decrypted_data, g_quality_bits) / 1024.0
    
    if packet_loop_counter == 0 or packet_loop_counter == 64:
        this_packet['F3']['quality'] = current_contact_quality
        graph_quals['F3'] = current_contact_quality
    elif packet_loop_counter == 1 or packet_loop_counter == 65:
        this_packet['FC5']['quality'] = current_contact_quality
        graph_quals['FC5'] = current_contact_quality
    elif packet_loop_counter == 2 or packet_loop_counter == 66:
        this_packet['AF3']['quality'] = current_contact_quality
        graph_quals['AF3'] = current_contact_quality
    elif packet_loop_counter == 3 or packet_loop_counter == 67:
        this_packet['F7']['quality'] = current_contact_quality
        graph_quals['F7'] = current_contact_quality
    elif packet_loop_counter == 4 or packet_loop_counter == 68:
        this_packet['T7']['quality'] = current_contact_quality
        graph_quals['T7'] = current_contact_quality
    elif packet_loop_counter == 5 or packet_loop_counter == 69:
        this_packet['P7']['quality'] = current_contact_quality
        graph_quals['P7'] = current_contact_quality
    elif packet_loop_counter == 6 or packet_loop_counter == 70:
        this_packet['O1']['quality'] = current_contact_quality
        graph_quals['O1'] = current_contact_quality
    elif packet_loop_counter == 7 or packet_loop_counter == 71:
        this_packet['O2']['quality'] = current_contact_quality
        graph_quals['O2'] = current_contact_quality
    elif packet_loop_counter == 8 or packet_loop_counter == 72:
        this_packet['P8']['quality'] = current_contact_quality
        graph_quals['P8'] = current_contact_quality
    elif packet_loop_counter == 9 or packet_loop_counter == 73:
        this_packet['T8']['quality'] = current_contact_quality
        graph_quals['T8'] = current_contact_quality
    elif packet_loop_counter == 10 or packet_loop_counter == 74:
        this_packet['F8']['quality'] = current_contact_quality
        graph_quals['F8'] = current_contact_quality
    elif packet_loop_counter == 11 or packet_loop_counter == 75:
        this_packet['AF4']['quality'] = current_contact_quality
        graph_quals['AF4'] = current_contact_quality
    elif packet_loop_counter == 12 or packet_loop_counter == 76 or packet_loop_counter == 80:
        this_packet['FC6']['quality'] = current_contact_quality
        graph_quals['FC6'] = current_contact_quality
    elif packet_loop_counter == 13 or packet_loop_counter == 77:
        this_packet['F4']['quality'] = current_contact_quality
        graph_quals['F4'] = current_contact_quality
    elif packet_loop_counter == 14 or packet_loop_counter == 78:
        this_packet['F8']['quality'] = current_contact_quality
        graph_quals['F8'] = current_contact_quality
    elif packet_loop_counter == 15 or packet_loop_counter == 79:
        this_packet['AF4']['quality'] = current_contact_quality
        graph_quals['AF4'] = current_contact_quality
    else:
        this_packet['Unknown']['quality'] = current_contact_quality
        this_packet['Unknown']['value'] = packet_loop_counter
    
    return this_packet

##########################
def shutdown_everything():
    #fill in more later?
    global g_running
    global g_device
    global g_system_platform
    global g_os_decryption
    
    #print "Shutting down..."
    g_running = False
    
    if g_system_platform == "Windows" or g_os_decryption:
        g_device.close()
    else:
        hidapi.hid_close(g_device)
    
    if g_outfile != 0:
        try:
            g_outfile.close()
        except:
            pass
    #more here? pygame screen?


############################################
# MAIN

outfile_name = raw_input('Enter name of output file (should end in .csv): ')
if os.path.isfile( outfile_name ):
    print "File already exists! I won't overwrite files. Please delete it yourself if you really want to replace that file. Bailing out now..."
    sys.exit()

try:
    g_outfile = open(outfile_name,'wt')
except:
    print "Could not open file for output! Bailing out now..."
    sys.exit()

init_everything()

#outfile_name = 'data_test.csv' #debug
#outfile = fopen(outfile_name,'wt') #debug

print >> g_outfile, '{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29},{30},{31},{32},{33},{34},{35},{36},{37},{38}'.format( \
    'PcktsTot', 'PcktsLoop', 'TimeAbs', 'TimeRel', #0-3
    'AF3_val', 'AF3_qual', 'AF4_val', 'AF4_qual', #4-7
    'F3_val', 'F3_qual', 'F4_val', 'F4_qual', #8-11
    'F7_val', 'F7_qual', 'F8_val', 'F8_qual', #12-15
    'FC5_val', 'FC5_qual', 'FC6_val', 'FC6_qual', #16-19
    'T7_val', 'T7_qual', 'T8_val', 'T8_qual', #20-23
    'P7_val', 'P7_qual', 'P8_val', 'P8_qual', #24-27
    'O1_val', 'O1_qual', 'O2_val', 'O2_qual', #28-31
    'X', 'Y', 'Battery', #32-34
    'KeyDown', 'KeyTime', 'Unknown_ctr', 'Unknown_qual' #35-38
    )

#graphing stuff -- move elsewhere if it works
graph_labels = ['AF3','AF4','F3','F4','F7','F8','FC5','FC6','T7','T8','P7','P8','O1','O2', 'X', 'Y']
# graph_ylower = [ -200, -200,-200,-200,-200,-200, -200, -200,-200,-200,-200,-200,-200,-200,-100,-100 ]
# graph_yupper = [  200,  200, 200, 200, 200, 200,  200,  200, 200, 200, 200, 200, 200, 200, 100, 100 ]
graph_ymidval= [    0,    0,   0,   0,   0,   0,    0,    0,   0,   0,   0,   0,   0,   0,   0,   0]
graph_yrange = [  200,  200, 200, 200, 200, 200,  200,  200, 200, 200, 200, 200, 200, 200, 100, 100]
graph_x_left_marg  = 50.0
graph_x_right_marg = 750.0
graph_y_top_marg   =  40.0
graph_y_bot_marg   = 570.0
graph_secs = 3
graph_buffers = {}
graph_quals = {}
for i in graph_labels:
    graph_buffers[i] = []
    for j in xrange(graph_secs*128):
        graph_buffers[i].append(0.0)
    graph_quals[i] = 0.0
graph_x_coords = []
for i in xrange(graph_secs*128):
    this_graph_x = graph_x_left_marg + (graph_x_right_marg-graph_x_left_marg)/(graph_secs*128.0)*i
    graph_x_coords.append( round(this_graph_x) )
graph_y_coords = []
for i in xrange(len(graph_labels)):
    this_graph_y = graph_y_top_marg + (graph_y_bot_marg-graph_y_top_marg)/len(graph_labels)*i
    graph_y_coords.append( round(this_graph_y) )
graph_y_sep = (graph_y_bot_marg-graph_y_top_marg)/len(graph_labels)
graph_buffer_ctr = 0
graph_draw_ctr = 0
graph_font = pygame.font.Font(None, 18)
graph_bgcolor = (127, 127, 127)
graph_key_color = (255, 0, 0)
graph_key_rect = pygame.Rect(750, 550, 50, 50)

while g_running:
    try:
        pygame.event.pump()
        keys_down = pygame.key.get_pressed()
        if keys_down[pygame.K_q] or keys_down[pygame.K_ESCAPE]:
            shutdown_everything()
            continue
        
        if keys_down[g_keypress_to_monitor]:
            g_key_timestamp = time.time()
            g_key_down = True
            g_draw_keypress = True
        
        if g_system_platform != "Windows":
            process_incoming_raw_data()
        
        if g_os_decryption == False and len(g_raw_encryped_packets) > 0:
            process_crypto_queue()
        
        if len(g_raw_decrypted_packets) > 0:
            process_decrypted_packet_queue()
        
        if len(g_processed_packets) > 0:
            for p in g_processed_packets:
                print >> g_outfile, '{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29},{30},{31},{32},{33},{34},{35},{36},{37},{38}'.format( \
                    p['PcktsTot']['value'], p['PcktsLoop']['value'], p['TimeAbs']['value'], p['TimeRel']['value'], #0-3
                    p['AF3']['value'], p['AF3']['quality'], p['AF4']['value'], p['AF4']['quality'], #4-7
                    p['F3']['value'], p['F3']['quality'], p['F4']['value'], p['F4']['quality'], #8-11
                    p['F7']['value'], p['F7']['quality'], p['F8']['value'], p['F8']['quality'], #12-15
                    p['FC5']['value'], p['FC5']['quality'], p['FC6']['value'], p['FC6']['quality'], #16-19
                    p['T7']['value'], p['T7']['quality'], p['T8']['value'], p['T8']['quality'], #20-23
                    p['P7']['value'], p['P7']['quality'], p['P8']['value'], p['P8']['quality'], #24-27
                    p['O1']['value'], p['O1']['quality'], p['O2']['value'], p['O2']['quality'], #28-31
                    p['X']['value'], p['Y']['value'], p['Battery']['value'], #32-34
                    p['KeyDown']['value'], p['KeyDown']['quality'], p['Unknown']['value'], p['Unknown']['quality'] #35-38
                    )
                
                for i in graph_labels:
                    graph_buffers[i][graph_buffer_ctr] = 1.0 * p[i]['value']
                graph_buffer_ctr += 1
                if graph_buffer_ctr >= (graph_secs*128):
                    graph_buffer_ctr = 0
                    for i in xrange(len(graph_labels)):
                        this_graph_max = max( graph_buffers[ graph_labels[i] ] )
                        this_graph_min = min( graph_buffers[ graph_labels[i] ] )
                        graph_ymidval[i] = (this_graph_max + this_graph_min)/2
                        graph_yrange[i]  = (this_graph_max - this_graph_min)
                        if graph_yrange[i] == 0:
                            graph_yrange[i] = 2
                
            g_processed_packets = []
            
            if graph_draw_ctr == 0:
                g_screen.fill(graph_bgcolor)
            
            if graph_draw_ctr < len(graph_labels):
                this_graph_label = graph_labels[graph_draw_ctr]
                this_graph_buffer = graph_buffers[this_graph_label]
                graph_y_start = round(graph_y_coords[graph_draw_ctr] - ((this_graph_buffer[0] - graph_ymidval[graph_draw_ctr]) / graph_yrange[graph_draw_ctr]) * graph_y_sep)
                for j in xrange(1, graph_secs*128):
                    graph_y_end = round(graph_y_coords[graph_draw_ctr] - ((this_graph_buffer[j] - graph_ymidval[graph_draw_ctr]) / graph_yrange[graph_draw_ctr]) * graph_y_sep)
                    pygame.draw.line(g_screen, (0,0,0), (graph_x_coords[j-1], graph_y_start), (graph_x_coords[j], graph_y_end) )
                        #could see if one pygame.draw.lines() is faster than many pygame.draw.line() ? 
                    graph_y_start = graph_y_end
            
            graph_draw_ctr += 1
            if graph_draw_ctr == (len(graph_labels) + 1):
                for i in xrange(len(graph_labels)):
                    graph_text = graph_font.render( graph_labels[i], 1, (0, 0, 255), graph_bgcolor)
                    text_rect = graph_text.get_rect()
                    text_rect.centery = graph_y_coords[i]
                    text_rect.centerx = graph_x_left_marg / 2
                    g_screen.blit( graph_text, text_rect )
            elif graph_draw_ctr == (len(graph_labels) + 2):
                for i in xrange(len(graph_labels)):
                    graph_text = graph_font.render( '%.3f' % graph_quals[graph_labels[i]], 1, (160, 160, 160), graph_bgcolor)
                    text_rect = graph_text.get_rect()
                    text_rect.centery = graph_y_coords[i]
                    text_rect.centerx = graph_x_right_marg + (graph_x_left_marg / 2)
                    g_screen.blit( graph_text, text_rect )
            elif graph_draw_ctr == (len(graph_labels) + 3):
                graph_text = graph_font.render( 'Time: %07.3fs    Battery: %02d%%' % (time.time() - g_ts_start, g_battery), 1, (192, 192, 192), graph_bgcolor)
                text_rect = graph_text.get_rect()
                text_rect.centery = graph_y_bot_marg
                text_rect.centerx = (graph_x_left_marg + graph_x_right_marg) / 2
                g_screen.blit( graph_text, text_rect )
                if g_draw_keypress:
                    g_screen.fill( graph_key_color, graph_key_rect )
                    g_draw_keypress = False
                graph_draw_ctr = 0
                pygame.display.flip()
        else:
            time.sleep(g_inter_sample_sleep_time)
                
    except KeyboardInterrupt:
        shutdown_everything()


