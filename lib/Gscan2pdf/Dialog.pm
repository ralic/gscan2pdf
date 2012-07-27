package Gscan2pdf::Dialog;

use warnings;
use strict;
use Gtk2;
use Carp;
use Glib 1.220 qw(TRUE FALSE);    # To get TRUE and FALSE
use Gtk2::Gdk::Keysyms;

use Glib::Object::Subclass Gtk2::Window::,
  signals => {
 delete_event    => \&on_delete_event,
 key_press_event => \&on_key_press_event,
  },
  properties => [
 Glib::ParamSpec->uint(
  'border-width',                 # name
  'Border width',                 # nickname
  'Border width for vbox',        # blurb
  0,                              # min
  999,                            # max
  0,                              # default
  [qw/readable writable/]         # flags
 ),
 Glib::ParamSpec->boolean(
  'hide-on-delete',                                                # name
  'Hide on delete',                                                # nickname
  'Whether to destroy or hide the dialog when it is dismissed',    # blurb
  FALSE,                                                           # default
  [qw/readable writable/]                                          # flags
 ),
 Glib::ParamSpec->object(
  'vbox',                                                          # name
  'VBox',                                                          # nickname
  'VBox which is automatically added to the Gscan2pdf::Dialog',    # blurb
  'Gtk2::VBox',                                                    # package
  [qw/readable writable/]                                          # flags
 ),
  ];

sub INIT_INSTANCE {
 my $self = shift;

 $self->set_position('center-on-parent');

 # VBox for window
 my $vbox = Gtk2::VBox->new;
 $self->add($vbox);
 $self->set( 'vbox', $vbox );
 return $self;
}

sub SET_PROPERTY {
 my ( $self, $pspec, $newval ) = @_;
 my $name = $pspec->get_name;
 $self->{$name} = $newval;
 $self->get('vbox')->set( 'border-width', $newval )
   if ( $name eq 'border_width' );
 return;
}

sub on_delete_event {
 my ( $widget, $event ) = @_;
 if ( $widget->get('hide-on-delete') ) {
  $widget->hide;
  return Gtk2::EVENT_STOP;    # ensures that the window is not destroyed
 }
 $widget->destroy;
 return Gtk2::EVENT_PROPAGATE;
}

sub on_key_press_event {
 my ( $widget, $event ) = @_;
 unless ( $event->keyval == $Gtk2::Gdk::Keysyms{Escape} ) {
  $widget->signal_chain_from_overridden($event);
  return Gtk2::EVENT_PROPAGATE;
 }
 if ( $widget->get('hide-on-delete') ) {
  $widget->hide;
 }
 else {
  $widget->destroy;
 }
 return Gtk2::EVENT_STOP;
}

1;

__END__