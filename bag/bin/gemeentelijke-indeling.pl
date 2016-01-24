#!/usr/bin/perl -w
#
# Update gemeentelijke-indeling.xml with CBS spreadsheet data for next year.
#
# Required dependencies (Debian/Ubuntu):
#
#  libclone-perl libdatetime-perl libfile-slurp-perl
#  libspreadsheet-parseexcel-perl libxml-libxml-perl
#
# Required dependencies (CPAN):
#
#  Clone DateTime File::Slurp Spreadsheet::ParseExcel XML::LibXML
#
# Copyright (C) 2016, Bas Couwenberg <sebastic@xs4all.nl>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

use strict;
use Clone 'clone';
use DateTime;
use File::Basename;
use File::Slurp;
use Getopt::Long qw(:config bundling no_ignore_case);
use Spreadsheet::ParseExcel;
use XML::LibXML;

$|=1;

my %cfg = (
	    add_cbs_data  => 0,
	    end_gemeente  => 0,
	    add_gemeente  => 0,
	    provincie_map => 0,

	    input         => '',
	    output        => '',
	    file          => '',

	    code          => 0,
	    name          => '',
	    date          => '',
	    prov          => '',

	    dry_run       => 0,
	    debug         => 0,
	    verbose       => 0,
	    help          => 0,
	  );

my $result = GetOptions(
			 'add-cbs-data'  => \$cfg{add_cbs_data},
			 'end-gemeente'  => \$cfg{end_gemeente},
			 'add-gemeente'  => \$cfg{add_gemeente},
			 'provincie-map' => \$cfg{provincie_map},

			 'i|input=s'     => \$cfg{input},
			 'o|output=s'    => \$cfg{output},
			 'f|file=s'      => \$cfg{file},

			 'C|code=i'      => \$cfg{code},
			 'N|name=s'      => \$cfg{name},
			 'D|date=s'      => \$cfg{date},
			 'P|prov=s'      => \$cfg{prov},

			 'n|dry-run'     => \$cfg{dry_run},
			 'd|debug'       => \$cfg{debug},
			 'v|verbose'     => \$cfg{verbose},
			 'h|help'        => \$cfg{help},
		       );

if(!$result || $cfg{help} || !$cfg{input} ||
   ($cfg{add_cbs_data} && !$cfg{file}) ||
   ($cfg{end_gemeente} && (!$cfg{prov} || !$cfg{code} || !$cfg{date})) ||
   ($cfg{add_gemeente} && (!$cfg{prov} || !$cfg{code} || !$cfg{name} || !$cfg{date}))
) {
	print STDERR "\n" if(!$result);

	print "Usage: ". basename($0) ." <ACTION> -i <PATH> [-o <PATH>] [OPTIONS]\n\n";
	print "Actions:\n";
	print "--add-cbs-data          Add CBS spreadsheet data for next year\n";
	print "                        Requires option: --file\n";
	print "--end-gemeente          Set einddatum attribute for gemeente\n";
	print "                        Requires option: --code, --date, --prov\n";
	print "--add-gemeente          Create new gemeente element\n";
	print "                        Requires option: --code, --name, --date, --prov\n";
	print "--provincie-map         Display provicie map (code & name)\n";
	print "\n";
	print "Options:\n";
	print "-i, --input <PATH>      Path to gemeentelijke-indeling XML file to read\n";
	print "-o, --output <PATH>     Path to gemeentelijke-indeling XML file to write\n";
	print "-f, --file <PATH>       Path to CBS Excel spreadsheet to process\n";
	print "\n";
	print "-C, --code <NUMBER>     Numerical gemeentecode\n";
	print "-N, --name <STRING>     Alphanumerical gemeentenaam\n";
	print "-D, --date <DATE>       Date in YYYY-MM-DD format\n";
	print "-P, --prov <NAME|CODE>  Parent provincie of gemeente\n";
	print "\n";
	print "-n, --dry-run           Don't overwrite the file, display instead\n";
	print "-d, --debug             Enable debug output\n";
	print "-v, --verbose           Enable verbose output\n";
	print "-h, --help              Display this usage information\n";

	exit 1;
}
if($cfg{date} && $cfg{date} !~ /^\d{4}-\d{2}-\d{2}$/) {
	print "Error: Invalid date format, use YYYY-MM-DD\n";
	exit 1;
}
$cfg{output} = $cfg{input} if(!$cfg{output});

