import wx

import wx.propgrid as wxpg
from bagconfig import BAGConfig

_ = wx.GetTranslation


# Simpel paneel om NLExtract BAG config settings te bewerken
class ConfigEditorPanel(wx.Dialog):
    def __init__(self, parent):
        wx.Dialog.__init__(self, parent, -1, 'NLExtract BAG config aanpassen', size=(400, 200))

        self.panel = panel = wx.Panel(self, wx.ID_ANY)

        # Difference between using PropertyGridManager vs PropertyGrid is that
        # the manager supports multiple pages and a description box.
        self.pg = pg = wxpg.PropertyGridManager(panel,
                                                style=wxpg.PG_SPLITTER_AUTO_CENTER | wxpg.PG_AUTO_SORT)
        pg.AddPage("BAG Extract Config")

        pg.Append(wxpg.PropertyCategory("BAG Extract Config"))
        pg.Append(wxpg.StringProperty("Database naam", value="%s" % BAGConfig.config.database))
        pg.Append(wxpg.StringProperty("Database schema", value="%s" % BAGConfig.config.schema))
        pg.Append(wxpg.StringProperty("Database host", value="%s" % BAGConfig.config.host))
        pg.Append(wxpg.StringProperty("Database user", value="%s" % BAGConfig.config.user))
        pg.Append(wxpg.StringProperty("Database password", value="%s" % BAGConfig.config.password))
        pg.Append(wxpg.IntProperty("Database poort", value=int(BAGConfig.config.port)))
        # pg.Append(wxpg.BoolProperty("Verbose logging", value=True))
        # pg.SetPropertyAttribute("Bool_with_Checkbox", "UseCheckbox", True)

        topsizer = wx.BoxSizer(wx.VERTICAL)
        topsizer.Add(pg, 1, wx.EXPAND)
        but = wx.Button(panel, -1, "Bewaren")
        but.Bind(wx.EVT_BUTTON, self.OnSave)
        topsizer.Add(but, 1, wx.EXPAND)

        # rowsizer = wx.BoxSizer(wx.HORIZONTAL)
        # rowsizer.Add(but, 1)

        panel.SetSizer(topsizer)
        topsizer.SetSizeHints(panel)

        sizer = wx.BoxSizer(wx.VERTICAL)
        sizer.Add(panel, 1, wx.EXPAND)
        self.SetSizer(sizer)
        self.SetAutoLayout(True)

    def OnSave(self, event):
        props = self.pg.GetPropertyValues(inc_attributes=True)
        BAGConfig.config.database = props['Database naam']
        BAGConfig.config.schema = props['Database schema']
        BAGConfig.config.host = props['Database host']
        BAGConfig.config.user = props['Database user']
        BAGConfig.config.port = props['Database poort']
        BAGConfig.config.save()
        print(str(props))
