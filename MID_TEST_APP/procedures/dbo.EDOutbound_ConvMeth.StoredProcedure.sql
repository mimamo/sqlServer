USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_ConvMeth]    Script Date: 12/21/2015 15:49:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDOutbound_ConvMeth] @CustId varchar(15), @Trans varchar(3) As
Select ConvMeth From EDOutbound Where CustId = @CustId And Trans = @Trans
GO
