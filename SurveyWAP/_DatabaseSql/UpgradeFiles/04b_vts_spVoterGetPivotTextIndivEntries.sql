USE [dbname]
GO
/****** Object:  StoredProcedure [dbo].[vts_spVoterGetPivotTextIndivEntries]    Script Date: 8/6/2017 21:32:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/// Pivots the voter  entries into a column / row format
/// </summary>
/// <param name="@SurveyID">
/// ID of the survey to pivot answers
/// </param>
/// <param name="@UserID">
/// ID of the user to to get sp contextusername from votertable
/// </param>
/// <param name="@CurrentPage">
/// Current page number
/// </param>
/// <param name="@PageSize">
/// Page size
/// </param>
/// <return>
/// returns the paged pivoted resultset
/// </return>
*/
CREATE PROCEDURE [dbo].[vts_spVoterGetPivotTextIndivEntries] 
				@SurveyID int,
				@UserID int,
				@CurrentPage int = 1,
				@PageSize int=10,
				@StartDate datetime,
				@EndDate datetime
AS
DECLARE @TotalRecords int
CREATE TABLE #VoterEntriesIndiv (VoterID int NOT NULL, [Date] dateTime, StartDate datetime, IP varchar(50), Score int)
-- Get voter range
INSERT INTO #VoterEntriesIndiv (VoterID, [Date], StartDate, IP, Score)  
	EXEC vts_spVoterGetPagedIndiv @SurveyID, @UserID, @CurrentPage, @PageSize, @StartDate, @EndDate, @TotalRecords output
-- Start pivot
DECLARE @AnswerText nvarchar(4000)
DECLARE @AnswerID varchar(16)
DECLARE @VoterID varchar(16)
DECLARE @BuildColumnSQL varchar(4000)
DECLARE @UpdateVotersRowSQL varchar(4000)
-- Get the fields to generate the column
DECLARE AnswerColumnCursor  CURSOR FOR
	SELECT AnswerText, AnswerID FROM vts_tbAnswer
	INNER JOIN vts_tbQuestion 
		ON vts_tbQuestion.QuestionID = vts_tbAnswer.QuestionID
	INNER JOIN vts_tbAnswerType
		ON vts_tbAnswerType.AnswerTypeID = vts_tbAnswer.AnswerTypeID 
	WHERE SurveyID = @SurveyID AND (TypeMode & 2 = 2 OR TypeMode & 8 =8 OR TypeMode & 4 =4)
	ORDER BY vts_tbQuestion.DisplayOrder, vts_tbQuestion.QuestionID, vts_tbAnswer.DisplayOrder
OPEN AnswerColumnCursor
FETCH AnswerColumnCursor INTO @AnswerText, @AnswerID
WHILE @@FETCH_STATUS = 0
BEGIN
	-- creates the new column
	SET @BuildColumnSQL = N'ALTER TABLE #VoterEntriesIndiv ADD ['+@AnswerText+'_'+@AnswerID+'] NVARCHAR(4000)'
	EXEC (@BuildColumnSQL)
	-- Assign voters entry to the column
	SET @UpdateVotersRowSQL =N'UPDATE #VoterEntriesIndiv SET ['+@AnswerText+'_'+@AnswerID+'] = (SELECT SUBSTRING(AnswerText,1, 40)  as AnswerText FROM vts_tbVoterAnswers  WHERE AnswerID='+@AnswerID+' AND SectionNumber=0 AND vts_tbVoterAnswers.VoterID=Voters.VoterID) FROM (SELECT VoterID FROM #VoterEntriesIndiv WITH (nolock)) as Voters WHERE #VoterEntriesIndiv.VoterID=Voters.VoterID'
	EXEC (@UpdateVotersRowSQL)
	FETCH AnswerColumnCursor INTO @AnswerText, @AnswerID
END
CLOSE AnswerColumnCursor
DEALLOCATE AnswerColumnCursor
SELECT *, TotalRecords =@TotalRecords FROM #VoterEntriesIndiv
DROP TABLE #VoterEntriesIndiv
