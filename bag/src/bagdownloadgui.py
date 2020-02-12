import requests
import os
import wx
import wx.lib.scrolledpanel as scrolled
from bagconfig import BAGConfig

from threading import Thread
from wx.lib.pubsub import pub
from etree import etree, stripNS

# From: http://www.blog.pythonlibrary.org/2014/01/29/wxpython-creating-a-file-downloading-app/
# Adapted by Just van den Broecke: progress with MBs, cancellation etc.


########################################################################
class DownloadThread(Thread):
    """Downloading thread"""

    # ----------------------------------------------------------------------
    def __init__(self, url, fsize, local_path):
        """Constructor"""
        Thread.__init__(self)
        self.fsize = fsize
        self.url = url
        self.local_path = local_path
        self.cancelTransfer = False
        self.start()

    # ----------------------------------------------------------------------
    def run(self):
        """
        Run the worker thread
        """

        local_fname = os.path.join(self.local_path, os.path.basename(self.url))
        count = 1
        while True:
            if os.path.exists(local_fname):
                tmp, ext = os.path.splitext(local_fname)
                cnt = "(%s)" % count
                local_fname = tmp + cnt + ext
                count += 1
            else:
                break

        pub.subscribe(self.onCancelTransfer, "cancel.transfer")

        # Get the BAG .zip file
        req = requests.get(self.url, stream=True)

        total_size = 0
        with open(local_fname, "wb") as fh:
            for byte in req.iter_content(chunk_size=1024):
                if self.cancelTransfer is True:
                    return

                if byte:
                    fh.write(byte)
                    fh.flush()

                total_size += len(byte)
                if total_size < self.fsize:
                    wx.CallAfter(pub.sendMessage, "update.transfer", msg=total_size)

        wx.CallAfter(pub.sendMessage, "done.transfer", msg=total_size)

    # ----------------------------------------------------------------------
    def onCancelTransfer(self):
        """"""
        self.cancelTransfer = True


########################################################################
class MyGauge(wx.Gauge):
    """"""

    # ----------------------------------------------------------------------
    def __init__(self, parent, range):
        """Constructor"""
        wx.Gauge.__init__(self, parent, range=range, size=wx.Size(300, 24))

        pub.subscribe(self.onUpdateProgress, "update.transfer")

    # ----------------------------------------------------------------------
    def onUpdateProgress(self, msg):
        """"""
        self.SetValue(msg)