my %gemeentelijke_indeling = parse_gemeentelijke_indeling($cfg{input});

my %provincie_map = get_provincie_map(%gemeentelijke_indeling);

if($cfg{provincie_map}) {
	display_provincie_map(%provincie_map);
	exit 0;
}
elsif($cfg{end_gemeente}) {
	%gemeentelijke_indeling = end_gemeente($cfg{prov}, $cfg{code}, $cfg{date}, %gemeentelijke_indeling);
}
elsif($cfg{add_gemeente}) {
	%gemeentelijke_indeling = add_gemeente($cfg{prov}, $cfg{code}, $cfg{name}, $cfg{date}, %gemeentelijke_indeling);
}
elsif($cfg{add_cbs_data}) {
	my %cbs_data = parse_cbs_data($cfg{file});

	%gemeentelijke_indeling = add_cbs_data(\%gemeentelijke_indeling, %cbs_data);
}

write_gemeentelijke_indeling($cfg{output}, %gemeentelijke_indeling);

exit 0;

################################################################################
# Subroutines

sub parse_gemeentelijke_indeling {
	my ($file) = @_;

	my %gemeentelijke_indeling = ();

	if(!-r $file) {
		print "Error: Cannot read file: $file\n" if($cfg{verbose});
		return;
	}

	print "Parsing XML file: $file\n" if($cfg{verbose});

	my $dom = XML::LibXML->load_xml(location => $file);

	my $root = $dom->documentElement;

	if($root->nodeName ne 'gemeentelijke_indeling') {
		print "Error: Expected element 'gemeentelijke_indeling', found: ". $root->nodeName ."\n" if($cfg{verbose});
		return;
	}

	if(!$root->hasAttributes) {
		print "Error: No attributes found for: ". $root->nodeName ."\n" if($cfg{verbose});
		return;
	}

	foreach my $attribute ($root->attributes) {
		$gemeentelijke_indeling{attributes}{$attribute->nodeName} = $attribute->getValue;
	}

	if(!$root->hasChildNodes) {
		print "Error: No child nodes for: ". $root->nodeName ."\n" if($cfg{verbose});
		return;
	}

	my @indeling_nodes = $root->getElementsByTagName('indeling');
	my $indeling_count = -1;

	foreach my $indeling_node (@indeling_nodes) {
		$indeling_count++;

		my @required_indeling_attributes = qw(jaar);
		foreach my $attribute (@required_indeling_attributes) {
			if(!$indeling_node->hasAttribute($attribute)) {
				print "Error: No '$attribute' attribute for 'indeling' [$indeling_count]\n" if($cfg{verbose});
				return;
			}
		}

		my $jaar = $indeling_node->getAttribute('jaar');

		my %indeling = (
				 attributes => {
						 jaar => $jaar,
					       },
			       );

		my @provincie_nodes = $indeling_node->getElementsByTagName('provincie');
		my $provincie_count = -1;

		foreach my $provincie_node (@provincie_nodes) {
			$provincie_count++;

			my @required_provincie_attributes = qw(code naam);
			foreach my $attribute (@required_provincie_attributes) {
				if(!$provincie_node->hasAttribute($attribute)) {
					print "Error: No '$attribute' attribute for 'provincie' [$provincie_count]\n" if($cfg{verbose});
					return;
				}
			}

			my $provincie_code = $provincie_node->getAttribute('code');
			my $provincie_naam = $provincie_node->getAttribute('naam');

			my %provincie = (
					  attributes => {
							  code => $provincie_code,
							  naam => $provincie_naam,
							},
					);

			my @gemeente_nodes = $provincie_node->getElementsByTagName('gemeente');
			my $gemeente_count = -1;

			foreach my $gemeente_node (@gemeente_nodes) {
				$gemeente_count++;

				my @required_gemeente_attributes = qw(code naam begindatum);
				foreach my $attribute (@required_gemeente_attributes) {
					if(!$gemeente_node->hasAttribute($attribute)) {
						print "Error: No '$attribute' attribute for 'gemeente' [$gemeente_count]\n" if($cfg{verbose});
						return;
					}
				}

				my $gemeente_code = $gemeente_node->getAttribute('code');
				my $gemeente_naam = $gemeente_node->getAttribute('naam');
				my $begindatum    = $gemeente_node->getAttribute('begindatum');
				my $einddatum     = $gemeente_node->getAttribute('einddatum');

				my %gemeente = (
						 attributes => {
								 code       => $gemeente_code,
								 naam       => $gemeente_naam,
								 begindatum => $begindatum,
								 einddatum  => $einddatum,
							       },
					       );

				$provincie{gemeente}{$gemeente_code} = \%gemeente;
			}

			$indeling{provincie}{$provincie_code} = \%provincie;
		}

		$gemeentelijke_indeling{indeling}{$jaar} = \%indeling;
	}

	return %gemeentelijke_indeling;
}

