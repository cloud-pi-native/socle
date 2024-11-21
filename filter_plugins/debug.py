def get_debug_messages(dsc):
    messages = []
    if dsc['proxy']['enabled']:
        messages.append("--- Proxy ---")
        messages.append("Nexus Proxy parameters cannot be set via API, please configure it with local admin account")
        messages.append("(Parameter Icon) => HTTP => Proxy Settings")
    return messages

class FilterModule(object):
    def filters(self):
        return {
            'get_debug_messages': get_debug_messages,
        }