########################################################################
class BAGDownloadPanel(scrolled.ScrolledPanel):
    """"""

    # ----------------------------------------------------------------------
    def __init__(self, parent):
        """Constructor"""
        scrolled.ScrolledPanel.__init__(self, parent)

        self.parent = parent
        self.atom_url = 'http://geodata.nationaalgeoregister.nl/inspireadressen/atom/inspireadressen.xml'
        self.extract_datum = 'ophalen...'
        self.extract_fsize = 'ophalen...'
        self.extract_url = 'ophalen...'
        self.progress_chars = ['.   ', ' .  ', '  . ', '   .']
        self.progress_count = 0

        # create the sizers
        self.main_sizer = wx.BoxSizer(wx.VERTICAL)
        meta_sizer = wx.BoxSizer(wx.HORIZONTAL)
        dl_sizer = wx.BoxSizer(wx.HORIZONTAL)

        self.downloadMeta()

        meta_txt = wx.StaticText(self, label="BAG datum=%s   grootte=%d MB (plm 1.5GB)" % (self.extract_datum, self.extract_fsize / (1024 * 1024)))

        # create the widgets
        lbl = wx.StaticText(self, label="Download URL: %s" % self.extract_url)
        btn = wx.Button(self, label="Download")
        btn.Bind(wx.EVT_BUTTON, self.onDownload)

        # layout the widgets
        meta_sizer.Add(meta_txt, 0, wx.ALL | wx.CENTER, 5)
        dl_sizer.Add(lbl, 0, wx.ALL | wx.CENTER, 5)
        dl_sizer.Add(btn, 0, wx.ALL, 5)

        self.main_sizer.Add(meta_sizer, 0, wx.EXPAND)
        self.main_sizer.Add(dl_sizer, 0, wx.EXPAND)

        self.SetSizer(self.main_sizer)
        self.SetAutoLayout(1)
        self.SetupScrolling()

    def downloadMeta(self):
        """
        Download BAG source file metadata from PDOK Atom feed URL.
        """

        # Fetch and parse XML Atom file
        rsp = requests.get(self.atom_url)
        xml_str = rsp.content
        node = etree.fromstring(xml_str)
        node = stripNS(node)

        # Extract metadata
        self.extract_datum = node.xpath("//feed/entry/updated/text()")[0].split('T')[0]
        self.extract_fsize = long(node.xpath("//feed/entry/link/@length")[0])
        self.extract_url = node.xpath("//feed/entry/link/@href")[0]

    # ----------------------------------------------------------------------
    def onDownload(self, event):
        """
        Update display with downloading gauges
        """
        dialoog = wx.DirDialog(self,
                               "Selecteer directory om BAG te downloaden",
                               BAGConfig.config.bagextract_home,
                               wx.OPEN | wx.DD_DIR_MUST_EXIST)

        if dialoog.ShowModal() == wx.ID_OK:
            local_path = dialoog.GetPath()
        else:
            return

        # disable 'Download' button
        button = event.EventObject
        button.Disable()

        url = self.extract_url
        try:
            # Content-length is never sent by PDOK!
            # header = requests.head(url)
            # fsize = int(header.headers["content-length"]) / 1024
            fsize = self.extract_fsize
            sizer = wx.BoxSizer(wx.HORIZONTAL)
            fname = os.path.basename(url)

            lbl = wx.StaticText(self, label="Downloading %s" % fname)
            gauge = MyGauge(self, fsize)
            self.dl_progress = wx.StaticText(self, label="Starting...")
            btn = wx.Button(self, label="Cancel")
            btn.Bind(wx.EVT_BUTTON, self.onCancelDownload)

            sizer.Add(lbl, 0, wx.ALL | wx.CENTER, 5)
            sizer.Add(gauge, 0, wx.ALL | wx.EXPAND, 5)
            sizer.Add(self.dl_progress, 0, wx.ALL | wx.CENTER, 5)
            self.main_sizer.Add(sizer, 0, wx.EXPAND)
            self.main_sizer.Add(btn, 1, wx.ALL | wx.CENTER, 5)

            self.Layout()
            pub.subscribe(self.onDownloadUpdate, "update.transfer")
            pub.subscribe(self.onDownloadDone, "done.transfer")

            # start thread
            DownloadThread(url, fsize, local_path)
        except Exception as e:
            print("Error: ", e)

    # ----------------------------------------------------------------------
    def onDownloadUpdate(self, msg):
        sz = long(msg)
        progress_char = self.progress_chars[self.progress_count % 4]
        self.dl_progress.SetLabel('%d MB %s' % (sz / (1024 * 1024), progress_char))
        self.progress_count += 1

    # ----------------------------------------------------------------------
    def onDownloadDone(self, msg):
        sz = long(msg)
        self.dl_progress.SetLabel('%d MB KLAAR!' % (sz / (1024 * 1024)))

    # ----------------------------------------------------------------------
    def onCancelDownload(self, event):
        """
        Cancel download in progress.
        """
        wx.CallAfter(pub.sendMessage, "cancel.transfer")
        self.parent.Close()


class BAGDownloaderFrame(wx.Frame):
    """"""

    # ----------------------------------------------------------------------
    def __init__(self):
        """Constructor"""
        wx.Frame.__init__(self, None, title="BAG Bron Bestand Downloader", size=(800, 400))
        self.dl_panel = BAGDownloadPanel(self)
        self.Bind(wx.EVT_CLOSE, self.onCloseWindow)
        self.Show()

    def onCloseWindow(self, event):
        wx.CallAfter(pub.sendMessage, "cancel.transfer")
        self.Destroy()
