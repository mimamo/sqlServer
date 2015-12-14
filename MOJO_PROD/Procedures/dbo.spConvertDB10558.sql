USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10558]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10558]
AS

-- If null, invoice printing will get client's address
update tInvoice set AddressKey = null where AddressKey = 0

--Seed new right (purch_printchecks) for entities with purch_editpayment right
INSERT INTO
	tRightAssigned
SELECT
	EntityType,
	EntityKey,
	61600
FROM
	tRightAssigned
WHERE
	RightKey = 61300
GO
