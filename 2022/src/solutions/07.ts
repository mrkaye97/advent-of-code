import { readDayInput } from "../common/io";
import { Tree, TreeNode } from "../common/tree";

const data = readDayInput(7).split("\n");

enum NodeType {
  Directory,
  File,
}

const tree = new Tree<string>("root", null, NodeType.Directory);

var currentNode = tree.root;

if (!currentNode) {
  throw new Error("Root node is null");
}

for (let i = 1; i < data.length; i++) {
  const line = data[i];
  if (line.startsWith("$ cd")) {
    const changeTo = line.split(" ")[2];

    if (changeTo !== "..") {
      const node = new TreeNode(changeTo, null, NodeType.Directory);
      currentNode.addChild(node);
      const previous = currentNode;
      currentNode = node;
      currentNode.parent = previous;
    } else {
      if (currentNode.parent) {
        currentNode = currentNode.parent;
      } else {
        throw new Error("Cannot go back from root node");
      }
    }
  }

  if (!line.startsWith("$") && !line.startsWith("dir")) {
    const [fileSize, fileName] = line.split(" ");
    const node = new TreeNode(fileName, parseInt(fileSize), NodeType.File);
    currentNode.addChild(node);
  }
}

console.log(
  "Part I: ",
  tree
    .filter(tree.root, (node) => node.nodeType === NodeType.Directory)
    .filter((node) => tree.computeSum(node) < 100_000)
    .map((node) => tree.computeSum(node))
    .reduce((acc, curr) => acc + curr, 0),
);

const TOTAL_DISK_SPACE = 70_000_000;
const FREE_DISK_SPACE_NEEDED = 30_000_000;

const currentFreeSpace = TOTAL_DISK_SPACE - tree.computeSum(tree.root);
const additionalSpaceNeeded = FREE_DISK_SPACE_NEEDED - currentFreeSpace;

console.log(
  "Part II: ",
  Math.min(
    ...tree
      .filter(tree.root, (node) => node.nodeType === NodeType.Directory)
      .map((node) => tree.computeSum(node))
      .filter((size) => size >= additionalSpaceNeeded),
  ),
);
