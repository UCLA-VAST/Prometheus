import islpy as isl

def are_schedules_compatible(schedule1, schedule2):
    # Create an ISL context
    ctx = isl.Context()

    # Create ISL schedule domains from the provided schedule strings
    schedule_domain1 = isl.UnionSet(ctx, schedule1)
    schedule_domain2 = isl.UnionSet(ctx, schedule2)

    # Check if the two schedules have a non-empty intersection
    are_compatible = not schedule_domain1.intersect(schedule_domain2).is_empty()

    return are_compatible

if __name__ == "__main__":
    # Example schedule strings
    schedule_str1 = "[{ S1[i] -> [i] : 0 <= i < 10; S2[j] -> [j] : 5 <= j < 15; }] -> { S1[i] -> [i]; S2[j] -> [j]; }"
    schedule_str2 = "[{ S1[i] -> [i] : 0 <= i < 10; S3[k] -> [k] : 10 <= k < 20; }] -> { S1[i] -> [i]; S3[k] -> [k]; }"

    are_compatible = are_schedules_compatible(schedule_str1, schedule_str2)

    if are_compatible:
        print("The schedules are compatible.")
    else:
        print("The schedules are not compatible.")
