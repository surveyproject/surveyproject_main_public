USE [dbname]
GO
/****** Object:  StoredProcedure [dbo].[vts_spSurveyClone]    Script Date: 1/24/2018 14:33:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
*/
ALTER PROCEDURE [dbo].[vts_spSurveyClone] @SurveyID int 
AS
BEGIN TRANSACTION CloneSurvey
DECLARE @ClonedSurveyID int
-- Clone the survey
INSERT INTO vts_tbSurvey 
	(CreationDate, 
	OpenDate,
	CloseDate,
	Title,
	RedirectionURL,
	ThankYouMessage,
	AccessPassword,
	SurveyDisplayTimes,
	ResultsDisplayTimes,
	Archive,
	Activated,
	IPExpires,
	CookieExpires,
	OnlyInvited,
	UnAuthentifiedUserActionID,	
	NavigationEnabled,
	ProgressDisplayModeID,
	NotificationModeID,
	ResumeModeID,
	Scored,
	AllowMultipleUserNameSubmissions,
	QuestionNumberingDisabled,
	AllowMultipleNSurveySubmissions,
	MultiLanguageModeID,
	MultiLanguageVariable,
	FolderID)
SELECT      
	getdate(), 
	OpenDate,
	CloseDate,
	Title + ' - cloned',
	RedirectionURL,
	ThankYouMessage,
	AccessPassword,
	0,
	0,
	Archive,
	0,
	IPExpires,
	CookieExpires,
	OnlyInvited,
	UnAuthentifiedUserActionID,
	NavigationEnabled,
	ProgressDisplayModeID,
	NotificationModeID,
	ResumeModeID,
	Scored,
	AllowMultipleUserNameSubmissions,
	QuestionNumberingDisabled,
	AllowMultipleNSurveySubmissions,
	MultiLanguageModeID,
	MultiLanguageVariable,
    FolderID
FROM vts_tbSurvey WHERE SurveyID = @SurveyID
-- Check if the cloned survey was created
IF @@RowCount <> 0
BEGIN
	-- Clone the survey's questions
	set @ClonedSurveyID = SCOPE_IDENTITY()
	INSERT INTO vts_tbEmailNotificationSettings(SurveyID, EmailFrom, EmailTo, EmailSubject) 
		SELECT @ClonedSurveyID as SurveyID,EmailFrom, Emailto, EmailSubject 
		FROM vts_tbEmailNotificationSettings 
		WHERE SurveyID = @SurveyID
	
	INSERT INTO vts_tbSurveyWebSecurity(WebSecurityAddInID, SurveyID, AddInOrder, Disabled)
		SELECT WebSecurityAddInID, @ClonedSurveyID as SurveyID, AddInOrder, Disabled
		FROM vts_tbSurveyWebSecurity
		WHERE SurveyID = @SurveyID
	
	INSERT INTO vts_tbPageOption (SurveyID, PageNumber, RandomizeQuestions, EnableSubmitButton)
		SELECT @ClonedSurveyID as SurveyID, PageNumber, RandomizeQuestions, EnableSubmitButton
		FROM vts_tbPageOption
		WHERE SurveyID = @SurveyID
	
	INSERT INTO vts_tbSurveyLanguage(SurveyID, LanguageCode, DefaultLanguage)
		SELECT @ClonedSurveyID as SurveyID, LanguageCode, DefaultLanguage
		FROM vts_tbSurveyLanguage
		WHERE SurveyID = @SurveyID

	-- Clone multi languages messages
	INSERT INTO vts_tbMultiLanguageText(LanguageItemID, LanguageCode, LanguageMessageTypeID, ItemText)
		SELECT @ClonedSurveyID as LanguageItemID, LanguageCode, LanguageMessageTypeID, ItemText
		FROM vts_tbMultiLanguageText
		WHERE LanguageItemID = @SurveyID AND LanguageMessageTypeID = 4

	INSERT INTO vts_tbMultiLanguageText(LanguageItemID, LanguageCode, LanguageMessageTypeID, ItemText)
		SELECT @ClonedSurveyID as LanguageItemID, LanguageCode, LanguageMessageTypeID, ItemText
		FROM vts_tbMultiLanguageText
		WHERE LanguageItemID = @SurveyID AND LanguageMessageTypeID = 5

	exec vts_spQuestionCopyToSurvey @SurveyID, @ClonedSurveyID
	exec vts_spSurveyBranchingRuleCopyToSurvey @SurveyID, @ClonedSurveyID
	exec vts_spSurveySkipLogicRuleCopyToSurvey @SurveyID, @ClonedSurveyID
END
COMMIT TRANSACTION CloneQuestion
exec vts_spSurveyGetDetails @ClonedSurveyID, null



