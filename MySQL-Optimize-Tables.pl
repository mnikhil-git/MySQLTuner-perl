#!/usr/bin/perl -w
# optimize_tables.pl - Version 1.0
# Optimize fragmented tables in MySQL Databases
# 
# Original idea from:
#       http://github.com/rackerhacker/MySQLTuner-perl
#       https://github.com/rackerhacker/MySQLTuner-perl/issues/8
#
# Scop's sql statements gave the idea of how to get the list
#  of fragmented tables in a MySQL database.
# For the latest updates, 
# Git repository available at https://github.com/mnikhil-git/MySQLTuner-perl
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
#
# Nikhil Mulley
# mnikhil#gmail.com
# https://github.com/mnikhil-git/MySQLTuner-perl/optimize-tables.pl
#
# Script's dependencies
#   uses Net::MySQL -- pure perl implementation of client interface to mysqld
#
use strict;
use warnings;
use diagnostics;
use Getopt::Long;
use Net::MySQL;
use Data::Dumper;

my $script_version = '1.0';

# set defaults
my %opt = (
            "host"    => 0,
            "socket"    => 0,
            "port"    => 0,
            "user"    => 0,
            "pass"    => 0,
            "list"    => 0,
            "fix"    => 0,
          );

my $fix_tables = 0;
my @mysql_dbs = ();

# Get options from command line
GetOptions(\%opt,
               'host=s',
               'socket=s',
               'port=i',
               'user=s',
               'pass=s',
               'dblist=s@',
               'db-all',
               'list',
               'fix',
               'help',
          );

if (defined $opt{'help'} && $opt{'help'} == 1) { usage(); }

sub usage {
  # usage of the command line with --help option
  print " ".
        "MySQL-Optimize-Tables - perl script version $script_version\n".
        "Usage:\n".
        "  --host <hostname> Connect to MySQL server and perform checks\n".
        "  --socket <socket> Use a socket connection \n".
        "  --port <port> Use a different port for connection. (Default port: 3306) \n".
        "  --user <username> Username to use for authentication \n".
        "  --pass <password> Password to use for authentication \n".
        "  --list List the fragmented tables. Default option for all databases\n".
        "  --fix  Fix the fragmented tables. Run Optimize table for the listed tables\n".
        "  --dblist  Comma seperated list of databases to check the list of their fragmented tables\n".
        "  --db-all  All databases to check. Default. \n".
        "  --output-file  Store output onto the file. \n".
        "\n";
        exit;
}


sub initialize_variables {

  my $mysql_default_user = 'root';
  my $mysql_default_port = 3306;
  my $mysql_default_db_login = 'information_schema';
  my $mysql_use_port = 0;

  # if hostname is not specified use socket connection
  if (defined $opt{'host'} && $opt{'host'} ne 0) {
    chomp($opt{'host'});
    $opt{'port'} = (defined($opt{'port'})) ? $mysql_default_port : $opt{'port'};
    $mysql_use_port = 1;
  } 
  elsif (defined($opt{'socket'} && $opt{'socket'} ne 0)) {
    chomp($opt{'socket'});
    $mysql_use_port = 0; 
  }

  if (defined $opt{'user'} && $opt{'user'} ne 0) {
    chomp($opt{'user'});
    $opt{'user'} = (defined($opt{'user'})) ? $mysql_default_port : $opt{'user'};
  } 

  # default operation is to list the fragmented tables
  if (defined $opt{'list'} && $opt{'list'} != 1) { usage(); }
  $opt{'list'} = 1;

  # default store the output/list into log file.
  if (defined $opt{'output-file'} && $opt{'output-file'} ne 0) {
    chomp($opt{'output-file'});
  } else {
    $opt{'output-file'} = 'MySQL-Optimize-Tables.log';
  }
  
  if (defined $opt{'fix'} && $opt{'fix'} == 1) { $fix_tables = 1; }

  if (defined $opt{'dblist'} && $opt{'dblist'} ne 0) {
    @mysql_dbs = split(/,/, join(',', @{$opt{'dblist'}}));
  }
}

# -----------------------------------------------------------------------------
# BEGIN 'MAIN'
# -----------------------------------------------------------------------------
print "\n >> MySQL-Optimize-Tables  - Nikhil Mulley <mnikhil\@gmail.com>\n";
print "\n >>   Run with --help for additional options\n";

#initialize_variables;
#mysql_setup;
#check_fragmented_tables;

