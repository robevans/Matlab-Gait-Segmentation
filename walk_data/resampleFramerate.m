function resampled_data = resampleFramerate(data, original_time_vector, target_framerate)

data_timeseries = timeseries(data, original_time_vector);
resampled_timeseries = resample(data_timeseries, [ min(original_time_vector) : (1/target_framerate) : max(original_time_vector) ] );
resampled_data = resampled_timeseries.Data;