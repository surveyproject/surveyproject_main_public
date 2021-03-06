USE [DBname]
GO
/****** Object:  StoredProcedure [dbo].[vts_spUserGetUserIdFromUserName]    Script Date: 7/31/2017 12:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
	Survey Project: (c) 2016, Fryslan Webservices TM (http://survey.codeplex.com)

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
/// Returns the user id of the username
/// </summary>
*/
ALTER PROCEDURE [dbo].[vts_spUserGetUserIdFromUserName]
			@UserName nvarchar(255)
			
AS

/* SELECT UserID FROM vts_tbUser WHERE UserName = @UserName */


select
Case 
when count(*) > 0
then

(SELECT UserID FROM vts_tbUser WHERE UserName = @UserName)

else -2
end as UserID
from vts_tbUser 
