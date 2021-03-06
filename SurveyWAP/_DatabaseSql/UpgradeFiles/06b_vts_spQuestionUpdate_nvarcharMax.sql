USE [DBname]
GO
/****** Object:  StoredProcedure [dbo].[vts_spQuestionUpdate]    Script Date: 8/19/2017 11:30:22 ******/
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

/// <summary>
/// Updates a question
/// </summary>
/// <param name="QuestionID">
/// ID of the question to update
/// </param>
/// <param name="@QuestionText">
/// Question's text
/// </param>
/// <param name="@SelectionModeID">
/// selection type of the question (checkbox, radio, matrix ..)
/// </param>
/// <param name="@LayoutModeID">
/// Layout of the question (horizontal, vertical ..)
/// </param>
/// <param name="@MinSelectionRequired">
/// Number of selection that question requires
/// </param>
/// <param name="@MaxSelectionRequired">
/// Number of max selection that question allows
/// </param>
*/
ALTER PROCEDURE [dbo].[vts_spQuestionUpdate] 
			@QuestionID int, 
			@QuestionText nvarchar(max),
			@SelectionModeId int,
			@LayoutModeId int,
			@ColumnsNumber int,
			@MinSelectionRequired int,
			@MaxSelectionAllowed int,
			@RandomizeAnswers bit,
			@RatingEnabled bit,
			@QuestionPipeAlias nvarchar(255),
			@LanguageCode nvarchar(50) = null,
			@QuestionGroupId int, 
			@ShowHelpText	bit,
			@HelpText	nvarchar(4000),
			@Alias	nvarchar(255),
			@QuestionIdText nvarchar(255)
AS
BEGIN TRAN UpdateQuestion

UPDATE vts_tbQuestion  
SET 	SelectionModeId=@SelectionModeId,
	LayoutModeId = @LayoutModeId,
	MinSelectionRequired = @MinSelectionRequired,
	MaxSelectionAllowed = @MaxSelectionAllowed,
	RandomizeAnswers = @RandomizeAnswers,
	RatingEnabled = @RatingEnabled,
	ColumnsNumber = @ColumnsNumber,
	QuestionPipeAlias = @QuestionPipeAlias,
	QuestionGroupId =case when  @QuestionGroupId=-1 then null else @QuestionGroupId end,
	ShowHelpText = @ShowHelpText,
	QuestionIDText=@QuestionIDText
WHERE
	QuestionID = @QuestionID

-- Updates Child question's options
UPDATE vts_tbQuestion  
SET 	SelectionModeId=@SelectionModeId,
	LayoutModeId = @LayoutModeId,
	MinSelectionRequired = @MinSelectionRequired,
	MaxSelectionAllowed = @MaxSelectionAllowed,
	RandomizeAnswers = @RandomizeAnswers,
	RatingEnabled = @RatingEnabled
WHERE
	ParentQuestionID = @QuestionID

-- Updates text
IF @LanguageCode is null OR @LanguageCode='' 
BEGIN
	UPDATE vts_tbQuestion
	SET 	QuestionText = @QuestionText,
		    HelpText =     @HelpText,
	        Alias =        @Alias
	WHERE
		QuestionID = @QuestionID
END
ELSE
BEGIN
	-- Updates localized text
	exec vts_spMultiLanguageTextUpdate @QuestionID, @LanguageCode, 3, @QuestionText
    exec vts_spMultiLanguageTextUpdate @QuestionID, @LanguageCode, 11, @HelpText
	exec vts_spMultiLanguageTextUpdate @QuestionID, @LanguageCode, 12, @Alias
	
END

COMMIT TRAN UpdateQuestion



