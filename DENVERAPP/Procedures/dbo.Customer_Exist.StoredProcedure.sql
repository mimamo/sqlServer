USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Customer_Exist]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[Customer_Exist]
	@Customer char(15),
	@CustomerExistFlag bit OUTPUT
	
AS
	begin

	-- Check if the Customer passed in is found.  Set flag accordingly
	if exists(select * from Customer where custid = @Customer)
		select @CustomerExistFlag = 1
	else
		select @CustomerExistFlag = 0

	end
GO
