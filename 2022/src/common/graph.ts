class PriorityQueue<T> {
  private items: Array<{ item: T; priority: number }> = [];

  enqueue(item: T, priority: number) {
    const newItem = { item, priority };
    if (
      this.isEmpty() ||
      priority >= this.items[this.items.length - 1].priority
    ) {
      this.items.push(newItem);
    } else {
      for (let i = 0; i < this.items.length; i++) {
        if (priority < this.items[i].priority) {
          this.items.splice(i, 0, newItem); // Insert instead of replace
          break;
        }
      }
    }
  }

  dequeue(): { item: T; priority: number } | undefined {
    return this.items.shift();
  }

  isEmpty(): boolean {
    return this.items.length === 0;
  }
}

export class Node<T> {
  data: T;
  neighbors: Map<Node<T>, number>;
  comparator: (a: T, b: T) => number;

  constructor(data: T, comparator: (a: T, b: T) => number) {
    this.data = data;
    this.neighbors = new Map<Node<T>, number>();
    this.comparator = comparator;
  }

  addNeighbor(node: Node<T>, weight: number = 1): void {
    this.neighbors.set(node, weight);
  }

  removeNeighbor(data: T): Node<T> | null {
    let neighborEntry = Array.from(this.neighbors.entries()).find(
      ([node]) => this.comparator(node.data, data) === 0,
    );
    if (neighborEntry) {
      this.neighbors.delete(neighborEntry[0]);
      return neighborEntry[0];
    }
    return null;
  }
}

export class Graph<T> {
  nodes: Node<T>[] = [];
  comparator: (a: T, b: T) => number;

  constructor(comparator: (a: T, b: T) => number) {
    this.comparator = comparator;
  }

  addNode(data: T): Node<T> {
    let node = this.nodes.find((n) => this.comparator(n.data, data) === 0);

    if (node != null) {
      return node;
    }

    node = new Node(data, this.comparator);
    this.nodes.push(node);
    return node;
  }

  addEdge(source: T, destination: T, weight: number = 1): void {
    let sourceNode: Node<T> = this.addNode(source);
    let destinationNode: Node<T> = this.addNode(destination);

    sourceNode.addNeighbor(destinationNode, weight);
  }

  shortestPath(start: T, destination: T): T[] {
    const distances: Map<T, number> = new Map();
    const previous: Map<T, T | null> = new Map();
    const pq = new PriorityQueue<T>();

    this.nodes.forEach((node) => {
      if (this.comparator(node.data, start) === 0) {
        distances.set(node.data, 0);
        pq.enqueue(node.data, 0);
      } else {
        distances.set(node.data, Infinity);
      }
      previous.set(node.data, null);
    });

    while (!pq.isEmpty()) {
      const { item: current } = pq.dequeue()!;
      const currentNode = this.nodes.find(
        (n) => this.comparator(n.data, current) === 0,
      );
      if (!currentNode) continue;

      if (this.comparator(current, destination) === 0) {
        const path: T[] = [];
        let step: T | null = current;
        while (step !== null) {
          path.push(step);
          step = previous.get(step)!;
        }
        return path.reverse();
      }

      currentNode.neighbors.forEach((weight, neighbor) => {
        const alt = distances.get(current)! + weight;
        if (alt < distances.get(neighbor.data)!) {
          distances.set(neighbor.data, alt);
          previous.set(neighbor.data, current);
          pq.enqueue(neighbor.data, alt);
        }
      });
    }

    throw new Error("No path found");
  }
}
