USE [sp25dev]
GO
/****** Object:  StoredProcedure [dbo].[vts_spVoterForExport]    Script Date: 3/25/2020 10:36:46 ******/
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
*/
ALTER PROCEDURE [dbo].[vts_spVoterForExport] 
					@SurveyID int,
					@StartDate datetime,
					@EndDate datetime 

AS

-- Voter data:
	SELECT 
		vts_tbVoter.VoterID,
		SurveyID,
		VoteDate,
		IPSource,
		StartDate,
		Email,
		ContextUserName,
		LanguageCode
	FROM vts_tbVoter
	LEFT JOIN vts_tbVoterEmail 
		ON vts_tbVoter.VoterID = vts_tbVoterEmail.VoterID
	LEFT JOIN vts_tbEmail
		ON vts_tbEmail.EmailID = vts_tbVoterEmail.EmailId
	WHERE 
		vts_tbVoter.SurveyID = @SurveyID AND
		DATEDIFF (d,@startDate,vts_tbVoter.VoteDate) >= 0 AND DATEDIFF (d,@endDate,vts_tbVoter.VoteDate) <= 0

-- QuestionData:
	SELECT DISTINCT va.VoterID, QuestionText, q.QuestionID,
	                q.QuestionIdText,q.Alias QuestionAlias
	FROM vts_tbVoterAnswers va	
	INNER JOIN vts_tbAnswer a
		ON a.AnswerID = va.AnswerID 
	INNER JOIN vts_tbQuestion q
		ON q.questionID = a.questionID
	INNER JOIN vts_tbVoter v
		ON v.VoterID = va.VoterID
	WHERE 
		v.SurveyID = @SurveyID AND
		DATEDIFF (d,@startDate,V.VoteDate) >= 0 AND DATEDIFF (d,@endDate,V.VoteDate) <= 0


-- Answer data:	
	SELECT va.VoterID, va.SectionNumber, va.AnswerID, ISNULL(va.AnswerText, '-' ) as VoterAnswer, 
	q.QuestionID, q.DisplayOrder as QuestionDisplayOrder,
	a.AnswerText as Answer,a.DisplayOrder as AnswerDisplayOrder,
	A.AnswerAlias
	FROM vts_tbVoterAnswers va	
	INNER JOIN vts_tbAnswer a
		ON a.AnswerID = va.AnswerID 
	INNER JOIN vts_tbQuestion q
		ON q.questionID = a.QuestionID
	INNER JOIN vts_tbVoter v
		ON v.VoterID = va.VoterID
	WHERE 
		v.SurveyID = @SurveyID AND
		DATEDIFF (d,@startDate,V.VoteDate) >= 0 AND DATEDIFF (d,@endDate,V.VoteDate) <= 0



