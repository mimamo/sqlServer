USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepGetKey]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepGetKey]  
 @Entity varchar(50),  
 @EntityKey int
AS --Encrypt  
  
/* Who Rel      What   
|| QMD 10.5.5.0 Created for art review
*/  
  
SELECT * FROM tApprovalStep (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey
GO
