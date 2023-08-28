import urllib.parse

def settings_filter(to_verify_settings, sonar_settings):
    to_update_settings = []
    for setting in sonar_settings:
        key=setting['key'] 
        if (key in to_verify_settings):
          if ('value' in setting):
            value=setting['value'] 
            if (setting['value'] != to_verify_settings[key]):
              to_update_settings.append({'key': key, 'value': to_verify_settings[key]})
              del to_verify_settings[key]
    return to_update_settings

def to_query_string(queries):
    queries_strings = []
    for query in queries:
        queries_strings.append('key='+
            urllib.parse.quote_plus(query['key'])+ 
            '&value='+
            urllib.parse.quote_plus(query['value'])
        )
    print(queries_strings)
    return queries_strings

def plugins_includes(sonar_plugins_list, key_to_search):
    for plugin in sonar_plugins_list:
        if (plugin['key'] == key_to_search):
          return 'yes'
    return 'no'

class FilterModule(object):
    def filters(self):
        return {
            'to_query_string': to_query_string,
            'plugins_includes': plugins_includes,
            'settings_filter': settings_filter,
        }