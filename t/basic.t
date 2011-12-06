use strict;
use warnings;
use Test::More;
use lib 't/lib';
use_ok('Roose');

use RooseT; # Connects to riak db (similar to t/lib/MongooseT.pm in Mongoose)
done_testing();
