use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'VCS::Rcs::Parser',
    'VERSION_FROM'	=> 'lib/Rcs/Parser.pm',
#    'PREREQ_PM'		=> {Parse::Yapp => 1.04},
    'MAN3PODS' => { 'lib/Rcs/Parser.pm' => '$(INST_MAN3DIR)/VCS::Rcs::Parser.3' },
    'PM'		=> {
	'lib/Rcs/Parser.pm' 		=> '$(INST_LIBDIR)/Parser.pm',
	'lib/Rcs/YappRcsParser.pm' 	=> '$(INST_LIBDIR)/YappRcsParser.pm',
	'lib/Rcs/Deltatext.pm'		=> '$(INST_LIBDIR)/Deltatext.pm',
			}, 
);
