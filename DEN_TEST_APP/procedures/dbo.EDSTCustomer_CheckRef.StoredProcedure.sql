USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSTCustomer_CheckRef]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSTCustomer_CheckRef] @CustId varchar(15), @EDIShipToRef varchar(17) As
Select Count(*) From EDSTCustomer Where CustId = @CustId And EDIShipToRef = @EDIShipToRef
GO
