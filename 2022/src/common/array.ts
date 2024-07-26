export function unique<Type>(arr: Type[]): Type[] {
  return [...new Set(arr)];
}

export function zip<Type>(lhs: Type[], rhs: Type[]): [Type, Type][] {
  return Array.from(Array(Math.max(lhs.length, rhs.length)), (_, i) => [
    lhs[i],
    rhs[i],
  ]);
}

export function equal<T>(a: T[], b: T[]): boolean {
  if (typeof a !== typeof b) {
    return false;
  }

  if (a.length !== b.length) {
    return false;
  }

  return a.every((value, index) => value === b[index]);
}

export function range(start: number, end: number) {
  const size = end - start + 1;
  return [...Array(size).keys()].map((i) => i + start);
}
