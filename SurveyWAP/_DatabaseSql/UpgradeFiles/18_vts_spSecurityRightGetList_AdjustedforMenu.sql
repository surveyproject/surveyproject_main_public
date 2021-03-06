USE [dbname]
GO
/****** Object:  StoredProcedure [dbo].[vts_spSecurityRightGetList]    Script Date: 2/16/2018 10:37:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
	Survey Project: (c) 2017, W3DevPro TM (https://github.com/surveyproject)

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
/// Get a list of all security rights
/// </summary>
*/
ALTER PROCEDURE [dbo].[vts_spSecurityRightGetList]
AS

-- SELECT SecurityRightID, Description FROM vts_tbSecurityRight


select
sr.SecurityRightID,

cast(

cast(m.Code as nchar(4)) + '&nbsp;&nbsp;' +
m.main +  '/ ' +
isnull(m.subone, ' - ') + '/ ' +
isnull(m.subtwo, ' - ') + '/ ' +
isnull(m.subthree, ' - / ') 

as nchar(100)) +

cast(sr.description as nchar(35)) as [description]
-- len(sr.description) length

from vts_tbsecurityright sr left join 
dbo.vts_tbmenusecurityright msr on sr.SecurityRightID = msr.securityrightID
left join vts_tbmenu m on msr.menuID = m.MenuID
where msr.securityrightID is not null
order by m.code



