#------------------------------------------------------------------------------
# Naam:         libLog.py
# Omschrijving: Generieke functies voor logging binnen BAG Extract+
# Auteur:       Matthijs van der Deijl
# Auteur:       Just van den Broecke - porting naar NLExtract (2015)
#
# Versie:       1.3
#               - foutafhandeling verbeterd
# Datum:        16 december 2009
#
# Versie:       1.2
# Datum:        24 november 2009
#
# Ministerie van Volkshuisvesting, Ruimtelijke Ordening en Milieubeheer
#------------------------------------------------------------------------------

import wx

# Simple logscherm: tekst in tekstpanel
class LogScherm:
    def __init__(self, text_ctrl):
        self.text_ctrl = text_ctrl

    def __call__(self, tekst):
        self.schrijf(tekst)

    def start(self):
        i = self.text_ctrl.GetNumberOfLines()
        self.text_ctrl.Clear()
        while i > 0:
            self.text_ctrl.AppendText(" \n")
            i -= 1
        self.text_ctrl.Clear()

    def schrijf(self, tekst):
        self.text_ctrl.AppendText("\n" + tekst)
        self.text_ctrl.Refresh()
        self.text_ctrl.Update()

# See http://www.blog.pythonlibrary.org/2010/05/22/wxpython-and-threads/
# (use events when in multithreaded mode)

# Define notification event for thread completion
EVT_SCHRIJF_ID = wx.NewId()

def EVT_SCHRIJF(win, func):
    """Define Result Event."""
    win.Connect(-1, -1, EVT_SCHRIJF_ID, func)

class SchrijfEvent(wx.PyEvent):
    """Simple event to carry arbitrary result data."""
    def __init__(self, tekst):
        """Init Result Event."""
        wx.PyEvent.__init__(self)
        self.SetEventType(EVT_SCHRIJF_ID)
        self.tekst = tekst

class AsyncLogScherm(LogScherm):
    def __init__(self, text_ctrl):
        LogScherm.__init__(self, text_ctrl)

        # Set up event handler for any worker thread results
        EVT_SCHRIJF(self.text_ctrl, self.on_schrijf_event)

    def on_schrijf_event(self, evt):
        self.schrijf(evt.tekst)
        
    def __call__(self, tekst):
        # Ipv direct schrijven stuur "schrijf" event
        wx.PostEvent(self.text_ctrl, SchrijfEvent(tekst))
