# Code Book

## Source data

UCI HAR Dataset: accelerometer and gyroscope signals recorded from a Samsung Galaxy S smartphone worn on the waist by 30 volunteers (ages 19-48) performing six activities. Data were split by the original authors into a training set (21 subjects) and a test set (9 subjects). Signals were sampled at 50 Hz and processed into 561 features per 2.56 s window.

Raw files used: `features.txt`, `activity_labels.txt`, and for each of `train` and `test`: `X_*.txt`, `y_*.txt`, `subject_*.txt`. The Inertial Signals folders are not used.

## Transformations

1. Train and test sets were row-bound into one data set (10,299 observations), with subject and activity columns added.
2. Only features containing `mean()` or `std()` were kept: 66 of the 561 features. Features such as `meanFreq()` and the `angle(...)` variables were not kept.
3. Activity ids were replaced with descriptive labels (lower case).
4. Variable names were cleaned:
   - `t` prefix -> `Time`, `f` prefix -> `Frequency`
   - `Acc` -> `Accelerometer`, `Gyro` -> `Gyroscope`, `Mag` -> `Magnitude`
   - `BodyBody` -> `Body` (fixes a typo in the original names)
   - `-mean()` -> `Mean`, `-std()` -> `StdDev`
   - parentheses and hyphens removed
5. The merged data were grouped by subject and activity, and the mean of every measurement variable was taken. Result: 180 rows x 68 columns.

## Variables in `tidy_data.txt`

| Variable | Type | Description |
|---|---|---|
| `subject` | integer, 1-30 | Volunteer identifier |
| `activity` | character | One of: `walking`, `walking_upstairs`, `walking_downstairs`, `sitting`, `standing`, `laying` |
| 66 measurement columns | numeric | Average, for that subject and activity, of the original normalized feature (values bounded in [-1, 1], unitless) |

### Measurement column naming

Each name is built as: **domain + signal + sensor + [jerk] + [magnitude] + statistic + [axis]**

- Domain: `Time` (time-domain signal) or `Frequency` (FFT-derived)
- Signal: `Body` or `Gravity` acceleration component
- Sensor: `Accelerometer` or `Gyroscope`
- `Jerk`: jerk signal derived in time
- `Magnitude`: Euclidean norm of the 3-axis signal
- Statistic: `Mean` (mean value) or `StdDev` (standard deviation)
- Axis: `X`, `Y` or `Z` (absent for magnitude variables)

Examples: `TimeBodyAccelerometerMeanX`, `TimeGravityAccelerometerStdDevZ`, `FrequencyBodyGyroscopeJerkMagnitudeMean`.

### Full list of measurement variables

Time domain:
- `TimeBodyAccelerometer{Mean,StdDev}{X,Y,Z}`
- `TimeGravityAccelerometer{Mean,StdDev}{X,Y,Z}`
- `TimeBodyAccelerometerJerk{Mean,StdDev}{X,Y,Z}`
- `TimeBodyGyroscope{Mean,StdDev}{X,Y,Z}`
- `TimeBodyGyroscopeJerk{Mean,StdDev}{X,Y,Z}`
- `TimeBodyAccelerometerMagnitude{Mean,StdDev}`
- `TimeGravityAccelerometerMagnitude{Mean,StdDev}`
- `TimeBodyAccelerometerJerkMagnitude{Mean,StdDev}`
- `TimeBodyGyroscopeMagnitude{Mean,StdDev}`
- `TimeBodyGyroscopeJerkMagnitude{Mean,StdDev}`

Frequency domain:
- `FrequencyBodyAccelerometer{Mean,StdDev}{X,Y,Z}`
- `FrequencyBodyAccelerometerJerk{Mean,StdDev}{X,Y,Z}`
- `FrequencyBodyGyroscope{Mean,StdDev}{X,Y,Z}`
- `FrequencyBodyAccelerometerMagnitude{Mean,StdDev}`
- `FrequencyBodyAccelerometerJerkMagnitude{Mean,StdDev}`
- `FrequencyBodyGyroscopeMagnitude{Mean,StdDev}`
- `FrequencyBodyGyroscopeJerkMagnitude{Mean,StdDev}`
