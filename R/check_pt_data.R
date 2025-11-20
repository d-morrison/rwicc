check_pt_data = function(participant_level_data)
{
  if (with(participant_level_data, any(L > R))) stop("L must be <= R!")

  if (with(participant_level_data, any(duplicated(ID)))) stop("duplicate IDs")
}
