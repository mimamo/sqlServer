USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptServiceDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptServiceDelete]
 @ServiceKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/19/11   CRG 10.5.4.8 (121294) Added delete of tLayoutBilling for this service
|| 09/19/14  WDF 10.5.8.4 Added delete of tTitleService for this service
*/

if exists(select 1 from tTime (NOLOCK) Where ServiceKey = @ServiceKey)
	return -1
if exists(select 1 from tEstimateTaskLabor (NOLOCK) Where ServiceKey = @ServiceKey and Hours > 0)
	return -1
 

 DELETE
 FROM tEstimateTaskLabor
 WHERE
  ServiceKey = @ServiceKey

 DELETE
 FROM tTimeRateSheetDetail
 WHERE
  ServiceKey = @ServiceKey

 DELETE	tLayoutBilling
 WHERE	Entity = 'tService'
 AND	EntityKey = @ServiceKey

 DELETE
 FROM tTitleService
 WHERE
  ServiceKey = @ServiceKey
	  
 DELETE
 FROM tService
 WHERE
  ServiceKey = @ServiceKey 
 RETURN 1
GO