sub write_gemeentelijke_indeling {
	my ($file, %gemeentelijke_indeling) = @_;

	print "Building XML structure...\n" if($cfg{verbose});

	my $dom = XML::LibXML::Document->new('1.0', 'UTF-8');

	my $root = $dom->createElement('gemeentelijke_indeling');

	my @attributes = qw(xmlns xmlns:xsi xsi:schemaLocation);
	foreach my $attribute (@attributes) {
		$root->setAttribute($attribute, $gemeentelijke_indeling{attributes}{$attribute});
	}

	$dom->setDocumentElement($root);

	foreach my $jaar (sort { $a <=> $b } keys %{$gemeentelijke_indeling{indeling}}) {
		my $indeling = $dom->createElement('indeling');

		my @attributes = qw(jaar);
		foreach my $attribute (@attributes) {
			$indeling->setAttribute($attribute, $gemeentelijke_indeling{indeling}{$jaar}{attributes}{$attribute});
		}

		foreach my $provinciecode (sort { $a <=> $b } keys %{$gemeentelijke_indeling{indeling}{$jaar}{provincie}}) {
			my $provincie = $dom->createElement('provincie');

			my @attributes = qw(code naam);
			foreach my $attribute (@attributes) {
				$provincie->setAttribute($attribute, $gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}{attributes}{$attribute});
			}

			foreach my $gemeentecode (sort { $a <=> $b } keys %{$gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}{gemeente}}) {
				my $gemeente = $dom->createElement('gemeente');

				my @attributes = qw(code naam begindatum einddatum);
				foreach my $attribute (@attributes) {
					next if(!$gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}{gemeente}{$gemeentecode}{attributes}{$attribute});

					$gemeente->setAttribute($attribute, $gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}{gemeente}{$gemeentecode}{attributes}{$attribute});
				}

				$provincie->appendChild($gemeente);
			}

			$indeling->appendChild($provincie);
		}

		$root->appendChild($indeling);
	}

	my $xml = $dom->toString(2);

	if($cfg{dry_run}) {
		print "Not saving file: $file (DRY-RUN)\n" if($cfg{verbose});

		print $xml;
	}
	else {
		print "Saving file: $file\n" if($cfg{verbose});

		print $xml if($cfg{debug});

		write_file($file, $xml);
	}
}

