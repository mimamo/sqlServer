USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLinkRemoveLink]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptLinkRemoveLink]
 (
  @LinkKey int
 )
AS --Encrypt
Delete From 
 tLink
Where
 LinkKey = @LinkKey
 
 return 1
GO
