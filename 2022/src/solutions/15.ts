import { range, unique } from "../common/array";
import { readDayInput } from "../common/io";

type Point = {
  x: number;
  y: number;
};

type BeaconSensorPair = {
  beacon: Point;
  sensor: Point;
};

const data: BeaconSensorPair[] = readDayInput(15)
  .split("\n")
  .map((x) =>
    x
      .replace("Sensor at ", "")
      .split(": closest beacon is at ")
      .map((x) =>
        x
          .split(", ")
          .map((y) => parseInt(y.replace("x=", "").replace("y=", ""))),
      ),
  )
  .map((x) => {
    const sensor: Point = {
      x: x[0][0],
      y: x[0][1],
    };
    const beacon: Point = {
      x: x[1][0],
      y: x[1][1],
    };

    return {
      sensor,
      beacon,
    };
  });

function manhattanDistance(a: Point, b: Point) {
  return Math.abs(a.x - b.x) + Math.abs(a.y - b.y);
}

function findKnownNonBeaconLocations(pair: BeaconSensorPair) {
  const { sensor, beacon } = pair;
  const distance = manhattanDistance(sensor, beacon);

  const xCoords = range(sensor.x - distance, sensor.x + distance);
  const yCoords = range(sensor.y - distance, sensor.y + distance);

  return xCoords.flatMap((x) => yCoords.map((y) => ({ x, y }))).filter((pt) => manhattanDistance(pt, sensor) < distance);
}

function findImpossibleBeaconLocations(grid: Point[]) {
    // New idea: Sort the sensor locations by x and y,
    // then iterate over each point. For each point, find the nearest sensor.
    // If it's within the sensor's radius ...
    const beaconLocations = unique(data.flatMap(findKnownNonBeaconLocations))
    const sensorLocations = unique(data.map(pair => pair.sensor))

    return beaconLocations.filter(loc => {
        const isSensor = sensorLocations.some(sensor => sensor.x === loc.x && sensor.y === loc.y)

        return !isSensor
    })
}

const maxX = Math.max(...data.map(pair => Math.max(pair.sensor.x, pair.beacon.x)))
const maxY = Math.max(...data.map(pair => Math.max(pair.sensor.y, pair.beacon.y)))
const minX = Math.min(...data.map(pair => Math.min(pair.sensor.x, pair.beacon.x)))
const minY = Math.min(...data.map(pair => Math.min(pair.sensor.y, pair.beacon.y)))

const grid = range(minX, maxX).flatMap(x => range(minY, maxY).map(y => ({ x, y })))

// const locs = findImpossibleBeaconLocations(data).filter(l => l.x === 2000000)

// console.log(locs, locs.length)