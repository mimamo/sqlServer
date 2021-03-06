USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWorkTypeDelete]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWorkTypeDelete]
	@WorkTypeKey int

AS --Encrypt

/*
|| When         Who    Rel      What
|| 07/31/07     GHL    8.5      removed ref to expense type
|| 5/5/11       CRG    10.5.4.4 (110628) Now deleting from tLayoutBilling when the billing item is deleted
|| 01/09/15     GHL    10.5.8.8 (241754) Now deleting from tLayoutBilling parent entity when the billing item is deleted
*/

	if exists(select 1 from tTask (NOLOCK) where WorkTypeKey = @WorkTypeKey)
		return -1
	if exists(select 1 from tInvoiceLine (NOLOCK) where WorkTypeKey = @WorkTypeKey)
		return -1
	if exists(select 1 from tItem (NOLOCK) where WorkTypeKey = @WorkTypeKey)
		return -1
	if exists(select 1 from tService (NOLOCK) where WorkTypeKey = @WorkTypeKey)
		return -1
	if exists(select 1 from tPreference (NOLOCK) where AdvBillItemKey = @WorkTypeKey)
		return -1

	if @WorkTypeKey > 0
	DELETE	tLayoutBilling
	WHERE	Entity = 'tWorkType'
	AND		EntityKey = @WorkTypeKey

	if @WorkTypeKey > 0
	DELETE	tLayoutBilling
	WHERE	ParentEntity = 'tWorkType'
	AND		ParentEntityKey = @WorkTypeKey

	DELETE
	FROM tWorkType
	WHERE
		WorkTypeKey = @WorkTypeKey 

	RETURN 1
GO
