#!/usr/bin/env perl

use Test::Most tests => 1;

use strict;
use warnings;

use Renard::Incunabula::Frontend::Gtk3::GooCanvas2;

subtest "Child properties" => sub {
	subtest "CanvasTableItem" => sub {
		my $table_item = GooCanvas2::CanvasTable->new;
		my @properties = $table_item->list_child_properties;
		my @properties_names = map { $_->get_name } @properties;

		cmp_deeply \@properties_names, supersetof(qw(row column)),
			'contains the expected properities';

		my $child_item = GooCanvas2::CanvasRect->new;
		$table_item->add_child( $child_item, -1 );

		is $table_item->get_child_property($child_item, 'row'), 0, 'child item row property initial value';

		note 'setting number of rows to 20';
		$table_item->set_child_property($child_item, 'row', 3);

		is $table_item->get_child_property($child_item, 'row'), 3,
			'has expected number of rows after setting';
	};

	subtest "CanvasTableModel" => sub {
		my $table_model = GooCanvas2::CanvasTableModel->new;
		my @properties = $table_model->list_child_properties;
		my @properties_names = map { $_->get_name } @properties;

		cmp_deeply \@properties_names, supersetof(qw(row column)),
			'contains the expected properities';

		my $child_model = GooCanvas2::CanvasRectModel->new;
		$table_model->add_child( $child_model, -1 );

		is $table_model->get_child_property($child_model, 'row'), 0, 'child model row property initial value';

		note 'setting number of rows to 20';
		$table_model->set_child_property($child_model, 'row', 3);

		is $table_model->get_child_property($child_model, 'row'), 3,
			'has expected number of rows after setting';
	};
};

done_testing;
