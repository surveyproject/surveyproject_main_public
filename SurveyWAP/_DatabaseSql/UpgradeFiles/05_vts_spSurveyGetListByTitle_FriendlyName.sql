USE [DBname]
GO
/****** Object:  StoredProcedure [dbo].[vts_spSurveyGetListByTitle]    Script Date: 8/18/2017 18:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
/*
/// <summary>
/// Get all surveys from specified folder with surveyid, title, folderid and parentFolderId in the database
/// </summary>
*/
-- =============================================
ALTER PROCEDURE [dbo].[vts_spSurveyGetListByTitle] 
	@SurveyTitle varchar(200),
	@FolderId int = null,
	@UserID int 
AS
BEGIN
	SET NOCOUNT ON;

/* JJ  If @folderid is null then select from all folders.select @FolderId = FolderId from vts_tbFolders where @FolderId is null and ParentFolderId is null
 * Restrict Surveys by User
 * Recursively get foldera under given folder
*/
    -- Insert statements for procedure here
     with FolderList as (
    select folderid,parentfolderid from
    vts_tbfolders where folderId=@folderId
    union all
    select e.folderid,e.parentfolderid from
    vTs_tbfolders e inner join FolderList as cte on
    e.parentfolderid=cte.folderid 
    )
    SELECT 	sv.SurveyID,
	sv.UnAuthentifiedUserActionID,
	sv.CreationDate,
	sv.Title,
	sv.AccessPassword,
	sv.RedirectionURL, 
	sv.OpenDate,
	sv.CloseDate,
	sv.LastEntryDate,
	(Select count(*) FROM vts_tbVoter WHERE Validated<>0 AND SurveyID = sv.SurveyID) as VoterNumber,
	(Select max(PageNumber) FROM vts_tbQuestion WHERE SurveyID = sv.SurveyID) as TotalPageNumber,
	sv.SurveyDisplayTimes,
	sv.ResultsDisplayTimes,
	sv.Archive,
	sv.Activated,
	sv.IPExpires,
	sv.CookieExpires,
	sv.OnlyInvited,
	sv.NavigationEnabled,
	sv.ProgressDisplayModeId,
	sv.NotificationModeId,
	sv.ResumeModeId,
	em.EmailFrom,
	em.EmailTo,
	em.EmailSubject,
	sv.Scored,
	sv.AllowMultipleUserNameSubmissions,
	sv.QuestionNumberingDisabled,
	sv.AllowMultipleNSurveySubmissions,
	sv.MultiLanguageModeId,
	sv.MultiLanguageVariable,
	isnull(sv.FriendlyName, '-') as FriendlyName
	FROM vts_tbSurvey AS sv
	LEFT JOIN vts_tbEmailNotificationSettings em
	ON sv.SurveyID = em.SurveyID
	WHERE sv.Title like '%' + ISNULL(@SurveyTitle, '') + '%'
	and( sv.FolderId in (select folderid from folderlist) or @FolderId is null)
	AND (exists(
	    select 1 from vts_tbUserSurvey as usr
	    where usr.surveyId=sv.surveyId and usr.UserId=@UserId )
	    or exists (
	    select 1 from vts_tbUserSetting st
	    where st.userid=@userid
	    and (st.Isadmin=1 or st.GlobalSurveyAccess=1)
	    )
	    )
	
END
