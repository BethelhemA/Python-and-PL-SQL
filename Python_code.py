class MinitermGenerator:
    def __init__(self, predicates):
        self.predicates = predicates

    def generate_miniterms(self):
        miniterms = []
        for predicate in self.predicates:
            miniterms.extend(self.generate_miniterms_from_predicate(predicate))
        return miniterms

    def generate_miniterms_from_predicate(self, predicate):
        miniterms = []
        predicate_name, args = predicate[0], predicate[1:]
        miniterms.append([predicate_name])
        for i in range(len(args)):
            new_miniterms = []
            for miniterm in miniterms:
                for arg in args[i]:
                    new_miniterms.append(miniterm + [arg])
            miniterms = new_miniterms
        return miniterms


predicates = [
    ['Pr', ['a', 'b', 'c']],
    ['Pr', ['x', 'y']]
]

miniterm_generator = MinitermGenerator(predicates)
miniterms = miniterm_generator.generate_miniterms()
print("Horizontal Miniterm Fragments:")
for miniterm in miniterms:
    print(miniterm)
