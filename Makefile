#
# Makefile for the PearlHD skin for text2skin
#
# The i18n Part of this Makefile is inspired by the makefile-demo for text2skin by Thomas Günther <tom@toms-cafe.de>
#
# 
# $Id$

SKIN = PearlHD
MAIL = $(shell sed -ne "s/.*Report-Msgid-Bugs-To: *<\(..*\)>.*/\1/p" po/*.po | head -n1)

### The directory environment:

-include Make.config

DESTDIR ?=
PREFIX  ?= /usr
CONFDIR  = $(if $(subst /usr,,$(PREFIX)), $(PREFIX))/etc/vdr
SKINDIR  = $(CONFDIR)/plugins/text2skin/$(SKIN)
YAEPGHDDIR  = $(CONFDIR)/plugins/yaepghd
THEMESDIR  = $(CONFDIR)/themes
LOCDIR   = $(PREFIX)/share/locale

### The main target:

all: PearlHD.skin i18n 

### Internationalization (I18N):
PODIR     = po
LOCALEDIR = locale

I18Npo    = $(notdir $(wildcard $(PODIR)/*.po))
I18Npot   = $(PODIR)/$(SKIN).pot

$(I18Npot): $(SKIN).skin
	@cat $^ | sed -e "s/('/(\"/g;s/')/\")/g" | grep -o "trans([^)]*)" | \
	xgettext -C --no-wrap --no-location -k -ktrans \
	         --msgid-bugs-address='<$(MAIL)>' -o $@ -

%.po: $(I18Npot)
	msgmerge -U --no-wrap --no-location --backup=none -q $@ $<
	@touch $@

$(LOCALEDIR)/%/LC_MESSAGES/vdr-text2skin-$(SKIN).mo: $(PODIR)/%.po
	@mkdir -p $(dir $@)
	msgfmt -c -o $@ $<

i18n: $(I18Npo:%.po=$(LOCALEDIR)/%/LC_MESSAGES/vdr-text2skin-$(SKIN).mo)

### Targets:

PearlHD.skin: 
	@cp $(SKIN).template $(SKIN).skin
	@if [ "$(CHANNELLOGOJPG)" = "1" ]; then sed 's/{ChannelName}.png/{ChannelName}.jpg/g' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(EPGIMAGESJPG)" = "1" ]; then sed 's/{PresentEventID}.png/{PresentEventID}.jpg/g' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	
	@if [ "$(CRYPTSYMBOLS)" = "" ]; then sed -e '/CRYPTSYMBOLS/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(RECTITLEINFOHEAD)" = "" ]; then sed -e '/RECTITLEINFOHEAD/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(RECTITLEINFOBOTTOM)" = "" ]; then sed -e '/RECTITLEINFOBOTTOM/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(RECTITLEINFOTOP)" = "" ]; then sed -e '/RECTITLEINFOTOP/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(EPGIMAGES)" = "" ]; then sed -e '/ EPGIMAGES/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(EPGIMAGES)" = "1" ]; then sed -e '/NOEPGIMAGES/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin;cat $(SKIN).skin | sed 's/EPGIMAGESPATH/$(EPGIMAGESPATH)/g' > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(CHANNELLOGO)" = "" ]; then sed -e '/ CHANNELLOGO/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(CHANNELLOGO)" = "1" ]; then sed -e '/NOCHANNELLOGO/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(CHANNELLOGORIGHT)" = "" ]; then sed -e '/ RCHANNELLOGO/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(CHANNELLOGORIGHT)" = "1" ]; then sed -e '/NORCHANNELLOGO/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(TIMERSWATCH)" = "" ]; then sed -e '/TIMERSWATCH/d' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ "$(MENUITEHEIGHT)" != "" ]; then sed 's/item height="50"/item height="$(MENUITEHEIGHT)"/g' <$(SKIN).skin > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	
	@cat $(SKIN).skin | sed 's/BUTTON_1/$(BUTTON_1)/g' | sed 's/BUTTON_2/$(BUTTON_2)/g' | sed 's/BUTTON_3/$(BUTTON_3)/g' | sed 's/BUTTON_4/$(BUTTON_4)/g' > $(SKIN).tmp
	@cp $(SKIN).tmp $(SKIN).skin
	
	@cp $(SKIN).tmp $(SKIN).skin
	@if [ "$(DYNAMICFONTS)" = "1" ]; then\
	 cat $(SKIN).skin | sed 's/VDRSymbols Sans:Book@27/Sml/g' > $(SKIN).tmp;\
	 cat $(SKIN).tmp | sed 's/VDRSymbols Sans:Book@37/Osd/g' > $(SKIN).skin;\
	fi 
	@if [ $(OSDWIDTH) != "1920"  ]; then perl res/convert.pl $(SKIN).skin $(OSDWIDTH)  > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ $(OSDWIDTH) = "1920"  ]; then cat $(SKIN).skin | sed 's/y1="-134" y2="-100" bpp="8"/y1="-135" y2="-100" bpp="8"/' > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@if [ $(OSDWIDTH) = "1280"  ]; then cat $(SKIN).skin | sed 's/y1="-88" y2="-66" bpp="8"/y1="-89" y2="-66" bpp="8"/' > $(SKIN).tmp;cp $(SKIN).tmp $(SKIN).skin; fi 
	@rm $(SKIN).tmp

	
install-i18n: i18n
	@mkdir -p $(DESTDIR)$(LOCDIR)
	@cp -r $(LOCALEDIR)/* $(DESTDIR)$(LOCDIR)
	
install: install-i18n 
	@mkdir -p $(DESTDIR)$(SKINDIR)
	@cp  $(SKIN).skin $(DESTDIR)$(SKINDIR)
	@cp  $(SKIN).colors $(DESTDIR)$(SKINDIR)
	@cp  COPYING $(DESTDIR)$(SKINDIR)
	@cp themes/*.theme $(DESTDIR)$(THEMESDIR)
	@if [ "$(YAEPGHD)" = "1" ]; then cp yaepghd/* $(DESTDIR)$(YAEPGHDDIR) -r; fi 

clean:
	@-rm -rf $(LOCALEDIR) $(I18Npot) $(SKIN).skin *~

uninstall:
	@-rm  $(DESTDIR)$(SKINDIR)/COPYING
	@-rm  $(DESTDIR)$(SKINDIR)/$(SKIN).skin
	@-rm  $(DESTDIR)$(SKINDIR)/$(SKIN).colors
	@-rmdir  $(DESTDIR)$(SKINDIR) 
