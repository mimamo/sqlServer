USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDEN_ProjectMainProductLabel]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDEN_ProjectMainProductLabel] @Client varchar(15), @Product varchar(30)
AS

DECLARE 
	@ClientName char(30),
	@ProductName char(30)
SELECT
	@ClientName = ISNULL(Customer.Name, '')
FROM
	Customer
WHERE
	CustID = @Client

SELECT
	@ProductName = ISNULL(descr, '')
FROM
	xIGProdCode
WHERE
	code_id = @Product
SELECT
	@ClientName as Client,
	@ProductName as Product
GO
