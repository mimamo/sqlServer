USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSNote_Update]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSNote_Update] @Text As text, @RevisedDate smalldatetime, @nID as float  As
update Snote set snotetext =  @Text ,  dtRevisedDate = @RevisedDate where nID = @nID
GO
