USE [dbname]
GO
/****** Object:  StoredProcedure [dbo].[vts_spFileValidatedGetAll]    Script Date: 9/30/2018 17:43:00 ******/
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
///  Get validated files
/// </summary>
*/
ALTER PROCEDURE [dbo].[vts_spFileValidatedGetAll]
				@SurveyID int,
				@CurrentPage int = 1,
				@PageSize int=10,
				@TotalRecords int OUTPUT
AS
-- Turn off count return.
Set NoCount On
-- Declare variables.
DECLARE @FirstRec int
DECLARE @LastRec int
-- Initialize variables.
SET @FirstRec = (@CurrentPage - 1) * @PageSize
SET @LastRec = (@CurrentPage * @PageSize + 1)

-- Create a temp table to hold the current page of data
-- Add an ID column to count the records
CREATE TABLE #TempTable (RowId int IDENTITY PRIMARY KEY, FileId int NOT NULL, VoterId int, GroupGuid varchar(40), FileName nvarchar(1024), FileType varchar(1024), FileSize int, SaveDate DateTime)

--Fill the temp table with the reminders
INSERT INTO #TempTable (FileId, VoterId, GroupGuid, FileName, FileType, FileSize, SaveDate)
	SELECT FileId, vts_tbVoter.VoterId, GroupGuid, FileName, FileType, FileSize, SaveDate
	FROM vts_tbFile
	INNER JOIN vts_tbVoterAnswers ON 
		AnswerText like GroupGuid
	INNER JOIN vts_tbVoter ON
		vts_tbVoter.VoterID = vts_tbVoterAnswers.VoterID
	WHERE vts_tbVoter.SurveyID = @SurveyID AND vts_tbVoter.Validated<>0
	ORDER BY SaveDate DESC

SELECT @TotalRecords = count(*) FROM vts_tbFile
INNER JOIN vts_tbVoterAnswers ON 
	AnswerText like GroupGuid
INNER JOIN vts_tbVoter ON
	vts_tbVoter.VoterID = vts_tbVoterAnswers.VoterID
WHERE vts_tbVoter.SurveyID = @SurveyID AND vts_tbVoter.Validated<>0

If (@CurrentPage = -1 and @PageSize = -1)
(SELECT FileId, VoterId, GroupGuid, FileName, FileType, FileSize, SaveDate
FROM #TempTable)
else 
(SELECT FileId, VoterId, GroupGuid, FileName, FileType, FileSize, SaveDate
FROM #TempTable
WHERE 
	RowId > @FirstRec AND
	RowId < @LastRec
	)


DROP TABLE #TempTable



