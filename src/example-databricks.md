---
theme: dashboard
title: Databricks dashboard
toc: false
---

# Databricks 🚀

<!-- Load and transform the data -->

```js
const db_table = FileAttachment("data/databricks.csv").csv({typed: true});
```

<div class="grid grid-cols-4">
  <div class="card">
    <h2>Rides</h2>
    <span class="big">${db_table.length.toLocaleString("en-US")}</span>
  </div>
  <div class="card">
    <h2>Average Fare</h2>
    <span class="big">
      ${(
        db_table.reduce((sum, row) => sum + row.fare_amount, 0) / db_table.length
      ).toLocaleString("en-US", {style: "currency", currency: "USD"})}
    </span>
  </div>
  <div class="card">
    <h2>Average Trip Distance</h2>
    <span class="big">
      ${(
        db_table.reduce((sum, row) => sum + row.trip_distance, 0) / db_table.length
      ).toLocaleString("en-US", {maximumFractionDigits: 2})} miles
    </span>
  </div>
  <div class="card">
    <h2>Average Trip Duration</h2>
    <span class="big">
      ${(
        db_table.reduce((sum, row) => {
          const pickup = new Date(row.tpep_pickup_datetime);
          const dropoff = new Date(row.tpep_dropoff_datetime);
          const duration = (dropoff - pickup) / (1000 * 60); // Convert milliseconds to minutes
          return sum + duration;
        }, 0) / db_table.length
      ).toLocaleString("en-US", {maximumFractionDigits: 2})} minutes
    </span>
  </div>
</div>


<div class="grid grid-cols-1">
  <div class="card" style="padding: 0;">
    ${Inputs.table(
      db_table.map((row) => ({
        ...row,
        tpep_pickup_datetime: new Date(row.tpep_pickup_datetime).toLocaleString("en-US", {
          year: "numeric",
          month: "short",
          day: "numeric",
          hour: "2-digit",
          minute: "2-digit",
          second: "2-digit",
        }),
        tpep_dropoff_datetime: new Date(row.tpep_dropoff_datetime).toLocaleString("en-US", {
          year: "numeric",
          month: "short",
          day: "numeric",
          hour: "2-digit",
          minute: "2-digit",
          second: "2-digit",
        }),
      }))
    )}
  </div>
</div>


<!-- Plot of launch vehicles -->

```js
function pickupZip(data, {width}) {
  return Plot.plot({
    title: "Pickup Counts by ZipCode",
    width,
    height: 600,
    marginTop: 0,
    marginLeft: 50,
    x: {
      grid: true,
      label: "Times",
      tickFormat: (d) => (Number.isInteger(d) ? d : ""), // Only display whole numbers
      ticks: data.length, // Ensure enough ticks for the range
    },
    y: {label: null},
    color: {
      type: "categorical", // Use a categorical color scale
      legend: false,       // Display a legend
    },
    marks: [
      Plot.rectX(
        data,
        Plot.groupY(
          {x: "count"},
          {
            y: "pickup_zip",
            fill: (d) => d.pickup_zip, // Assign color based on the `dropoff_zip` column
            tip: true,
            sort: {y: "-x"}
          }
        )
      ),
      Plot.ruleX([0])
    ]
  });
}
```

<div class="grid grid-cols-1">
  <div class="card">
    ${resize((width) => pickupZip(db_table, {width}))}
  </div>
</div>

```js
function dropoffZip(data, {width}) {
  return Plot.plot({
    title: "Dropoff Counts by ZipCode",
    width,
    height: 600,
    marginTop: 0,
    marginLeft: 50,
    x: {
      grid: true,
      label: "Times",
      tickFormat: (d) => (Number.isInteger(d) ? d : ""), // Only display whole numbers
      ticks: data.length, // Ensure enough ticks for the range
    },
    y: {label: null},
    color: {
      type: "categorical", // Use a categorical color scale
      legend: false,       // Display a legend
    },
    marks: [
      Plot.rectX(
        data,
        Plot.groupY(
          {x: "count"},
          {
            y: "dropoff_zip",
            fill: (d) => d.dropoff_zip, // Assign color based on the `dropoff_zip` column
            tip: true,
            sort: {y: "-x"}
          }
        )
      ),
      Plot.ruleX([0])
    ]
  });
}
```

<div class="grid grid-cols-1">
  <div class="card">
    ${resize((width) => dropoffZip(db_table, {width}))}
  </div>
</div>