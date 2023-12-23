Lparameters pnRgb As Integer

Local loForm, lnRgb

If Pcount() = 0 Then
	Do Form colorpicker
Else
	m.pnRgb = Max(Min(m.pnRgb, 16777215), -16777215)
	Do Form colorpicker_modal With m.pnRgb To m.lnRgb
	Return m.lnRgb
Endif

