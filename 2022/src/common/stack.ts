export class Stack<T> {
  private items: T[];

  constructor() {
    this.items = [];
  }

  push(element: T): void {
    this.items.push(element);
  }

  pop(): T | undefined {
    return this.items.pop();
  }

  size(): number {
    return this.items.length;
  }

  print(): void {
    console.log(this.items);
  }
}
