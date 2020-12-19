

class MenuItem(object):
    def __init__(self, items=None):
        # self.id = id
      
        self.items = items

    def serialize(self):
        return self.__dict__