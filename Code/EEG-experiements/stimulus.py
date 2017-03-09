#  stimulus for EEG recording
import pygame
# pygame is a library for game applications 
import sys
import time
from pygame.locals import *

pygame.init()

# setup the visualization parameters
WIDTH = 1920
HEIGHT = 1080
win = pygame.display.set_mode((WIDTH, HEIGHT), 0, 32)
Black = (0, 0, 0)
White= (255,255,255)
RED = (255, 0, 0)
clock = pygame.time.Clock()

# preparation time
win.fill(Black)
time.sleep(3)

# experiment time
mins = 5
to_sec = 60

def main():

    t_end = time.time() + mins*to_sec
    while time.time() < t_end:
        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                sys.exit()
        # epochs
        pygame.draw.rect(win, RED, (0, 0, WIDTH/2, HEIGHT))
        pygame.display.update()
        time.sleep(6)
        win.fill(White)
        pygame.display.update()
        time.sleep(3)
        win.fill(Black)
        pygame.display.update()
        time.sleep(3)
        pygame.draw.rect(win, RED, (WIDTH/2,0, WIDTH/2 , HEIGHT))
        pygame.display.update()
        time.sleep(6)
        win.fill(White)
        pygame.display.update()
        time.sleep(3)
        win.fill(Black)
        pygame.display.update()
        time.sleep(3)
        pygame.draw.rect(win, RED, (0,-WIDTH/2, WIDTH , HEIGHT))
        pygame.display.update()
        time.sleep(6)
        win.fill(White)
        pygame.display.update()
        time.sleep(3)

        win.fill(Black)
        pygame.display.update()
        time.sleep(3)


        clock.tick(60)

main()
