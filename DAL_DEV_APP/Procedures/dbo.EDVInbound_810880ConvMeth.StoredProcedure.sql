USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVInbound_810880ConvMeth]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDVInbound_810880ConvMeth] @VendId varchar(15) As
Select ConvMeth From EDVInbound Where VendId = @VendId And Trans In ('810','880')
GO
