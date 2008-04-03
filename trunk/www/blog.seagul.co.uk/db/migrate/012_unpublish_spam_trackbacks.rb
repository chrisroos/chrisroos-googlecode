class UnpublishSpamTrackbacks < ActiveRecord::Migration
  
  def self.up
    update "UPDATE trackbacks SET published = false WHERE id in (23809, 24977, 25061, 25064, 25669, 26534, 27366, 27568, 28554, 29270, 29760, 31413, 32186, 32187, 32342, 36375, 36458, 40252, 41099, 54315, 56784, 56986, 57004, 59956, 60132, 60955, 62975, 62976, 62977, 62978, 62979, 62980, 62981, 62982, 63295, 63296, 63297, 63298, 63299, 63300, 63302, 63303, 63304, 63560, 63561, 63562, 63563, 63564, 63566, 63567, 65838, 65839, 65840, 65841, 65843, 65844, 65845, 65846, 65881, 65882, 65883, 65884, 65885, 65886, 65887, 65888, 65889, 65890, 69371, 69372, 69373, 69374, 69375, 69376, 69377, 69378, 69380, 69381, 70804, 70860, 70861, 70862, 70863, 70864, 70865, 70866, 70867, 70868, 70869, 70871, 70873, 70874, 70875, 70876, 70877, 70878, 70879, 70880, 70881, 70882, 70883, 70884, 70885, 70886, 70887, 70888, 70889, 70890, 70891, 70892, 70893, 70896, 70955, 70956, 71080, 71130, 71171, 71508, 71509, 71510, 71511, 71512, 71513, 71514, 71515, 71516, 71517, 71518, 71519, 71520, 71522, 71523, 71524, 71525, 71526, 71528, 71529, 71531, 71532, 71533, 71534, 71536, 71537, 71582, 71583, 71584, 71585, 71587, 71588, 71589, 71592, 71593, 71594, 71595, 71596, 71597, 71598, 71599, 71600, 71601, 71602, 71603, 71604, 71752, 71753, 71754, 71755, 71756, 71757, 71758, 71760, 71762, 71763, 71764, 71765, 71767, 71768, 71769, 71770, 71771, 71772, 71773, 71774, 71775, 71777, 71778, 71779, 71780, 71781, 71782, 71783, 71784, 71785, 71786, 71787, 71788, 71789, 71790, 71793, 71795, 71796, 71797, 71798, 71799, 71800, 71801, 73222, 73223, 73224, 73225, 73227, 73229, 73230, 73233, 73234, 73235, 73237, 73240, 73241, 73242, 73244, 73246, 73247, 73248, 73249, 73250, 73252)"
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end