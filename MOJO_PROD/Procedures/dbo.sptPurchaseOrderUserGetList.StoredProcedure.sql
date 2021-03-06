USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderUserGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderUserGetList]

	@PurchaseOrderKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 09/22/10  MFT 10.5.3.5 Added Email and NotificationSent
|| 09/30/10  MFT 10.5.3.5 Added UserName to support SendNotification
*/

SELECT
	us.UserKey,
	LTRIM(RTRIM(ISNULL(FirstName,'') + ' ' + ISNULL(LastName,''))) AS UserName,
	CASE 
		WHEN us.Title is null THEN isnull(us.FirstName,'') + ' ' + isnull(us.LastName,'')
		ELSE isnull(us.FirstName,'') + ' ' + isnull(us.LastName,'') + '-' + isnull(us.Title,'') 
		END AS NameTitle,
	ISNULL(us.FirstName, '') + ' ' + ISNULL(us.LastName, '') as Name,
	us.Title,
	us.Email,
	ISNULL(NotificationSent, 0) AS NotificationSent
FROM tPurchaseOrderUser pu (nolock) inner join tUser us (nolock) on pu.UserKey = us.UserKey 
WHERE pu.PurchaseOrderKey = @PurchaseOrderKey

RETURN 1
GO
