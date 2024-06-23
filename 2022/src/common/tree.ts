export class TreeNode<T> {
  key: T;
  nodeType: any;
  value: number | null = null;
  children: TreeNode<T>[] = [];
  parent: TreeNode<T> | null = null;

  constructor(key: T, value: number | null = null, nodeType: any) {
    this.key = key;
    this.nodeType = nodeType;
    this.value = value;
  }

  addChild(child: TreeNode<T>): void {
    child.parent = this;
    this.children.push(child);
  }
}

export class Tree<T> {
  root: TreeNode<T> | null = null;

  constructor(key: T, value: number | null = null, nodeType: any) {
    this.root = new TreeNode(key, value, nodeType);
  }

  preOrderTraversal(
    node: TreeNode<T> | null = this.root,
    callback: (node: TreeNode<T>) => void,
  ): void {
    if (node) {
      callback(node);
      for (const child of node.children) {
        this.preOrderTraversal(child, callback);
      }
    }
  }

  computeSum(node: TreeNode<T> | null = this.root): number {
    let sum = 0;
    if (node) {
      sum += node.value || 0;
      for (const child of node.children) {
        sum += this.computeSum(child);
      }
    }
    return sum;
  }

  filter(
    node: TreeNode<T> | null = this.root,
    predicate: (node: TreeNode<T>) => boolean,
  ): TreeNode<T>[] {
    let result: TreeNode<T>[] = [];
    if (node) {
      if (predicate(node)) {
        result.push(node);
      }
      for (const child of node.children) {
        result = result.concat(this.filter(child, predicate));
      }
    }
    return result;
  }
}
