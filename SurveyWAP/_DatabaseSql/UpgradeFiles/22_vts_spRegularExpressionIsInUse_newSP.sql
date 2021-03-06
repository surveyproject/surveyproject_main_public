USE [sp25dev]
GO
/****** Object:  StoredProcedure [dbo].[vts_spRegularExpressionIsInUse]    Script Date: 10/12/2018 10:41:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Survey Project: (c) 2018, W3DevPro TM (http://www.w3devpro.com)

	NSurvey - The web survey and form engine
	Copyright (c) 2004, 2005 Thomas Zumbrunn. (http://www.nsurvey.org)

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

/// <summary>
/// Check if the Regular Expression is in use
/// by an answer
/// </summary>
*/
ALTER PROCEDURE [dbo].[vts_spRegularExpressionIsInUse] @RegularExpressionID int AS
SELECT
(
SELECT TOP 1 AnswerID FROM vts_tbAnswer WHERE RegularExpressionId = @RegularExpressionID
) AnswerID



