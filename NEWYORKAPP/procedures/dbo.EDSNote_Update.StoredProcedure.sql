USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSNote_Update]    Script Date: 12/21/2015 16:01:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSNote_Update] @Text As text, @RevisedDate smalldatetime, @nID as float  As
update Snote set snotetext =  @Text ,  dtRevisedDate = @RevisedDate where nID = @nID
GO
