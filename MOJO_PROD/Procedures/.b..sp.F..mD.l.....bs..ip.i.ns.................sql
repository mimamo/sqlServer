USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormDeleteSubscriptions]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptFormDeleteSubscriptions]
 (
  @FormKey int
 )
AS --Encrypt

	DELETE tFormSubscription WHERE FormKey = @FormKey
GO
