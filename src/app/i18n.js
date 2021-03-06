var i18n = {
    dict: {
        loading: 'Loading...',
        preload: 'Preloading images',
        empty: 'empty',
        menu_back: 'Return to game',
        menu_save: 'Save',
        menu_load: 'Load',
        menu_reset: 'Reset',
        menu_mute: 'Mute',
        menu_unmute: 'Unmute',
        menu_savegame: 'Save game',
        menu_loadgame: 'Load game',
        menu_import: 'Import',
        menu_export: 'Export saved game',
        menu_autosave: 'Autosave',
        menu_cancel: 'Cancel'
    },
    load: function init(d) {
        this.dict = d;
    },
    t: function translate(phrase) {
        if (phrase in this.dict) {
            return this.dict[phrase];
        }
        return phrase;
    }
};

module.exports = i18n;
