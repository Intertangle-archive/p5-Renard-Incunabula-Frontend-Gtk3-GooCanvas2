use Modern::Perl;
package Renard::Incunabula::Frontend::Gtk3::GooCanvas2;
# ABSTRACT: Helper code for using GooCanvas via Glib::Object::Introspection

use Renard::Incunabula::Frontend::Gtk3;
use Glib::Object::Introspection;

sub import {
	Glib::Object::Introspection->setup(
		basename => 'GooCanvas',
		version => '2.0',
		package => 'GooCanvas2', );
}

1;
