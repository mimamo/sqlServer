USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormReopen]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptFormReopen]
 
  @FormKey int
 
AS --Encrypt
 UPDATE 
  tForm
 SET 
  DateClosed = null
 WHERE 
  FormKey = @FormKey
GO