sub end_gemeente {
	my ($prov, $gemeentecode, $einddatum, %gemeentelijke_indeling) = @_;

	$gemeentecode = strip_leading_zeros($gemeentecode);

	my $jaar = get_last_year(%gemeentelijke_indeling);

	my $provinciecode = strip_leading_zeros($prov);
	my $provincienaam =  $prov;

	if($prov !~ /^\d+$/ && $provincie_map{name2code}{$prov}) {
		$provinciecode = $provincie_map{name2code}{$prov};
		$provincienaam = $provincie_map{code2name}{$provinciecode};
	}

	if($gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode} &&
	   $gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}{gemeente}{$gemeentecode}
	) {
		my $gemeentenaam = $gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}{gemeente}{$gemeentecode}{attributes}{naam};
		my $begindatum   = $gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}{gemeente}{$gemeentecode}{attributes}{begindatum};

		print "Setting einddatum for gemeente $gemeentenaam ($gemeentecode) [$begindatum|$einddatum] in provincie $provincienaam ($provinciecode)\n" if($cfg{verbose});

		$gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}{gemeente}{$gemeentecode}{attributes}{einddatum} = $einddatum;
	}

	return %gemeentelijke_indeling;
}

sub add_gemeente {
	my ($prov, $gemeentecode, $gemeentenaam, $begindatum, %gemeentelijke_indeling) = @_;

	$gemeentecode = strip_leading_zeros($gemeentecode);

	my $jaar = get_last_year(%gemeentelijke_indeling);

	my $provinciecode = strip_leading_zeros($prov);
	my $provincienaam = $prov;

	if($prov !~ /^\d+$/ && $provincie_map{name2code}{$prov}) {
		$provinciecode = $provincie_map{name2code}{$prov};
		$provincienaam = $provincie_map{code2name}{$provinciecode};
	}

	if($gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}) {
		my %gemeente = (
				 attributes => {
						 code       => $gemeentecode,
						 naam       => $gemeentenaam,
						 begindatum => $begindatum,
					       },
			       );

		print "Adding gemeente $gemeentenaam ($gemeentecode) [$begindatum] to provincie $provincienaam ($provinciecode)\n" if($cfg{verbose});

		$gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}{gemeente}{$gemeentecode} = \%gemeente;
	}


	return %gemeentelijke_indeling;
}

