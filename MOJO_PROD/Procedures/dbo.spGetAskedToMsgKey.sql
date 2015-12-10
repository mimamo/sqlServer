USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetAskedToMsgKey]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetAskedToMsgKey]
	@MessageAskedToKey uniqueidentifier 
AS --Encrypt
	set nocount on
	
	select *
	  from tMessageAskedTo (nolock)
	 where MessageAskedToKey = @MessageAskedToKey
  
	return 1
GO
