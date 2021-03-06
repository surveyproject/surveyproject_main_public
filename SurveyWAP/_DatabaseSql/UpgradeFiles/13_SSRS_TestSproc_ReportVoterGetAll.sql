USE [DBNAME]
GO
/****** Object:  StoredProcedure [dbo].[vts_spReportSsrsVoterGetAll]    Script Date: 1/1/2018 11:19:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		W3DevPro
-- Create date: 2017-09-27
-- Description:	Stored Procedure to get all Voter Data for SSRS reports Test
-- =============================================
CREATE PROCEDURE [dbo].[vts_spReportSsrsVoterGetAll] 

	-- Add the parameters for the stored procedure here
	-- @SurveyID int,
	-- @VoterID int

AS
BEGIN TRANSACTION GetVoterData
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

/*
	Start of Query to fetch all voterdata
*/

-- STEP 1.

SELECT 
VoterID, 
UID, 
SurveyID, 
ContextUserName, 
VoteDate, 
StartDate, 
IPSource, 
Validated, 
ResumeUID, 
ResumeAtPageNumber, 
ProgressSaveDate, 
ResumeQuestionNumber, 
ResumeHighestPageNumber, 
LanguageCode 

FROM vts_tbvoter

-- Finalize calculations
COMMIT TRANSACTION GetVoterData

