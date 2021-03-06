USE [sp25dev]
GO
/****** Object:  StoredProcedure [dbo].[vts_spQuestionOrderUpdate]    Script Date: 3/25/2020 18:20:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[vts_spQuestionOrderUpdate] 
@QuestionID int, 
@UpdateUp  bit = 0 -- 1 to move up, or zero to move down
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @NewDisplayOrder int, @LibId int, @OldQuestionId int
declare @OrderIndex int, @CurrentDisplayOrder int, @MaxOrderId int
declare @QID int

select @LibId = LibraryID from vts_tbQuestion where QuestionId = @QuestionID

create table #tempQuestions
    (QuestionId int, DisplayOrder int)

insert #tempQuestions 
	select QuestionId, DisplayOrder 
	from vts_tbQuestion 
	where LibraryID = @LibId AND ParentQuestionId is NULL
	order by DisplayOrder 

DECLARE cursorQuestions CURSOR for
 SELECT QuestionId, DisplayOrder FROM #tempQuestions order by DisplayOrder

 -- we make reorder of displayorder in case of duplicating displayorderid
 set @OrderIndex = 0
 OPEN cursorQuestions
 FETCH NEXT FROM cursorQuestions
 INTO @QID, @CurrentDisplayOrder
 While @@FETCH_STATUS = 0
 Begin
	set @OrderIndex = @OrderIndex + 1
	UPDATE vts_tbQuestion SET DisplayOrder = @OrderIndex WHERE QuestionId = @QID
	FETCH NEXT FROM cursorQuestions
		INTO @QID, @CurrentDisplayOrder
 End
 CLOSE cursorQuestions;
 DEALLOCATE cursorQuestions;
 drop table #tempQuestions;

 select @MaxOrderId = MAX(DisplayOrder) from vts_tbQuestion where LibraryID = @LibId AND ParentQuestionId is NULL
 select @CurrentDisplayOrder = DisplayOrder, @LibId = LibraryID from vts_tbQuestion where QuestionId = @QuestionID
 
 if @UpdateUp > 0
	set @NewDisplayOrder = @CurrentDisplayOrder - 1
 else
	set @NewDisplayOrder = @CurrentDisplayOrder + 1 
       
 if @NewDisplayOrder < 1
	set @NewDisplayOrder = 1
 if @NewDisplayOrder >= @MaxOrderId
	set @NewDisplayOrder = @MaxOrderId

 select @OldQuestionId = QuestionId from vts_tbQuestion where DisplayOrder = @NewDisplayOrder and LibraryID = @LibId
 
 update vts_tbQuestion set DisplayOrder = @NewDisplayOrder 
	where QuestionId = @QuestionId 
 
 update vts_tbQuestion set DisplayOrder = @CurrentDisplayOrder 
	where QuestionId = @OldQuestionId 
  
END