sub parse_cbs_data {
	my ($file) = @_;

	if(!-r $file) {
		print "Error: Cannot read input file: $file\n" if($cfg{verbose});
		return;
	}

	print "Parsing XLS file: $file\n" if($cfg{verbose});

	my $parser   = Spreadsheet::ParseExcel->new();
	my $workbook = $parser->parse($file);

	if(!defined $workbook) {
		print "Error: Parsing spreadsheet failed (". $parser->error() .")\n" if($cfg{verbose});
		return;
	}

	my %cbs_data = ();

	foreach my $worksheet ($workbook->worksheets()) {
		my $cell  = $worksheet->get_cell(0,0);
		my $value = $cell->unformatted();

		if(!$value) {
			print "Warning: No value in cell 0,0, skipping worksheet: ". $worksheet->get_name() ."\n" if($cfg{verbose});
			next;
		}

		my @header = ();
		foreach my $i (0..3) {
			my $cell  = $worksheet->get_cell(0,$i);
			my $value = $cell->unformatted();

			push @header, $value;
		}

		my %column = ();

		# Gemeentecode	Gemeentenaam	Provincienaam	Provinciecode
		if($header[0] eq 'Gemeentecode'  &&
		   $header[1] eq 'Gemeentenaam'  &&
		   $header[2] eq 'Provincienaam' &&
		   $header[3] eq 'Provinciecode'
		) {
			%column = (
				    gemeentecode  => 0,
				    gemeentenaam  => 1,
				    provincienaam => 2,
				    provinciecode => 3,
				  );
		}
		# Gemeentecode	Provinciecode	Gemeentenaam	Provincienaam
		elsif($header[0] eq 'Gemeentecode'  &&
		      $header[1] eq 'Provinciecode' &&
		      $header[2] eq 'Gemeentenaam'  &&
		      $header[3] eq 'Provincienaam'
		) {
			%column = (
				    gemeentecode  => 0,
				    provinciecode => 1,
				    gemeentenaam  => 2,
				    provincienaam => 3,
				  );
		}
		# prov_Gemcode	provcode	Gemcodel	provcodel
		elsif($header[0] eq 'prov_Gemcode' &&
		      $header[1] eq 'provcode'     &&
		      $header[2] eq 'Gemcodel'     &&
		      $header[3] eq 'provcodel'
		) {
			%column = (
				    gemeentecode  => 0,
				    provinciecode => 1,
				    gemeentenaam  => 2,
				    provincienaam => 3,
				  );
		}
		# Gemcode	provcode	Gemcodel	provcodel
		elsif($header[0] eq 'Gemcode'  &&
		      $header[1] eq 'provcode' &&
		      $header[2] eq 'Gemcodel' &&
		      $header[3] eq 'provcodel'
		) {
			%column = (
				    gemeentecode  => 0,
				    provinciecode => 1,
				    gemeentenaam  => 2,
				    provincienaam => 3,
				  );
		}
		# Gemcode	Gemcodel	provcode	provcodel
		elsif($header[0] eq 'Gemcode'  &&
		      $header[1] eq 'Gemcodel' &&
		      $header[2] eq 'provcode' &&
		      $header[3] eq 'provcodel'
		) {
			%column = (
				    gemeentecode  => 0,
				    gemeentenaam  => 1,
				    provinciecode => 2,
				    provincienaam => 3,
				  );
		}
		# Unsupported format
		else {
			if($cfg{verbose}) {
				print "Error: Unsupported header order: ";

				my $i = 0;
				foreach my $col (@header) {
					print " | " if($i > 0);
					print $col;
					$i++;
				}

				print "\n";
			}
			return;
		}

		my ($row_min, $row_max) = $worksheet->row_range();

		for(my $row = 1; $row <=  $row_max; $row++) {
			my %record = ();

			foreach my $key (qw(gemeentecode gemeentenaam provinciecode provincienaam)) {
				my $cell  = $worksheet->get_cell($row, $column{$key});
				my $value = $cell->unformatted();

				$record{$key} = $value;
			}

			if(!$record{gemeentecode} && !$record{gemeentenaam} && !$record{provinciecode} && !$record{provincienaam}) {
				print "Empty row, stoppping here.\n" if($cfg{verbose});
				last;
			}

			if(!$record{gemeentecode}) {
				print "Empty 'gemeentecode' column ($column{gemeentecode}), stoppping here.\n" if($cfg{verbose});
				last;
			}
			if(!$record{gemeentenaam}) {
				print "Empty 'gemeentenaam' column ($column{gemeentenaam}), stoppping here.\n" if($cfg{verbose});
				last;
			}
			if(!$record{provinciecode}) {
				print "Empty 'provinciecode' column ($column{provinciecode}), stoppping here.\n" if($cfg{verbose});
				last;
			}
			if(!$record{provincienaam}) {
				print "Empty 'provincienaam' column ($column{provincienaam}), stoppping here.\n" if($cfg{verbose});
				last;
			}

			foreach my $key (qw(gemeentecode provinciecode)) {
				$record{$key} = strip_leading_zeros($record{$key});
			}

			$cbs_data{$record{provinciecode}}{$record{gemeentecode}} = \%record;
		}

		last;
	}

	return %cbs_data;
}

