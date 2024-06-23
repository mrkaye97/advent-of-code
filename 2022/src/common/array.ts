export function unique<Type>(arr: Type[]): Type[] {
  return [...new Set(arr)];
}
