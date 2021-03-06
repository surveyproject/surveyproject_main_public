USE [DBname]
GO
/****** Object:  StoredProcedure [dbo].[vts_spQuestionAddNew]    Script Date: 8/19/2017 13:04:01 ******/
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
/// Adds a new question to a survey
/// </summary>
*/
ALTER PROCEDURE [dbo].[vts_spQuestionAddNew]
			@SurveyID int,
			@LibraryID int, 
			@QuestionText nvarchar(max),
			@SelectionModeId int,
			@LayoutModeId int,
			@DisplayOrder int, 
			@PageNumber int,
			@ColumnsNumber int,
			@MinSelectionRequired int,
			@MaxSelectionAllowed int,
			@RandomizeAnswers bit,
			@RatingEnabled bit,
			@QuestionPipeAlias nvarchar(255),
			@QuestionIDText nvarchar(255),
			@Alias nvarchar(255)='',
			@HelpText nvarchar(4000)='',
			@ShowHelpText bit =0,
			@QuestionGroupId int=null,
			@QuestionID int OUTPUT
AS

BEGIN TRAN InsertQuestion

DECLARE @UpdateDisplayOrder bit 

-- Check if there is already a question with the same display order
if @SurveyID is not null AND Exists(SELECT DisplayOrder FROM vts_tbQuestion WHERE ParentQuestionID is null AND DisplayOrder = @DisplayOrder AND SurveyID = @SurveyID)
BEGIN
	set @UpdateDisplayOrder = 1
END 
ELSE
BEGIN
	set @UpdateDisplayOrder = 0	
END

INSERT INTO vts_tbQuestion
	(SurveyID,
	LibraryID,
	SelectionModeId,
	LayoutModeId,
	DisplayOrder,
	PageNumber,
	QuestionText,
	ColumnsNumber,
	MinSelectionRequired,
	MaxSelectionAllowed,
	RandomizeAnswers,
	RatingEnabled,
	QuestionPipeAlias,
	QuestionIdText,
	Alias,
	HelpText,
	ShowHelpText,
	QuestionGroupID
	)
VALUES
	(@SurveyID,
	@LibraryID, 
	@SelectionModeId,
	@LayoutModeId,
	@DisplayOrder,
	@PageNumber,
	@QuestionText,
	@ColumnsNumber,
	@MinSelectionRequired,
	@MaxSelectionAllowed,
	@RandomizeAnswers,
	@RatingEnabled,
	@QuestionPipeAlias,
	@QuestionIDText,
	@Alias,
	@HelpText,
	@ShowHelpText,
	@QuestionGroupID)

set @QuestionID = Scope_Identity()

IF @@rowcount<>0 AND @SurveyID is not null AND @UpdateDisplayOrder = 1
BEGIN
	-- Update the display order
	UPDATE vts_tbQuestion 
	SET DisplayOrder = DisplayOrder + 1 
	WHERE 
		SurveyID = @SurveyID AND
		((QuestionID<>@QuestionID AND ParentQuestionID is null) OR
 		(ParentQuestionID is not null AND ParentQuestionID <> @QuestionID)) AND
 		DisplayOrder >= @DisplayOrder
END

COMMIT TRAN InsertQuestion