sub add_cbs_data {
	my ($gemeentelijke_indeling, %cbs_data) = @_;

	my %gemeentelijke_indeling = %{$gemeentelijke_indeling};

	my $prev = get_last_year(%gemeentelijke_indeling);
	my $jaar = $prev + 1;

	print "Adding indeling for $jaar\n" if($cfg{verbose});

	my %indeling = %{ clone($gemeentelijke_indeling{indeling}{$prev}) };

	$indeling{attributes}{jaar} = $jaar;

	foreach my $provinciecode (sort { $a <=> $b } keys %cbs_data) {
		my $provincienaam = $indeling{provincie}{$provinciecode}{attributes}{naam};

		foreach my $gemeentecode (sort { $a <=> $b } keys %{$indeling{provincie}{$provinciecode}{gemeente}}) {
			my $gemeentenaam = $indeling{provincie}{$provinciecode}{gemeente}{$gemeentecode}{attributes}{naam};
			my $begindatum   = $indeling{provincie}{$provinciecode}{gemeente}{$gemeentecode}{attributes}{begindatum};
			my $einddatum    = $indeling{provincie}{$provinciecode}{gemeente}{$gemeentecode}{attributes}{einddatum};

			# Remove municipalities that ended in the previous year
			if($einddatum) {
				my $compare = compare_datum_and_year($einddatum, $jaar);
				if($compare == -1) {
					print "Removing gemeente $gemeentenaam ($gemeentecode) [$begindatum|$einddatum] from provincie $provincienaam ($provinciecode)\n" if($cfg{verbose});

					delete $indeling{provincie}{$provinciecode}{gemeente}{$gemeentecode};
				}
			}
			# Add einddatum attribute to municipalities that ended this year
			elsif(!$cbs_data{$provinciecode}{$gemeentecode}) {
				$einddatum = $jaar ."-01-01";

				print "Setting einddatum for gemeente $gemeentenaam ($gemeentecode) [$begindatum|$einddatum] in provincie $provincienaam ($provinciecode)\n" if($cfg{verbose});

				$indeling{provincie}{$provinciecode}{gemeente}{$gemeentecode}{attributes}{einddatum} = $einddatum;
			}
		}

		foreach my $gemeentecode (sort { $a <=> $b } keys %{$cbs_data{$provinciecode}}) {
			# Add municipalities created this year
			if(!$indeling{provincie}{$provinciecode}{gemeente}{$gemeentecode}) {
				my $gemeentenaam = $cbs_data{$provinciecode}{$gemeentecode}{gemeentenaam};
				my $begindatum   = $jaar ."-01-01";

				print "Adding gemeente $gemeentenaam ($gemeentecode) [$begindatum] to provincie $provincienaam ($provinciecode)\n" if($cfg{verbose});

				my %gemeente = (
						 attributes => {
								 code       => $gemeentecode,
								 naam       => $gemeentenaam,
								 begindatum => $begindatum,
							       },
					       );

				$indeling{provincie}{$provinciecode}{gemeente}{$gemeentecode} = \%gemeente;
			}
		}
	}

	$gemeentelijke_indeling{indeling}{$jaar} = \%indeling;

	return %gemeentelijke_indeling;
}

sub compare_datum_and_year {
	my ($datum, $year) = @_;

	my $date1 = '';

	if($datum =~ /^(\d{4})-(\d{2})-(\d{2})$/) {
		my $datum_year  = $1;
		my $datum_month = $2;
		my $datum_day   = $3;

		$date1 = DateTime->new(
					year       => $datum_year,
					month      => $datum_month,
					day        => $datum_day,
					hour       => 0,
					minute     => 0,
					second     => 0,
					nanosecond => 0,
					time_zone  => 'Europe/Amsterdam',
				      );
	}
	else {
		print "Error: Cannot parse datum: $datum\n" if($cfg{verbose});
		return;
	}

	my $date2 = DateTime->new(
				   year       => $year,
				   month      => 1,
				   day        => 1,
				   hour       => 0,
				   minute     => 0,
				   second     => 0,
				   nanosecond => 0,
				   time_zone  => 'Europe/Amsterdam',
				 );

	return DateTime->compare($date1, $date2);
}

sub strip_leading_zeros {
	my ($string) = @_;

	$string =~ s/^0+//g;

	return $string;
}

sub get_last_year {
	my (%gemeentelijke_indeling) = @_;

	my @indeling_keys = sort { $a <=> $b } keys %{$gemeentelijke_indeling{indeling}};

	return $indeling_keys[-1];
}

