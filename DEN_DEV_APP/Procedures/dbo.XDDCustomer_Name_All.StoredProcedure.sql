USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDCustomer_Name_All]    Script Date: 12/21/2015 14:06:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[XDDCustomer_Name_All]
	@Name		varchar(30)
AS
SELECT * FROM Customer
WHERE Name LIKE @Name
ORDER BY Name
GO
