﻿###############################################################################
#
# Tests for Excel::Writer::XLSX::Drawing methods.
#
# reverse('©'), May 2012, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions qw(_expected_to_aref _got_to_aref _is_deep_diff _new_object);
use strict;
use warnings;
use Excel::Writer::XLSX::Shape;
use Excel::Writer::XLSX::Drawing;

use Test::More tests => 1;

###############################################################################
#
# Tests setup.
#
my $expected;
my $caption;
my ($wbk, $shp, $got);
my $w1 = _new_object( \$wbk, 'Excel::Writer::XLSX::Worksheet' );

my $shape = _new_object( \$shp, 'Excel::Writer::XLSX::Shape' );
$shape->{id} = 1000;
$shape->{text} = 'test';

# Override subroutine to avoid errors in method call
sub Excel::Writer::XLSX::Worksheet::_get_palette_color {

    my $self    = shift;
    my $index   = shift;
    my $palette = $self->{_palette};

    # Handle colours in #XXXXXX RGB format.
    if ( $index =~ m/^#([0-9A-F]{6})$/i ) {
        return "FF" . uc( $1 );
    }
}

my $drawing = _new_object( \$got, 'Excel::Writer::XLSX::Drawing' );
$drawing->{_palette} = $w1->{_palette};
$drawing->{_embedded} = 1;

###############################################################################
#
# Test the _assemble_xml_file() method for shape text
#
$caption = " \tDrawing: _assemble_xml_file() shape text";

$drawing->_add_drawing_object( 3, 4, 8, 209550, 95250, 12, 22, 209660, 96260, 10000, 20000, 95250, 190500, 'rect 1', $shape );

$drawing->_assemble_xml_file();

$expected = _expected_to_aref();
$got      = _got_to_aref( $got );

_is_deep_diff( $got, $expected, $caption );

__DATA__
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xdr:wsDr xmlns:xdr="http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
    <xdr:twoCellAnchor>
        <xdr:from>
            <xdr:col>4</xdr:col>
            <xdr:colOff>209550</xdr:colOff>
            <xdr:row>8</xdr:row>
            <xdr:rowOff>95250</xdr:rowOff>
        </xdr:from>
        <xdr:to>
            <xdr:col>12</xdr:col>
            <xdr:colOff>209660</xdr:colOff>
            <xdr:row>22</xdr:row>
            <xdr:rowOff>96260</xdr:rowOff>
        </xdr:to>
        <xdr:sp macro="" textlink="">
            <xdr:nvSpPr>
                <xdr:cNvPr id="1000" name="rect 1"/>
                <xdr:cNvSpPr>
                    <a:spLocks noChangeArrowheads="1"/>
                </xdr:cNvSpPr>
            </xdr:nvSpPr>
            <xdr:spPr bwMode="auto">
                <a:xfrm>
                    <a:off x="10000" y="20000"/>
                    <a:ext cx="95250" cy="190500"/>
                </a:xfrm>
                <a:prstGeom prst="rect">
                    <a:avLst/>
                </a:prstGeom>
                <a:noFill/>
                <a:ln w="9525">
                    <a:solidFill>
                        <a:srgbClr val="000000"/>
                    </a:solidFill>
                    <a:miter lim="800000"/>
                    <a:headEnd/>
                    <a:tailEnd/>
                </a:ln>
            </xdr:spPr>
            <xdr:txBody>
                <a:bodyPr vertOverflow="clip" wrap="square" lIns="27432" tIns="22860" rIns="27432" bIns="22860" anchor="ctr" upright="1"/>
                <a:lstStyle/>
                <a:p>
                    <a:pPr algn="ctr" rtl="0">
                        <a:defRPr sz="1000"/>
                    </a:pPr>
                    <a:r>
                        <a:rPr lang="en-US" sz="800" b="0" i="0" u="none" strike="noStrike" baseline="0">
                            <a:solidFill>
                                <a:srgbClr val=""/>
                            </a:solidFill>
                            <a:latin typeface="Arial"/>
                            <a:cs typeface="Arial"/>
                        </a:rPr>
                        <a:t>test</a:t>
                    </a:r>
                </a:p>
            </xdr:txBody>
        </xdr:sp>
        <xdr:clientData/>
    </xdr:twoCellAnchor>
</xdr:wsDr>