sub get_provincie_map {
	my (%gemeentelijke_indeling) = @_;

	my %provincie_map = (
			      code2name => {},
			      name2code => {},
			    );

	my $jaar = get_last_year(%gemeentelijke_indeling);

	foreach my $provinciecode (sort { $a <=> $b } keys %{$gemeentelijke_indeling{indeling}{$jaar}{provincie}}) {
		my $provincienaam = $gemeentelijke_indeling{indeling}{$jaar}{provincie}{$provinciecode}{attributes}{naam};

		$provincie_map{code2name}{$provinciecode} = $provincienaam;
		$provincie_map{name2code}{$provincienaam} = $provinciecode;
	}

	return %provincie_map;
}

sub display_provincie_map {
	my (%provincie_map) = @_;

	my %longest = ();
	my @columns = qw(code name);

	foreach my $column (@columns) {
		$longest{$column} = length($column);
	}

	foreach my $code (sort { $a <=> $b } keys %{$provincie_map{code2name}}) {
		my $name = $provincie_map{code2name}{$code};

		my %length = (
			       code => length($code),
			       name => length($name),
			     );

		foreach my $column (@columns) {
			$longest{$column} = $length{$column} if($length{$column} > $longest{$column});
		}
	}

	my $box_top    = "┌";
	my $box_middle = "├";
	my $box_bottom = "└";

	my $header = "│";

	my $i = 0;
	foreach my $column (@columns) {
		$box_top    .= "─". ("─" x $longest{$column}) ."─";
		$box_middle .= "─". ("─" x $longest{$column}) ."─";
		$box_bottom .= "─". ("─" x $longest{$column}) ."─";

		$header .= sprintf(" %-$longest{$column}s ", "\u\L$column");

		if($i < $#columns) {
			$box_top    .= "┬";
			$box_middle .= "┼";
			$box_bottom .= "┴";

			$header .= "│";
		}

		$i++;
	}

	$box_top    .= "┐ ┌";
	$box_middle .= "┤ ├";
	$box_bottom .= "┘ └";

	$header .= "│ │";

	$i = 0;
	foreach my $column (reverse @columns) {
		$box_top    .= "─". ("─" x $longest{$column}) ."─";
		$box_middle .= "─". ("─" x $longest{$column}) ."─";
		$box_bottom .= "─". ("─" x $longest{$column}) ."─";

		$header .= sprintf(" %-$longest{$column}s ", "\u\L$column");

		if($i < $#columns) {
			$box_top    .= "┬";
			$box_middle .= "┼";
			$box_bottom .= "┴";

			$header .= "│";
		}

		$i++;
	}

	$box_top    .= "┐\n";
	$box_middle .= "┤\n";
	$box_bottom .= "┘\n";

	$header .= "│\n";


	print $box_top;
	print $header;
	print $box_middle;

	my @code2name_rows = ();

	foreach my $code (sort { $a <=> $b } keys %{$provincie_map{code2name}}) {
		my $name = $provincie_map{code2name}{$code};

		my $row = '';

		$row .= "│";
		$row .= sprintf(" %$longest{code}s ", $code);
		$row .= "│";
		$row .= sprintf(" %-$longest{name}s ", $name);
		$row .= "│";

		push @code2name_rows, $row;
	}

	my @name2code_rows = ();

	foreach my $name (sort { $a cmp $b } keys %{$provincie_map{name2code}}) {
		my $code = $provincie_map{name2code}{$name};

		my $row = '';

		$row .= "│";
		$row .= sprintf(" %-$longest{name}s ", $name);
		$row .= "│";
		$row .= sprintf(" %-$longest{code}s ", $code);
		$row .= "│";

		push @name2code_rows, $row;
	}

	$i = 0;
	foreach(@code2name_rows) {
		print $code2name_rows[$i];
		print " ";
		print $name2code_rows[$i];
		print "\n";

		print $box_middle if($i < $#code2name_rows);

		$i++;
	}

	print $box_bottom;
}

