USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustomer_Status]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDCustomer_Status] @CustId varchar(15) As
Select Status From Customer Where CustId = @CustId
GO
