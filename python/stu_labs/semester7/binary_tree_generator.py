from dataclasses import dataclass
from typing import Union


@dataclass
class BinaryTree:
    value: Union[int, str]
    left: 'BinaryTree' = None
    right: 'BinaryTree' = None

    def __iter__(self):
        return self.pre_order

    def __str__(self):
        return str(self.value)

    @property
    def pre_order(self):
        yield self
        if self.left:
            yield from self.left
        if self.right:
            yield from self.right


def main():
    bt = BinaryTree(1, BinaryTree(2), BinaryTree(3, BinaryTree(4), BinaryTree(5)))
    print([str(elem) for elem in bt])


if __name__ == "__main__":
    main()

