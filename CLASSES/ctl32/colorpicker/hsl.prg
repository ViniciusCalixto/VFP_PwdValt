*!* Hsl.prg

Lparameters pnH, pnS, pnL

Local lnH, lnS, lnL, lnTemp1, lnTemp2, lnTemp3

m.lnH = Mod(m.pnH, 360) / 360
m.lnS = Min(Max(m.pnS, 0), 100) / 100
m.lnL = Min(Max(m.pnL, 0), 100) / 100

If  m.lnS  = 0
	m.pnR 	= Round(m.lnL * 255, 0)
	m.pnG 	= Round(m.lnL * 255, 0)
	m.pnB 	= Round(m.lnL * 255, 0)

Else

	If m.lnL < 0.5 Then
		m.lnTemp2 = m.lnL * (1 + m.lnS)
	Else
		m.lnTemp2 = (m.lnL + m.lnS) - (m.lnS * m.lnL)
	Endif

	m.lnTemp1 = 2 * m.lnL - m.lnTemp2

	*!* Red
	m.lnTemp3 = m.lnH + 1/3

	If m.lnTemp3 < 0 Then
		m.lnTemp3 = m.lnTemp3 + 1
	Endif

	If m.lnTemp3 > 1 Then
		m.lnTemp3 = m.lnTemp3 - 1
	Endif

	Do Case

		Case 6 * m.lnTemp3 < 1
			m.pnR = m.lnTemp1 + (m.lnTemp2 - m.lnTemp1) * 6 * m.lnTemp3
		Case 2 * m.lnTemp3 < 1
			m.pnR = m.lnTemp2
		Case 3 * m.lnTemp3 < 2
			m.pnR = m.lnTemp1 + (m.lnTemp2 - m.lnTemp1) * ((2/3) - m.lnTemp3) * 6
		Otherwise
			m.pnR = m.lnTemp1
	Endcase

	*!* Green
	m.lnTemp3 = m.lnH

	If m.lnTemp3 < 0 Then
		m.lnTemp3 = m.lnTemp3 + 1
	Endif

	If m.lnTemp3 > 1 Then
		m.lnTemp3 = m.lnTemp3 - 1
	Endif

	Do Case

		Case 6 * m.lnTemp3 < 1
			m.pnG = m.lnTemp1 + (m.lnTemp2 - m.lnTemp1) * 6 * m.lnTemp3
		Case 2 * m.lnTemp3 < 1
			m.pnG = m.lnTemp2
		Case 3 * m.lnTemp3 < 2
			m.pnG = m.lnTemp1 + (m.lnTemp2 - m.lnTemp1) * ((2/3) - m.lnTemp3) * 6
		Otherwise
			m.pnG = m.lnTemp1
	Endcase

	*!* Blue
	m.lnTemp3 = m.lnH - 1/3

	If m.lnTemp3 < 0 Then
		m.lnTemp3 = m.lnTemp3 + 1
	Endif

	If m.lnTemp3 > 1 Then
		m.lnTemp3 = m.lnTemp3 - 1
	Endif

	Do Case

		Case 6 * m.lnTemp3 < 1
			m.pnB = m.lnTemp1 + (m.lnTemp2 - m.lnTemp1) * 6 * m.lnTemp3
		Case 2 * m.lnTemp3 < 1
			m.pnB = m.lnTemp2
		Case 3 * m.lnTemp3 < 2
			m.pnB = m.lnTemp1 + (m.lnTemp2 - m.lnTemp1) * ((2/3) - m.lnTemp3) * 6
		Otherwise
			m.pnB = m.lnTemp1
	Endcase

	m.pnR 	= Round(255 * m.pnR, 0)
	m.pnG 	= Round(255 * m.pnG, 0)
	m.pnB 	= Round(255 * m.pnB, 0)

Endif

Return Rgb(m.pnR, m.pnG, m.pnB)
