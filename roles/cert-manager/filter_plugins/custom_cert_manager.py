def custom_cert_manager(manifests, environments):
    for i in range(len(manifests)):
        if manifests[i]['kind'] == 'Deployment':
            del manifests[i]['spec']['template']['spec']['securityContext']['seccompProfile']
            for env in environments:
                manifests[i]['spec']['template']['spec']['containers'][0]['env'].append({ 'name': env['name'], 'value': env['value']})
    return manifests

class FilterModule(object):  
    def filters(self):    
        return {
            'custom_cert_manager': custom_cert_manager,
        }