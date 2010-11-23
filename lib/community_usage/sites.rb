
# A mixin for accessing all the sites


#
# Populates a hash class variable of the report.rb class - @@sites
#
# Is called on report initialization, but since it is a class variable it is available
# to all instances of report + children.
#
# There is a check so get_sites is only called once / isn't messed with by children of Report
#
# Key is the site name, value is the site object (see site.rb and the mixin methods in stats.rb)
#
# Sites can be accessed individually with their key:
#
# @@sites[:portal].visits
# @@sites[:promoting_healthy_lifestyles].name
#
# Or with iterators like:
#
# @@sites.each {|key, site| puts site.name}
#
# Since hashes have no particular order in < ruby 1.9, you want to iterate with the hash#values method usually:
#
# @@sites.values.each {|site| puts site.name}
#

module Sites

  #
  #  Community => true if it's from http://www.tki.org.nz/Communities   otherwise nil
  #
  #  Total => true if it should be included in the totals for the report  otherwise nil
  #

  def get_sites
    list = [

    # GA profile    Name                                community?         total?             slice
    ["7901135",     "Legacy",                           true,              true,               {:total => '1219464740', :nz => '1687910005'}  ],
    ["35630502",    "Portal",                           true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7901135",     "Alternative Education",            true,              nil,                {:total => '247248207', :nz => '763932529'}    ],
    ["7901135",     "Arts Community",                   true,              nil,                {:total => '1434655333', :nz => '538654675'}   ],
    ["34260881",    "Arts Online",                      true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7922426",     "Asia Knowledge",                   true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["10449435",    "Assessment Online",                true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["25951702",    "Digistore",                        true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["9760563",     "Digital Technology Guidelines",    true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["10448201",    "e-asTTle",                         true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7901135",     "EPIC",                             true,              nil,                {:total => '1939313610', :nz => '1615165815'}  ],
    ["12471470",    "Education for Enterprise",         true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["9029662",     "Education for Sustainability",     true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["16845949",    "Educational Leaders",              true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["24247105",    "e-Learning as Inquiry",            nil,               true,               {:total => nil, :nz => '2145762637'}           ],
    ["14920696",    "English Online",                   true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["9371510",     "EOTC/LEOTC",                       true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["14920893",    "ESOL Online",                      true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["35824089",    "Gifted and Talented",              true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7901135",     "Health and PE",                    true,              nil,                {:total => '1192211562', :nz => '168815002'}   ],
    ["36229745",    "Health Promoting Schools",         true,              true,               {:total => nil, :nz => '2145762637'}   		    ],
    ["14962720",    "He Kohinga Rauemi a Ipu Rangi",    true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["22192627",    "Hoatu Homai",                      true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["22900702",    "Home-School Partnerships",         true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7901135",     "INNZ",                             true,              nil,                {:total => '1192211562', :nz => '168815002'}   ],
    ["7901135",     "ICT Community",                    true,              nil,                {:total => '1205725128', :nz => '1174462207'}  ],
    ["24329144",    "ICT Helpdesk",                     true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["19644726",    "Key Competencies",                 true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["26488837",    "Kia Mau",                          true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["10617005",    "Ki te Auturoa",                    true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["9969846",     "Language Immersion Opportunities", true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["8272347",     "LEAP",                             true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7901135",     "Learning Languages Community",     true,              nil,                {:total => '901300457', :nz => '841139348'}    ],
    ["24247423",    "Learning Languages Curriculum Guides", true,          true,               {:total => nil, :nz => '2145762637'}           ],
    ["24247516",    "Learning Languages with ICTs",     nil,               true,               {:total => nil, :nz => '2145762637'}           ],
    ["14920959",    "Literacy Online",                  true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["34229704",    "Literacy Learning Progressions",   true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7901135",     "Maori Education",                  true,              nil,                {:total => '940414221', :nz => '2145762637'}   ],
    ["26200548",    "Ma te Pouaka",                     true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7901144",     "Media Studies",                    true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["9226697",     "NZ Curriculum",                    true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7901135",     "NCEA",                             true,              nil,                {:total => '1190271723', :nz => '453641217'}   ],
    ["7901135",     "Nga Toi Online",                   true,              nil,                {:total => '1272072292', :nz => '651106653'}   ],
    ["36101231",    "Pasifika",                         true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["8272137",     "Promoting Healthy Lifestyles",     true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["23725351",    "Putaiao",                          true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["10354806",    "RTLB",                             true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["34006372",    "Science Online",                   true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["14920959",    "Secondary Literacy Project",       true,              nil,                {:total => '1034945190', :nz => '1700825154'}  ],
    ["9760559",     "Senior Secondary Curriculum Guidelines", true,        true,               {:total => nil, :nz => '2145762637'}           ],
    ["11978273",    "Software for Learning",            true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["9555576",     "Sounds and Words",                 true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7992968",     "Social Sciences Online",           true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["7901135",     "Student Support",                  true,              nil,                {:total => '1599237438', :nz => '1440624382'}  ],
    ["9371496",     "Success for Boys",                 true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["23522664",    "Taihape Area School",              nil,               true,               {:total => nil, :nz => '2145762637'}           ],
    ["16617864",    "Te Reo Maori",                     true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["19752543",    "Te tere Auraki",                   true,              true,               {:total => nil, :nz => '2145762637'}           ],
    ["16845949",    "Tu Rangatira",                     true,              nil,                {:total => '1961915044', :nz => '227756734'}   ]


    ]

    if !self.sites?
      sites = Hash.new

      list.each do |site|
      	str = site[1].downcase.tr(" ", "_").tr("/", "_")
      	sites[str.to_sym]= Site.new(site[1], site[0], site[2], site[3], site[4])
      end
    end
    sites
  end

end

