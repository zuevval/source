from collections import defaultdict, OrderedDict
from typing import List, Tuple, DefaultDict


def read_data(nextline: callable):
    def read_tuples_list(n_lines: int) -> List[Tuple[int, int]]:
        res = []
        for _ in range(n_lines):
            res.append(tuple(map(int, nextline().strip().split())))
        return res

    n_fans = int(nextline().strip())
    n_pairs = int(nextline().strip())
    fan_pairs = read_tuples_list(n_pairs)
    n_car_types = int(nextline().strip())
    car_types = read_tuples_list(n_car_types)
    return n_fans, fan_pairs, car_types


def adjacent_components(nodes: int, pairs: List[Tuple[int, int]]) -> DefaultDict[int, int]:
    components = [[i] for i in range(nodes)]  # initially every node forms a component
    for pair in pairs:
        first_component = second_component = None
        for component in components:
            if pair[0] in component:
                first_component = component
            if pair[1] in component:
                second_component = component
        assert first_component is not None and second_component is not None
        if first_component != second_component:  # merge components
            components.remove(second_component)
            first_component.extend(second_component)

    components_count = defaultdict(int)
    for c in components:
        components_count[len(c)] += 1
    return components_count


def can_accomodate(cars: List[Tuple[int, int]], groups: DefaultDict[int, int]):
    groups = OrderedDict({k: groups[k] for k in sorted(groups)})  # sort groups
    for car_type in cars:
        capacity, quantity = car_type[0], car_type[1]
        while quantity and groups:
            n_fans, n_groups = groups.popitem()  # number of fans in a group and number of such groups
            if n_fans > capacity:
                return False
            if quantity >= n_groups:  # if able to place all groups of this type in cars of only this type
                quantity -= n_groups
            else:
                n_groups -= quantity
                quantity = 0
                groups[n_fans] = n_groups
                groups.move_to_end(n_fans)  # restore sort order
    return not groups  # if some people left, we've failed


def process_file(filename: str):
    with open(filename) as fin:
        n_fans, fan_pairs, car_types = read_data(fin.readline)
        fan_groups = adjacent_components(n_fans, fan_pairs)
        print(can_accomodate(car_types, fan_groups))


if __name__ == "__main__":
    process_file("test1.txt")
    process_file("example1.txt")
    process_file("example2.txt")
    process_file("example3.txt")
