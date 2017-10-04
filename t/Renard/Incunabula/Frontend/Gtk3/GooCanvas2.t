#!/usr/bin/env perl

use Test::Most tests => 2;

use strict;
use warnings;

use Renard::Incunabula::Frontend::Gtk3::GooCanvas2;
use Gtk3 qw(-init);
use Glib qw(TRUE FALSE);

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

subtest "Get items" => sub {
	my $canvas = GooCanvas2::Canvas->new;

	my $colors = [
		{ color => 'red', rgba => 'rgb(255,0,0)' },
		{ color => 'blue', rgba => 'rgb(0,0,255)' },
	];

	my $rect0 = GooCanvas2::CanvasRect->new(
		'fill-color' => $colors->[0]{color},
		x => 10, y => 10,
		width => 10, height => 10 );

	my $rect1 = GooCanvas2::CanvasRect->new(
		'fill-color' => $colors->[1]{color},
		x => 30, y => 30,
		width => 10, height => 10 );

	my $group = GooCanvas2::CanvasGroup->new;

	$group->add_child( $rect0, -1 );
	$group->add_child( $rect1, -1 );

	$canvas->set_root_item( $group );

	my $get_fill = sub {
		shift->get_property('fill-color-gdk-rgba')->to_string;
	};

	subtest "Find first rect" => sub {
		my @items = $canvas->get_items_in_area(
			GooCanvas2::CanvasBounds->new(
				x1 => 0, y1 => 0, x2 => 25, y2 => 25,
			),
			TRUE, TRUE, FALSE
		);
		is scalar @items, 1, 'only one rect';
		is $items[0]->$get_fill, $colors->[0]{rgba}, 'correct fill-color';
	};

	subtest "Find second rect" => sub {
		my @items = $canvas->get_items_in_area(
			GooCanvas2::CanvasBounds->new(
				x1 => 25, y1 => 25, x2 => 45, y2 => 45,
			),
			TRUE, TRUE, FALSE
		);
		is scalar @items, 1, 'only one rect';
		is $items[0]->$get_fill, $colors->[1]{rgba}, 'correct fill-color';
	};

	subtest "Find both rects" => sub {
		my @items = $canvas->get_items_in_area(
			GooCanvas2::CanvasBounds->new(
				x1 => 0, y1 => 0, x2 => 45, y2 => 45,
			),
			TRUE, TRUE, FALSE
		);
		is scalar @items, 2, 'both rects';
		my @fill_colors = map { $_->$get_fill } @items;
		cmp_deeply \@fill_colors,
			set(map { $_->{rgba} } @$colors),
			'correct fill-colors';
	};
};

done_testing;
